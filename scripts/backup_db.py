#!/usr/bin/env python3
"""
Respaldo completo (BDD + uploads) vía docker/pg_dump y zip.
No modifica la lógica de la aplicación.
"""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import zipfile
from datetime import datetime
from pathlib import Path


DEFAULT_CONTAINER = os.getenv("BACKUP_DB_CONTAINER", "gestion_documental_db")
DEFAULT_DB = os.getenv("BACKUP_DB_NAME", "gestion_documental")
DEFAULT_USER = os.getenv("BACKUP_DB_USER", "postgres")


def project_root() -> Path:
    return Path(__file__).resolve().parent.parent


def desktop_backup_dir() -> Path:
    return Path.home() / "Desktop" / "RESPALDOS_APP_BDD"


def resolve_backup_dir(use_desktop: bool) -> Path:
    env_dir = os.getenv("BACKUP_DIR", "").strip()
    if env_dir:
        return Path(env_dir).expanduser().resolve()
    if use_desktop:
        return desktop_backup_dir()
    return project_root() / "RESPALDOS_APP_BDD"


def require_docker() -> None:
    if shutil.which("docker") is None:
        raise SystemExit("ERROR: docker no está en el PATH.")


def container_running(name: str) -> bool:
    result = subprocess.run(
        ["docker", "inspect", "-f", "{{.State.Running}}", name],
        capture_output=True,
        text=True,
    )
    return result.returncode == 0 and result.stdout.strip().lower() == "true"


def run_pg_dump(container: str, db_user: str, db_name: str, out_file: Path) -> None:
    cmd = [
        "docker",
        "exec",
        container,
        "pg_dump",
        "-U",
        db_user,
        "-d",
        db_name,
        "--no-owner",
        "--no-acl",
    ]
    with out_file.open("wb") as fh:
        proc = subprocess.run(cmd, stdout=fh, stderr=subprocess.PIPE)
    if proc.returncode != 0:
        if out_file.exists():
            out_file.unlink(missing_ok=True)
        err = (proc.stderr or b"").decode("utf-8", errors="replace")
        raise SystemExit(f"ERROR: pg_dump falló:\n{err}")


def zip_uploads(uploads_dir: Path, out_zip: Path) -> bool:
    if not uploads_dir.exists():
        print(f"AVISO: no existe {uploads_dir}; se omite ZIP.")
        return False
    files = [p for p in uploads_dir.rglob("*") if p.is_file()]
    if not files:
        print("AVISO: uploads sin archivos; se omite ZIP.")
        return False
    with zipfile.ZipFile(out_zip, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for path in files:
            zf.write(path, arcname=str(path.relative_to(uploads_dir)))
    return True


def prune_old_backups(folder: Path, retain: int) -> None:
    if retain <= 0:
        return
    for pattern in ("gestion_documental_*.sql", "gestion_documental_*.dump", "uploads_*.zip"):
        files = sorted(folder.glob(pattern), key=lambda p: p.stat().st_mtime, reverse=True)
        for old in files[retain:]:
            old.unlink(missing_ok=True)
            print(f"Eliminado respaldo antiguo: {old.name}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Respaldo Postgres + uploads")
    parser.add_argument("--desktop", action="store_true", help="Guardar en Desktop/RESPALDOS_APP_BDD")
    parser.add_argument(
        "--retain",
        type=int,
        default=int(os.getenv("BACKUP_RETAIN", "14")),
        help="Cuántos respaldos recientes conservar (0 = no borrar)",
    )
    parser.add_argument("--container", default=DEFAULT_CONTAINER)
    parser.add_argument("--db", default=DEFAULT_DB)
    parser.add_argument("--user", default=DEFAULT_USER)
    args = parser.parse_args()

    require_docker()
    if not container_running(args.container):
        raise SystemExit(
            f"ERROR: el contenedor '{args.container}' no está en ejecución. "
            "Levanta el stack con: docker compose up -d"
        )

    backup_dir = resolve_backup_dir(args.desktop)
    backup_dir.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    out_sql = backup_dir / f"gestion_documental_{stamp}.sql"
    print(f"1/2 BDD -> {out_sql}")
    run_pg_dump(args.container, args.user, args.db, out_sql)
    print(f"OK BDD ({out_sql.stat().st_size / (1024 * 1024):.2f} MB)")

    out_zip = backup_dir / f"uploads_{stamp}.zip"
    print(f"2/2 uploads -> {out_zip}")
    if zip_uploads(project_root() / "uploads", out_zip):
        print(f"OK uploads ({out_zip.stat().st_size / (1024 * 1024):.2f} MB)")

    prune_old_backups(backup_dir, args.retain)
    print(f"Listo en: {backup_dir}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
