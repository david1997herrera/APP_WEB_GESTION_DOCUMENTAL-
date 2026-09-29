"""Los enlaces de correo usan la dirección pública de la aplicación."""

import os
import unittest

from app.infraestructura.url_publica import DIRECCION_PUBLICA, url_publica


class TestUrlPublica(unittest.TestCase):
    def test_sin_variable_usa_la_direccion_publica(self):
        anterior = os.environ.pop("APP_BASE_URL", None)
        try:
            self.assertEqual(url_publica(), DIRECCION_PUBLICA)
            self.assertEqual(
                url_publica("/tasks/3"),
                "http://131.196.8.22:3110/tasks/3",
            )
        finally:
            if anterior is not None:
                os.environ["APP_BASE_URL"] = anterior

    def test_respeta_la_variable_cuando_esta_definida(self):
        anterior = os.environ.get("APP_BASE_URL")
        os.environ["APP_BASE_URL"] = "http://131.196.8.22:3110/"
        try:
            self.assertEqual(
                url_publica("/auth/restablecer/abc"),
                "http://131.196.8.22:3110/auth/restablecer/abc",
            )
        finally:
            if anterior is None:
                os.environ.pop("APP_BASE_URL", None)
            else:
                os.environ["APP_BASE_URL"] = anterior


if __name__ == "__main__":
    unittest.main()
