#!/usr/bin/env bash
# Extrae del VCF real de Sekely et al. (2024) el subconjunto que usa la Sección 3.
#
#   ./scripts/extraer_vcf_real.sh <VCF_COMPLETO.vcf.gz> [carpeta_salida]
#
# Qué hace:
#   1. elige un SNP bialélico PASS al azar por contig (semilla fija → reproducible);
#   2. conserva las 502 muestras y los campos GT:AD:DP:GQ de cada genotipo;
#   3. deja el encabezado con solo los contigs usados y sin las líneas de comando
#      gigantes del pipeline original (que se resumen en una línea `##subsetting`);
#   4. escribe `<carpeta>/lenga_real_1782snp.vcf.gz`.
#
# Requiere: bcftools ≥1.16, python3, gzip.
set -euo pipefail

VCF=${1:?uso: extraer_vcf_real.sh <VCF_COMPLETO.vcf.gz> [carpeta_salida]}
SALIDA=${2:-datos_ejemplo}
POR_CONTIG=1
SEMILLA=2026

AQUI=$(cd "$(dirname "$0")" && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$SALIDA"

echo "[1/4] inventario de variantes"
bcftools query -f '%CHROM\t%POS\t%TYPE\t%ALT\t%FILTER\n' "$VCF" > "$TMP/variantes.tsv"

echo "[2/4] selección ($POR_CONTIG SNP por contig, semilla $SEMILLA)"
python3 "$AQUI/elegir_snps.py" "$TMP/variantes.tsv" "$TMP/targets.tsv" "$POR_CONTIG" "$SEMILLA"

echo "[3/4] subconjunto con bcftools"
bcftools view -T "$TMP/targets.tsv" -f PASS -m2 -M2 --threads 4 -Ou "$VCF" \
  | bcftools annotate -x FORMAT/PL,FORMAT/PGT,FORMAT/PID,FORMAT/PS,FORMAT/MIN_DP,FORMAT/RGQ,FORMAT/SB -Ou \
  | bcftools view -Oz -o "$TMP/crudo.vcf.gz" --threads 4

echo "[4/4] encabezado recortado"
bcftools query -f '%CHROM\n' "$TMP/crudo.vcf.gz" | sort -u > "$TMP/contigs.txt"
bcftools view -h "$TMP/crudo.vcf.gz" | awk -v usados="$TMP/contigs.txt" '
  # se descartan las líneas de comando que agrega este script y la de GenomicsDBImport
  /^##bcftools_view(Version|Command)/    { next }
  /^##bcftools_annotate(Version|Command)/ { next }
  /^##GATKCommandLine=<ID=GenomicsDBImport/ { next }
  /^##contig=/ {
    if (!cargado) { while ((getline l < usados) > 0) ok[l] = 1; cargado = 1 }
    id = $0; sub(/^##contig=<ID=/, "", id); sub(/[,>].*$/, "", id)
    if (id in ok) print
    next
  }
  { print }
' > "$TMP/header.txt"

cat >> "$TMP/header.txt" <<'FIN'
##subsetting=<Source="variants-gatk_haplotypecaller_SNP.vcf.gz",Zenodo="10.5281/zenodo.10018374",Licencia="CC-BY-4.0",Referencia="Sekely et al. 2024, Plants People Planet 6:1352-1366",Regla="un SNP bialelico PASS al azar por contig, semilla 2026",Variantes="1782 de 116136",Muestras="502",FORMAT="GT:AD:DP:GQ">
FIN
# el encabezado debe terminar en la fila #CHROM: se reordena para que ##subsetting quede arriba
{ grep -v '^#CHROM' "$TMP/header.txt"; grep '^#CHROM' "$TMP/header.txt"; } > "$TMP/header_final.txt"

bcftools reheader -h "$TMP/header_final.txt" -o "$SALIDA/lenga_real_1782snp.vcf.gz" "$TMP/crudo.vcf.gz"

echo
echo "listo: $SALIDA/lenga_real_1782snp.vcf.gz"
bcftools view -h "$SALIDA/lenga_real_1782snp.vcf.gz" | grep -c '^##contig' | sed 's/^/  contigs: /'
bcftools query -l "$SALIDA/lenga_real_1782snp.vcf.gz" | wc -l | sed 's/^/  muestras: /'
bcftools view -H "$SALIDA/lenga_real_1782snp.vcf.gz" | wc -l | sed 's/^/  SNP: /'
