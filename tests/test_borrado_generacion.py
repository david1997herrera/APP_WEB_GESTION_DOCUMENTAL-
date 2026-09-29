"""Borrar una generacion periodica quita todas las copias y no se regenera."""

import unittest
from datetime import datetime, timedelta

from flask import Flask

import app.models  # registra las tablas antes de create_all
from app.config import db
from app.controllers.scheduled_task_controller import (
    _process_single_scheduled_task,
    marcar_corrida_atendida,
)
from app.models.area import Area
from app.models.scheduled_task import ScheduledTask, ScheduledTaskUser
from app.models.task import Task
from app.models.user import User
from app.services.borrado_tareas import eliminar_tareas


class PruebasBorradoGeneracion(unittest.TestCase):
    def setUp(self):
        self.aplicacion = Flask(__name__)
        self.aplicacion.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite://'
        self.aplicacion.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
        self.aplicacion.config['SECRET_KEY'] = 'prueba'
        db.init_app(self.aplicacion)
        self.contexto = self.aplicacion.app_context()
        self.contexto.push()
        db.create_all()

        self.area = Area(name='Sanidad', description='Prueba', is_active=True)
        self.autora = User(username='admin_prueba', email='admin_prueba@example.com', role='admin', is_active=True)
        self.persona_a = User(username='persona_a', email='persona_a@example.com', role='escritura', is_active=True)
        self.persona_b = User(username='persona_b', email='persona_b@example.com', role='escritura', is_active=True)
        db.session.add_all([self.area, self.autora, self.persona_a, self.persona_b])
        db.session.commit()

        corrida = datetime.utcnow().replace(second=0, microsecond=0) - timedelta(hours=2)
        self.programacion = ScheduledTask(
            title='Informe compartido',
            description='Misma tarea para dos personas',
            area_id=self.area.id,
            created_by=self.autora.id,
            frequency='mensual',
            interval=1,
            priority='media',
            start_date=corrida,
            next_run_at=corrida,
            is_active=True,
        )
        self.programacion.assigned_users = [self.persona_a, self.persona_b]
        db.session.add(self.programacion)
        db.session.commit()

        self.corrida = corrida
        for persona in (self.persona_a, self.persona_b):
            db.session.add(Task(
                title='Informe compartido',
                area_id=self.area.id,
                created_by=self.autora.id,
                assigned_to=persona.id,
                scheduled_task_id=self.programacion.id,
                corrida_en=corrida,
            ))
        db.session.commit()

    def tearDown(self):
        db.session.remove()
        db.drop_all()
        db.engine.dispose()
        self.contexto.pop()

    def test_borrar_una_copia_quita_a_las_dos_personas_y_no_recrea(self):
        primera = Task.query.filter_by(assigned_to=self.persona_a.id).one()
        generacion = Task.de_la_misma_generacion(primera)
        self.assertEqual(len(generacion), 2)

        eliminar_tareas(generacion)
        marcar_corrida_atendida(self.programacion, primera.corrida_en)
        db.session.commit()

        self.assertEqual(Task.query.count(), 0)
        self.assertGreater(self.programacion.next_run_at, datetime.utcnow())

        _process_single_scheduled_task(self.programacion, datetime.utcnow())
        db.session.commit()
        self.assertEqual(Task.query.count(), 0)

        for persona in (self.persona_a, self.persona_b):
            db.session.add(Task(
                title='Informe compartido',
                area_id=self.area.id,
                created_by=self.autora.id,
                assigned_to=persona.id,
                scheduled_task_id=self.programacion.id,
                corrida_en=self.corrida,
            ))
        db.session.commit()
        generadas = Task.query.filter_by(scheduled_task_id=self.programacion.id).all()
        eliminar_tareas(generadas)
        self.programacion.assigned_users = []
        db.session.flush()
        ScheduledTaskUser.query.filter_by(scheduled_task_id=self.programacion.id).delete(
            synchronize_session=False
        )
        db.session.delete(self.programacion)
        db.session.commit()
        self.assertEqual(Task.query.count(), 0)
        self.assertIsNone(db.session.get(ScheduledTask, self.programacion.id))


if __name__ == '__main__':
    unittest.main()
