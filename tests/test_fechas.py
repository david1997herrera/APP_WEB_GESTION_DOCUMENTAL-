"""La fecha de fin de una programación no puede quedar antes del inicio."""

import unittest
from datetime import datetime

from app.dominio.fechas import fin_es_anterior_al_inicio


class PruebasFechas(unittest.TestCase):
    def test_fin_anterior_al_inicio_no_se_acepta(self):
        inicio = datetime(2026, 11, 2)
        fin = datetime(2026, 4, 30)
        self.assertTrue(fin_es_anterior_al_inicio(inicio, fin))

    def test_el_mismo_dia_si_se_acepta(self):
        dia = datetime(2026, 11, 2, 8, 0)
        fin = datetime(2026, 11, 2)
        self.assertFalse(fin_es_anterior_al_inicio(dia, fin))

    def test_sin_fin_no_hay_conflicto(self):
        self.assertFalse(fin_es_anterior_al_inicio(datetime(2026, 11, 2), None))


if __name__ == '__main__':
    unittest.main()
