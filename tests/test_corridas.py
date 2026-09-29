"""Reglas de corrida: borrar una generacion no autoriza a crearla de nuevo."""

import unittest
from datetime import datetime, timedelta

from app.dominio.corridas import debe_omitir_creacion, momento_consumido


class PruebasCorridas(unittest.TestCase):
    def test_la_misma_corrida_no_se_vuelve_a_crear_despues_de_borrar(self):
        corrida = datetime(2026, 9, 28, 8, 0)
        self.assertTrue(debe_omitir_creacion(corrida, corrida))
        self.assertTrue(debe_omitir_creacion(corrida, corrida - timedelta(hours=1)))

    def test_el_siguiente_periodo_si_se_crea(self):
        ultima = datetime(2026, 9, 28, 8, 0)
        siguiente = datetime(2026, 12, 28, 8, 0)
        self.assertFalse(debe_omitir_creacion(ultima, siguiente))

    def test_sin_historial_la_corrida_se_crea(self):
        self.assertFalse(debe_omitir_creacion(None, datetime(2026, 9, 28, 8, 0)))

    def test_al_borrar_queda_consumida_la_proxima_vencida(self):
        ahora = datetime(2026, 9, 28, 15, 0)
        proxima_vencida = datetime(2026, 9, 28, 8, 0)
        consumido = momento_consumido(None, datetime(2026, 9, 28, 0, 0), proxima_vencida, ahora)
        self.assertEqual(consumido, proxima_vencida)
        self.assertTrue(debe_omitir_creacion(consumido, proxima_vencida))

    def test_una_proxima_futura_no_se_marca_como_consumida(self):
        ahora = datetime(2026, 9, 28, 15, 0)
        corrida = datetime(2026, 9, 28, 8, 0)
        proxima = datetime(2026, 12, 28, 8, 0)
        consumido = momento_consumido(None, corrida, proxima, ahora)
        self.assertEqual(consumido, corrida)
        self.assertFalse(debe_omitir_creacion(consumido, proxima))


if __name__ == '__main__':
    unittest.main()
