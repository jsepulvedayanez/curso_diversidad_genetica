#!/usr/bin/env python3
"""Elige las muestras del extracto de la Sección 3 desde la tabla de metadatos.

Regla: 10 árboles al azar por sitio (semilla fija) + las 6 réplicas que trae el
archivo publicado + la muestra que quedó casi sin genotipos. Las réplicas y su
árbol original se conservan siempre en pareja, porque la actividad pide
encontrarlas midiendo identidad entre pares.

Uso: elegir_muestras.py lenga_real_muestras.csv salida.txt [semilla]
"""
import sys, csv, random, collections

entrada, salida = sys.argv[1], sys.argv[2]
semilla = int(sys.argv[3]) if len(sys.argv) > 3 else 2026
POR_SITIO = 10

# Réplicas detectadas por matriz de identidad genotípica (>0,95) sobre las 502 muestras.
REPLICAS = {
    "66-R253-A-B09":  "284-00253-C-D12",
    "107-R234-B-C02": "81-00234-A-A11",
    "108-R235-B-D02": "82-00235-A-B11",
    "407-R141-E-G03": "332-00141-D-D06",
    "346-R-285-D-B08": "476-00285-E-D12",
    "183-R406-B-G11": "348-00406-D-D08",
}
# Muestra del archivo publicado con 10 genotipos llamados de 1 782 (falló la secuenciación).
CASI_VACIA = "233-00298-C-A06"

with open(entrada, newline="") as fh:
    filas = list(csv.DictReader(fh))

con_ficha = [f for f in filas if f["arbol_id"] not in ("", "NA")]
por_sitio = collections.defaultdict(list)
for f in con_ficha:
    por_sitio[f["sitio_n"]].append(f)

azar = random.Random(semilla)
elegidas = []
for sitio in sorted(por_sitio, key=int):
    candidatos = sorted(por_sitio[sitio], key=lambda f: f["id"])
    forzadas = [f for f in candidatos if f["id"] in REPLICAS.values()]
    resto = [f for f in candidatos if f["id"] not in REPLICAS.values()]
    cupo = max(0, POR_SITIO - len(forzadas))
    elegidas += forzadas + azar.sample(resto, min(cupo, len(resto)))

ids = [f["id"] for f in elegidas] + list(REPLICAS) + [CASI_VACIA]
orden = {f["id"]: i for i, f in enumerate(filas)}     # mismo orden que el VCF completo
ids.sort(key=lambda x: orden[x])

with open(salida, "w") as fh:
    fh.write("\n".join(ids) + "\n")

print(f"árboles con ficha: {len(elegidas)} de {len(con_ficha)} (hasta {POR_SITIO} por sitio, semilla {semilla})")
print(f"réplicas incluidas: {len(REPLICAS)} | muestra casi vacía: 1")
print(f"muestras totales: {len(ids)}")
