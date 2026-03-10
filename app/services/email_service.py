from flask_mail import Message
from flask import current_app
import os
from app.config import db
from app.models.user import User
from app.models.task import Task
from app.models.area import Area
from app.models.purchase_requisition import PurchaseRequisition

class EmailService:
    """Servicio para envío de notificaciones por email"""
    
    @staticmethod
    def send_email(to, subject, body, html=None):
        """Enviar email básico"""
        try:
            from main import mail
            import os
            
            msg = Message(
                subject=subject,
                recipients=[to],
                body=body,
                html=html,
                sender=os.getenv('EMAIL_SENDER', 'harvest.hero.app@gmail.com')
            )
            mail.send(msg)
            print(f"✅ Email enviado exitosamente a: {to}")
            return True
        except Exception as e:
            print(f"❌ Error enviando email a {to}: {e}")
            return False
    
    @staticmethod
    def notify_task_assigned(task_id, user_id):
        """Notificar cuando se asigna una tarea a un usuario"""
        try:
            task = Task.query.get(task_id)
            user = User.query.get(user_id)
            
            if not task or not user:
                return False
            
            subject = f"📋 Nueva tarea asignada: {task.title}"
            base_url = os.getenv('APP_BASE_URL', 'http://localhost:3110')
            body = f"""
Hola {user.username},

Se te ha asignado una nueva tarea:

📋 Título: {task.title}
📁 Área: {task.area.name}
📝 Descripción: {task.description or 'Sin descripción'}
📅 Fecha límite: {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'No especificada'}
📊 Archivos requeridos: {task.required_files}
⚡ Prioridad: {task.priority.title()}

Puedes ver la tarea en: {base_url}/tasks/{task_id}

Saludos,
Sistema de Gestión Documental
            """
            
            html = f"""
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2 style="color: #3498db;">📋 Nueva tarea asignada</h2>
                <p>Hola <strong>{user.username}</strong>,</p>
                <p>Se te ha asignado una nueva tarea:</p>
                
                <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
                    <h3 style="margin-top: 0; color: #2c3e50;">{task.title}</h3>
                    <p><strong>📁 Área:</strong> {task.area.name}</p>
                    <p><strong>📝 Descripción:</strong> {task.description or 'Sin descripción'}</p>
                    <p><strong>📅 Fecha límite:</strong> {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'No especificada'}</p>
                    <p><strong>📊 Archivos requeridos:</strong> {task.required_files}</p>
                    <p><strong>⚡ Prioridad:</strong> {task.priority.title()}</p>
                </div>
                
                <div style="text-align: center; margin: 30px 0;">
                    <a href="{base_url}/tasks/{task_id}" 
                       style="background: #3498db; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">
                        Ver Tarea
                    </a>
                </div>
                
                <p style="color: #7f8c8d; font-size: 12px;">
                    Saludos,<br>
                    Sistema de Gestión Documental
                </p>
            </div>
            """
            
            return EmailService.send_email(user.email, subject, body, html)
            
        except Exception as e:
            print(f"Error notificando asignación de tarea: {e}")
            return False
    
    @staticmethod
    def notify_task_completed(task_id):
        """Notificar cuando se completa una tarea"""
        try:
            task = Task.query.get(task_id)
            if not task:
                return False
            
            # Notificar al creador de la tarea
            creator = User.query.get(task.created_by)
            if creator and creator.email:
                subject = f"✅ Tarea completada: {task.title}"
                base_url = os.getenv('APP_BASE_URL', 'http://localhost:3110')
                body = f"""
Hola {creator.username},

La tarea "{task.title}" ha sido completada.

📋 Título: {task.title}
📁 Área: {task.area.name}
👤 Asignado a: {task.assignee.username if task.assignee else 'Sin asignar'}
📊 Archivos subidos: {task.uploaded_files}/{task.required_files}
✅ Completada el: {task.completed_at.strftime('%d/%m/%Y %H:%M')}

Puedes ver la tarea en: {base_url}/tasks/{task_id}

Saludos,
Sistema de Gestión Documental
                """
                
                html = f"""
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h2 style="color: #27ae60;">✅ Tarea completada</h2>
                    <p>Hola <strong>{creator.username}</strong>,</p>
                    <p>La tarea <strong>"{task.title}"</strong> ha sido completada.</p>
                    
                    <div style="background: #d5f4e6; padding: 15px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #27ae60;">
                        <h3 style="margin-top: 0; color: #2c3e50;">{task.title}</h3>
                        <p><strong>📁 Área:</strong> {task.area.name}</p>
                        <p><strong>👤 Asignado a:</strong> {task.assignee.username if task.assignee else 'Sin asignar'}</p>
                        <p><strong>📊 Archivos subidos:</strong> {task.uploaded_files}/{task.required_files}</p>
                        <p><strong>✅ Completada el:</strong> {task.completed_at.strftime('%d/%m/%Y %H:%M')}</p>
                    </div>
                    
                    <div style="text-align: center; margin: 30px 0;">
                        <a href="{base_url}/tasks/{task_id}" 
                           style="background: #27ae60; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">
                            Ver Tarea
                        </a>
                    </div>
                    
                    <p style="color: #7f8c8d; font-size: 12px;">
                        Saludos,<br>
                        Sistema de Gestión Documental
                    </p>
                </div>
                """
                
                return EmailService.send_email(creator.email, subject, body, html)
            
            return False
            
        except Exception as e:
            print(f"Error notificando tarea completada: {e}")
            return False
    
    @staticmethod
    def notify_user_created(user_email, username, password, role):
        """Notificar cuando se crea un nuevo usuario"""
        try:
            subject = f"👤 Cuenta creada - Sistema de Gestión Documental"
            base_url = os.getenv('APP_BASE_URL', 'http://localhost:3110')
            body = f"""
Hola {username},

Se ha creado tu cuenta en el Sistema de Gestión Documental.

📧 Email: {user_email}
👤 Usuario: {username}
🔑 Contraseña: {password}
🎭 Rol: {role.title()}

Puedes acceder al sistema en: {base_url}

IMPORTANTE: Te recomendamos cambiar tu contraseña en tu primer acceso.

Saludos,
Sistema de Gestión Documental
            """
            
            html = f"""
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2 style="color: #3498db;">👤 Cuenta creada</h2>
                <p>Hola <strong>{username}</strong>,</p>
                <p>Se ha creado tu cuenta en el Sistema de Gestión Documental.</p>
                
                <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
                    <p><strong>📧 Email:</strong> {user_email}</p>
                    <p><strong>👤 Usuario:</strong> {username}</p>
                    <p><strong>🔑 Contraseña:</strong> <code style="background: #e9ecef; padding: 2px 4px; border-radius: 3px;">{password}</code></p>
                    <p><strong>🎭 Rol:</strong> {role.title()}</p>
                </div>
                
                <div style="background: #fff3cd; padding: 15px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #ffc107;">
                    <p style="margin: 0;"><strong>⚠️ IMPORTANTE:</strong> Te recomendamos cambiar tu contraseña en tu primer acceso.</p>
                </div>
                
                <div style="text-align: center; margin: 30px 0;">
                    <a href="{base_url}" 
                       style="background: #3498db; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">
                        Acceder al Sistema
                    </a>
                </div>
                
                <p style="color: #7f8c8d; font-size: 12px;">
                    Saludos,<br>
                    Sistema de Gestión Documental
                </p>
            </div>
            """
            
            return EmailService.send_email(user_email, subject, body, html)
            
        except Exception as e:
            print(f"Error notificando usuario creado: {e}")
            return False

    @staticmethod
    def notify_user_assigned_to_area(user_id, area_id):
        """Notificar a un usuario cuando es asignado a un área"""
        try:
            user = User.query.get(user_id)
            area = Area.query.get(area_id)
            if not user or not area:
                return False

            subject = f"📁 Asignación de área: {area.name}"
            base_url = os.getenv('APP_BASE_URL', 'http://localhost:3110')
            body = f"""
Hola {user.username},

Has sido asignado al área "{area.name}" en el Sistema de Gestión Documental.

Puedes acceder al sistema en: {base_url}

Saludos,
Sistema de Gestión Documental
            """
            html = f"""
            <div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;\">
                <h2 style=\"color: #3498db;\">📁 Nueva asignación de área</h2>
                <p>Hola <strong>{user.username}</strong>,</p>
                <p>Has sido asignado al área <strong>{area.name}</strong>.</p>
                <div style=\"text-align: center; margin: 30px 0;\">
                    <a href=\"{base_url}\" 
                       style=\"background: #3498db; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;\">
                        Ir al sistema
                    </a>
                </div>
            </div>
            """
            return EmailService.send_email(user.email, subject, body, html)
        except Exception as e:
            print(f"Error notificando asignación de área: {e}")
            return False

    @staticmethod
    def notify_password_reset(user_email, username, new_password):
        """Notificar al usuario que su contraseña ha sido actualizada"""
        try:
            subject = "🔐 Contraseña actualizada - Sistema de Gestión Documental"
            base_url = os.getenv('APP_BASE_URL', 'http://localhost:3110')
            body = f"""
Hola {username},

Tu contraseña ha sido actualizada por el administrador.

👤 Usuario: {username}
🔑 Nueva contraseña: {new_password}

Puedes acceder al sistema en: {base_url}

Saludos,
Sistema de Gestión Documental
            """
            html = f"""
            <div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;\">
                <h2 style=\"color: #3498db;\">🔐 Contraseña actualizada</h2>
                <p>Hola <strong>{username}</strong>,</p>
                <p>Tu contraseña ha sido actualizada por el administrador.</p>
                <div style=\"background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;\">
                    <p><strong>👤 Usuario:</strong> {username}</p>
                    <p><strong>🔑 Nueva contraseña:</strong> <code style=\"background: #e9ecef; padding: 2px 4px; border-radius: 3px;\">{new_password}</code></p>
                </div>
                <div style=\"text-align: center; margin: 30px 0;\">
                    <a href=\"{base_url}\" 
                       style=\"background: #3498db; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;\">
                        Acceder al Sistema
                    </a>
                </div>
            </div>
            """
            return EmailService.send_email(user_email, subject, body, html)
        except Exception as e:
            print(f"Error notificando cambio de contraseña: {e}")
            return False

    @staticmethod
    def notify_file_uploaded(task_id, uploaded_by_user_id, filename):
        """Notificar al admin cuando se sube un archivo"""
        try:
            task = Task.query.get(task_id)
            uploaded_by = User.query.get(uploaded_by_user_id)
            admin_users = User.query.filter_by(role='admin').all()
            
            if not task or not uploaded_by or not admin_users:
                return False
            
            subject = f"📎 Archivo subido: {task.title}"
            base_url = os.getenv('APP_BASE_URL', 'http://localhost:3110')
            body = f"""
Hola Administrador,

Se ha subido un nuevo archivo a la tarea "{task.title}".

📋 Tarea: {task.title}
📁 Área: {task.area.name}
👤 Subido por: {uploaded_by.username}
📎 Archivo: {filename}
📊 Progreso: {task.uploaded_files}/{task.required_files} archivos
📅 Fecha límite: {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'No especificada'}

Puedes ver la tarea en: {base_url}/tasks/{task_id}

Saludos,
Sistema de Gestión Documental
            """
            
            html = f"""
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2 style="color: #3498db;">📎 Archivo subido</h2>
                <p>Hola <strong>Administrador</strong>,</p>
                <p>Se ha subido un nuevo archivo a la tarea <strong>"{task.title}"</strong>.</p>
                
                <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
                    <h3 style="margin-top: 0; color: #2c3e50;">{task.title}</h3>
                    <p><strong>📁 Área:</strong> {task.area.name}</p>
                    <p><strong>👤 Subido por:</strong> {uploaded_by.username}</p>
                    <p><strong>📎 Archivo:</strong> {filename}</p>
                    <p><strong>📊 Progreso:</strong> {task.uploaded_files}/{task.required_files} archivos</p>
                    <p><strong>📅 Fecha límite:</strong> {task.due_date.strftime('%d/%m/%Y') if task.due_date else 'No especificada'}</p>
                </div>
                
                <div style="text-align: center; margin: 30px 0;">
                    <a href="{base_url}/tasks/{task_id}" 
                       style="background: #3498db; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">
                        Ver Tarea
                    </a>
                </div>
                
                <p style="color: #7f8c8d; font-size: 12px;">
                    Saludos,<br>
                    Sistema de Gestión Documental
                </p>
            </div>
            """
            
            # Enviar a todos los administradores
            for admin in admin_users:
                if admin.email:
                    EmailService.send_email(admin.email, subject, body, html)
            
            return True
            
        except Exception as e:
            print(f"Error notificando subida de archivo: {e}")
            return False

    @staticmethod
    def notify_task_overdue(task_id):
        """Notificar cuando una tarea está vencida"""
        try:
            task = Task.query.get(task_id)
            if not task or not task.due_date:
                return False
            
            # Notificar al asignado y al creador
            recipients = []
            if task.assignee and task.assignee.email:
                recipients.append(task.assignee.email)
            if task.creator and task.creator.email and task.creator.email not in [r for r in recipients]:
                recipients.append(task.creator.email)
            
            if not recipients:
                return False
            
            subject = f"⚠️ Tarea vencida: {task.title}"
            base_url = os.getenv('APP_BASE_URL', 'http://localhost:3110')
            body = f"""
Hola,

La tarea "{task.title}" ha vencido.

📋 Tarea: {task.title}
📁 Área: {task.area.name}
📅 Fecha límite: {task.due_date.strftime('%d/%m/%Y')}
📊 Progreso: {task.uploaded_files}/{task.required_files} archivos
⚡ Prioridad: {task.priority.title()}

Puedes ver la tarea en: {base_url}/tasks/{task_id}

Saludos,
Sistema de Gestión Documental
            """
            
            html = f"""
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2 style="color: #e74c3c;">⚠️ Tarea vencida</h2>
                <p>Hola,</p>
                <p>La tarea <strong>"{task.title}"</strong> ha vencido.</p>
                
                <div style="background: #f8d7da; padding: 15px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #e74c3c;">
                    <h3 style="margin-top: 0; color: #2c3e50;">{task.title}</h3>
                    <p><strong>📁 Área:</strong> {task.area.name}</p>
                    <p><strong>📅 Fecha límite:</strong> {task.due_date.strftime('%d/%m/%Y')}</p>
                    <p><strong>📊 Progreso:</strong> {task.uploaded_files}/{task.required_files} archivos</p>
                    <p><strong>⚡ Prioridad:</strong> {task.priority.title()}</p>
                </div>
                
                <div style="text-align: center; margin: 30px 0;">
                    <a href="{base_url}/tasks/{task_id}" 
                       style="background: #e74c3c; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">
                        Ver Tarea
                    </a>
                </div>
                
                <p style="color: #7f8c8d; font-size: 12px;">
                    Saludos,<br>
                    Sistema de Gestión Documental
                </p>
            </div>
            """
            
            # Enviar a todos los destinatarios
            for recipient in recipients:
                EmailService.send_email(recipient, subject, body, html)
            
            return True
            
        except Exception as e:
            print(f"Error notificando tarea vencida: {e}")
            return False

    @staticmethod
    def notify_purchase_requisition_created(requisition_id):
        """Notificar al destinatario (o administradores) cuando se crea una requisición de compra."""
        try:
            requisition = PurchaseRequisition.query.get(requisition_id)
            if not requisition:
                return False

            subject = f"🛒 Nueva requisición de compra: {requisition.title}"
            base_url = os.getenv('APP_BASE_URL', 'http://localhost:3110')

            amount_text = f"${requisition.amount:,.2f}" if requisition.amount is not None else "No especificado"
            requester_name = requisition.requester.username if requisition.requester else "N/D"
            target = requisition.target_user

            # Destinatario principal: target_user; si no hay, se envía a admins
            body = f"""
Hola {target.username if target else 'Administrador'},

Se ha enviado una nueva requisición de compra.

🧾 Título: {requisition.title}
👤 Solicitante: {requester_name}
💰 Monto estimado: {amount_text}
📝 Descripción: {requisition.description or 'Sin descripción'}
📅 Fecha: {requisition.created_at.strftime('%d/%m/%Y %H:%M') if requisition.created_at else 'N/D'}

Puedes revisar la requisición en: {base_url}/requisitions/{requisition_id}

Saludos,
Sistema de Gestión Documental
            """

            html = f"""
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2 style="color: #3498db;">🛒 Nueva requisición de compra</h2>
                <p>Hola <strong>{target.username if target else 'Administrador'}</strong>,</p>
                <p>Se ha enviado una nueva requisición de compra:</p>

                <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
                    <h3 style="margin-top: 0; color: #2c3e50;">{requisition.title}</h3>
                    <p><strong>👤 Solicitante:</strong> {requester_name}</p>
                    <p><strong>💰 Monto estimado:</strong> {amount_text}</p>
                    <p><strong>📝 Descripción:</strong> {requisition.description or 'Sin descripción'}</p>
                    <p><strong>📅 Fecha:</strong> {requisition.created_at.strftime('%d/%m/%Y %H:%M') if requisition.created_at else 'N/D'}</p>
                </div>

                <div style="text-align: center; margin: 30px 0;">
                    <a href="{base_url}/requisitions/{requisition_id}" 
                       style="background: #3498db; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">
                        Ver Requisición
                    </a>
                </div>

                <p style="color: #7f8c8d; font-size: 12px;">
                    Saludos,<br>
                    Sistema de Gestión Documental
                </p>
            </div>
            """

            if target and target.email:
                EmailService.send_email(target.email, subject, body, html)
            else:
                admin_users = User.query.filter_by(role='admin').all()
                for admin in admin_users:
                    if admin.email:
                        EmailService.send_email(admin.email, subject, body, html)

            return True
        except Exception as e:
            print(f"Error notificando requisición de compra: {e}")
            return False

    @staticmethod
    def notify_purchase_requisition_status_changed(requisition_id):
        """Notificar al solicitante cuando cambia el estado de su requisición."""
        try:
            requisition = PurchaseRequisition.query.get(requisition_id)
            if not requisition or not requisition.requester or not requisition.requester.email:
                return False

            user = requisition.requester
            subject = f"🛒 Estado actualizado de tu requisición: {requisition.title}"
            base_url = os.getenv('APP_BASE_URL', 'http://localhost:3110')
            amount_text = f"${requisition.amount:,.2f}" if requisition.amount is not None else "No especificado"

            body = f"""
Hola {user.username},

El estado de tu requisición de compra ha cambiado.

🧾 Título: {requisition.title}
💰 Monto estimado: {amount_text}
📊 Nuevo estado: {requisition.status.title()}

Puedes ver los detalles en: {base_url}/requisitions/{requisition_id}

Saludos,
Sistema de Gestión Documental
            """

            html = f"""
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2 style="color: #3498db;">🛒 Estado actualizado de tu requisición</h2>
                <p>Hola <strong>{user.username}</strong>,</p>
                <p>El estado de tu requisición de compra ha cambiado:</p>

                <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
                    <h3 style="margin-top: 0; color: #2c3e50;">{requisition.title}</h3>
                    <p><strong>💰 Monto estimado:</strong> {amount_text}</p>
                    <p><strong>📊 Nuevo estado:</strong> {requisition.status.title()}</p>
                </div>

                <div style="text-align: center; margin: 30px 0;">
                    <a href="{base_url}/requisitions/{requisition_id}" 
                       style="background: #3498db; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">
                        Ver Requisición
                    </a>
                </div>

                <p style="color: #7f8c8d; font-size: 12px;">
                    Saludos,<br>
                    Sistema de Gestión Documental
                </p>
            </div>
            """

            return EmailService.send_email(user.email, subject, body, html)
        except Exception as e:
            print(f"Error notificando cambio de estado de requisición: {e}")
            return False
