"""La hora de negocio es la de Ecuador, cinco horas detrás de UTC."""

import unittest
from datetime import datetime, timedelta, timezone

from app.dominio.reloj import ZONA_ECUADOR, ahora_ecuador


class PruebasReloj(unittest.TestCase):
    def test_ecuador_esta_cinco_horas_detras_de_utc(self):
        utc = datetime.now(timezone.utc).replace(tzinfo=None)
        diferencia = utc - ahora_ecuador()
        self.assertAlmostEqual(diferencia.total_seconds(), timedelta(hours=5).total_seconds(), delta=2)

    def test_la_zona_no_tiene_horario_de_verano(self):
        self.assertEqual(ZONA_ECUADOR.utcoffset(None), timedelta(hours=-5))


if __name__ == '__main__':
    unittest.main()
