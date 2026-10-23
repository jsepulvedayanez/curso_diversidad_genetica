#!/usr/bin/env python3
"""Elige SNPs al azar (uno por contig) desde el VCF real de Sekely et al. 2024.

Uso:  python3 elegir_snps.py variantes.tsv salida_targets.tsv [n_por_contig] [semilla]
variantes.tsv: CHROM POS TYPE ALT FILTER  (de `bcftools query -f '%CHROM\t%POS\t%TYPE\t%ALT\t%FILTER\n'`)
"""
import sys, random, collections

entrada = sys.argv[1]
salida = sys.argv[2]
n_por_contig = int(sys.argv[3]) if len(sys.argv) > 3 else 1
semilla = int(sys.argv[4]) if len(sys.argv) > 4 else 2026

por_contig = collections.defaultdict(list)
with open(entrada) as fh:
    for linea in fh:
        chrom, pos, tipo, alt, filtro = linea.rstrip("\n").split("\t")
        if tipo == "SNP" and filtro == "PASS" and "," not in alt:
            por_contig[chrom].append(int(pos))

azar = random.Random(semilla)
elegidos = []
for chrom in sorted(por_contig):
    posiciones = sorted(por_contig[chrom])
    elegidos.extend((chrom, p) for p in sorted(azar.sample(posiciones, min(n_por_contig, len(posiciones)))))

with open(salida, "w") as fh:
    for chrom, pos in elegidos:
        fh.write(f"{chrom}\t{pos}\n")

print(f"contigs con SNP bialélico PASS: {len(por_contig)}")
print(f"SNP elegidos: {len(elegidos)} (hasta {n_por_contig} por contig, semilla {semilla})")
