#!/usr/bin/env python3
"""
Respaldo completo en UN ZIP: gestion_documental.sql + carpeta uploads/.
No modifica la lógica de la aplicación.
"""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import tempfile
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


def build_zip(sql_file: Path, uploads_dir: Path, out_zip: Path) -> None:
    with zipfile.ZipFile(out_zip, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        zf.write(sql_file, arcname="gestion_documental.sql")
        if uploads_dir.exists():
            for path in uploads_dir.rglob("*"):
                if path.is_file():
                    zf.write(path, arcname=str(Path("uploads") / path.relative_to(uploads_dir)))


def prune_old_backups(folder: Path, retain: int) -> None:
    if retain <= 0:
        return
    files = sorted(
        folder.glob("respaldo_completo_*.zip"),
        key=lambda p: p.stat().st_mtime,
        reverse=True,
    )
    for old in files[retain:]:
        old.unlink(missing_ok=True)
        print(f"Eliminado respaldo antiguo: {old.name}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Respaldo completo (SQL + uploads) en un ZIP")
    parser.add_argument("--desktop", action="store_true", help="Guardar en Desktop/RESPALDOS_APP_BDD")
    parser.add_argument(
        "--retain",
        type=int,
        default=int(os.getenv("BACKUP_RETAIN", "14")),
        help="Cuántos ZIPs recientes conservar (0 = no borrar)",
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
    out_zip = backup_dir / f"respaldo_completo_{stamp}.zip"

    with tempfile.TemporaryDirectory(prefix="gd_backup_") as tmp:
        tmp_path = Path(tmp)
        sql_file = tmp_path / "gestion_documental.sql"
        print("1/2 Dump BDD...")
        run_pg_dump(args.container, args.user, args.db, sql_file)
        print(f"OK BDD ({sql_file.stat().st_size / 1024:.1f} KB)")

        print(f"2/2 ZIP -> {out_zip}")
        build_zip(sql_file, project_root() / "uploads", out_zip)

    print(f"OK ZIP ({out_zip.stat().st_size / (1024 * 1024):.2f} MB)")
    prune_old_backups(backup_dir, args.retain)
    print("Contiene: gestion_documental.sql + uploads/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
