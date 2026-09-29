"""Vigencia del enlace y reglas de la contraseña nueva."""

import unittest
from datetime import datetime, timedelta

from app.dominio.restablecimiento import (
    contrasena_aceptable,
    enlace_sigue_vigente,
    momento_de_vencimiento,
)


class PruebasRestablecimiento(unittest.TestCase):
    def test_el_enlace_vence_a_los_cinco_minutos(self):
        ahora = datetime(2026, 9, 29, 10, 0, 0)
        vence = momento_de_vencimiento(ahora)
        self.assertEqual(vence, ahora + timedelta(minutes=5))
        self.assertTrue(enlace_sigue_vigente(vence, None, ahora + timedelta(minutes=4)))
        self.assertFalse(enlace_sigue_vigente(vence, None, ahora + timedelta(minutes=6)))

    def test_un_enlace_usado_no_vuelve_a_servir(self):
        ahora = datetime(2026, 9, 29, 10, 0, 0)
        self.assertFalse(enlace_sigue_vigente(ahora + timedelta(minutes=5), ahora, ahora))

    def test_la_contrasena_debe_coincidir_y_tener_ocho_caracteres(self):
        self.assertFalse(contrasena_aceptable('corta', 'corta'))
        self.assertFalse(contrasena_aceptable('contrasena-larga', 'otra-distinta'))
        self.assertTrue(contrasena_aceptable('contrasena-larga', 'contrasena-larga'))
