# Datos de ejemplo

Dos conjuntos, ambos **reales** y del mismo estudio (Sekely et al. 2024, *Plants, People, Planet* 6:1352–1366; datos en Zenodo, DOI [10.5281/zenodo.10018374](https://doi.org/10.5281/zenodo.10018374), licencia CC-BY-4.0).

## 1. `lenga_ejemplo.vcf` — recorte mínimo

3 sitios × 6 árboles × 301 SNP, **solo `GT`**. Es el archivo para mirar la anatomía de un VCF sin distracciones (Sección 0) y para la tarea de GATK.

- `lenga_ejemplo_meta.csv`: una fila por árbol (`id`, `pop`, `lat`, `lon`, `alt`).
- `lenga_sitios.csv`: los 3 sitios.

## 2. `lenga_real_1782snp.vcf.gz` — el VCF real para trabajar (Sección 3)

**207 muestras × 1 782 SNP × 1 782 contigs**, con `GT:AD:DP:GQ` en cada genotipo y el `INFO` del archivo original, con `AC`, `AF` y `AN` **recalculados** sobre este subconjunto.

- Las 207 muestras son **200 árboles** (10 al azar por sitio, semilla fija), **6 réplicas** y **1 muestra** que quedó casi sin datos (10 genotipos llamados). Las dos últimas cosas son a propósito: son parte de la actividad.
- Un SNP bialélico PASS al azar por contig. Los contigs son nodos de un ensamblaje *de novo* (`NODE_*`, `chain_*`), no cromosomas.
- `lenga_real_muestras.csv`: una fila por muestra del VCF, **en el mismo orden** que el archivo. Columnas: `id` (nombre IGA, igual que en el VCF), `arbol_tag`, `arbol_id`, `sitio_n`, `sitio`, `clase_elev`, `lat`, `lon`, `elevacion_m`. **7 muestras no tienen ficha** en el material publicado (quedan en `NA`).
- `lenga_real_sitios.csv`: los 20 sitios, con 10 árboles cada uno, altitud y clase de elevación (`high`/`middle`/`low`/`unpaired`).

### Cómo se generó (reproducible)

```bash
# 1) extraer con todas las muestras, para poder armar la tabla de metadatos
./scripts/extraer_vcf_real.sh variants-gatk_haplotypecaller_SNP.vcf.gz datos_ejemplo
Rscript scripts/hacer_metadatos_reales.R Npumilio_IDs_vcforder_all_info.xlsx datos_ejemplo/lenga_real_1782snp.vcf.gz
# 2) elegir las 207 muestras: 10 por sitio + 6 réplicas + la muestra casi vacía
python3 scripts/elegir_muestras.py datos_ejemplo/lenga_real_muestras.csv muestras.txt
# 3) volver a extraer, ahora con la lista de muestras
./scripts/extraer_vcf_real.sh variants-gatk_haplotypecaller_SNP.vcf.gz datos_ejemplo muestras.txt
Rscript scripts/hacer_metadatos_reales.R Npumilio_IDs_vcforder_all_info.xlsx datos_ejemplo/lenga_real_1782snp.vcf.gz
```

El script deja el encabezado con solo los contigs usados, quita las dos líneas `##GATKCommandLine` del pipeline original (82 KB de rutas) y agrega una línea `##subsetting` que documenta la regla de selección.

> El archivo completo (495 MB, 502 muestras, 116 136 variantes) **no** se versiona: se descarga de Zenodo si hace falta.
