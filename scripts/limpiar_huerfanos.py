#!/usr/bin/env python3
"""Elimina contenedores huérfanos de la app. Nunca borra APP_GESTION_DOCUMENTAL ni la BDD."""

from __future__ import annotations

import json
import subprocess
import sys


KEEP_NAMES = {"APP_GESTION_DOCUMENTAL", "gestion_documental_db"}


def docker_json(args: list[str]):
    result = subprocess.run(["docker", *args], capture_output=True, text=True)
    if result.returncode != 0:
        raise SystemExit(result.stderr or "Error ejecutando docker")
    lines = [ln for ln in result.stdout.splitlines() if ln.strip()]
    return [json.loads(ln) for ln in lines]


def main() -> int:
    print("Contenedores actuales:")
    subprocess.run(["docker", "ps", "-a", "--format", "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"])
    print()
    print("Se conservan siempre:", ", ".join(sorted(KEEP_NAMES)))
    print("La base de datos NO se toca.")
    if sys.stdin.isatty():
        input("Enter para continuar (Ctrl+C para cancelar)...")

    result = subprocess.run(
        ["docker", "ps", "-a", "--format", "{{json .}}"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise SystemExit(result.stderr)

    deleted = 0
    for line in result.stdout.splitlines():
        if not line.strip():
            continue
        row = json.loads(line)
        cid = row.get("ID") or row.get("Id")
        name = row.get("Names") or row.get("Name") or ""
        image = row.get("Image") or ""
        # docker ps json Names a veces viene sin prefijo /
        name = name.lstrip("/")

        if name in KEEP_NAMES:
            print(f"Conservando: {name}")
            continue

        looks_like_app = "app_web_gestion_documental" in image.lower()
        looks_like_orphan_name = name and name not in KEEP_NAMES and (
            "_" in name and name.islower() or "hardcore" in name.lower()
        )

        # Solo borrar si es imagen de esta app (o nombre claramente huérfano de la misma imagen)
        if not looks_like_app:
            # Confirmar por inspect image
            insp = subprocess.run(
                ["docker", "inspect", "-f", "{{.Config.Image}}", cid],
                capture_output=True,
                text=True,
            )
            image_insp = (insp.stdout or "").strip()
            if "app_web_gestion_documental" not in image_insp.lower():
                continue
            image = image_insp

        print(f"Eliminando huérfano: {name} ({cid}) imagen={image}")
        rm = subprocess.run(["docker", "rm", "-f", cid], capture_output=True, text=True)
        if rm.returncode == 0:
            deleted += 1
        else:
            print(rm.stderr)

    print()
    print(f"Huérfanos eliminados: {deleted}")
    print("Estado actual:")
    subprocess.run(["docker", "ps", "-a", "--format", "table {{.Names}}\t{{.Image}}\t{{.Status}}"])
    print()
    print("Si falta APP_GESTION_DOCUMENTAL: docker compose up -d")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
