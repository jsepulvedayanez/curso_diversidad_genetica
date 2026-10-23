# Datos de ejemplo

Dos conjuntos, ambos **reales** y del mismo estudio (Sekely et al. 2024, *Plants, People, Planet* 6:1352–1366; datos en Zenodo, DOI [10.5281/zenodo.10018374](https://doi.org/10.5281/zenodo.10018374), licencia CC-BY-4.0).

## 1. `lenga_ejemplo.vcf` — recorte mínimo

3 sitios × 6 árboles × 301 SNP, **solo `GT`**. Es el archivo para mirar la anatomía de un VCF sin distracciones (Sección 0) y para la tarea de GATK.

- `lenga_ejemplo_meta.csv`: una fila por árbol (`id`, `pop`, `lat`, `lon`, `alt`).
- `lenga_sitios.csv`: los 3 sitios.

## 2. `lenga_real_1782snp.vcf.gz` — el VCF real para trabajar (Sección 3)

**502 muestras × 1 782 SNP × 1 782 contigs**, con `GT:AD:DP:GQ` en cada genotipo y todo el `INFO` original (`AC`, `AF`, `AN`, `QD`, `MQ`, `FS`, `SOR`…).

Es un subconjunto del VCF publicado (116 136 variantes): **un SNP bialélico PASS al azar por contig**, semilla fija. Los contigs son nodos de un ensamblaje *de novo* (`NODE_*`, `chain_*`), no cromosomas.

- `lenga_real_muestras.csv`: una fila por muestra del VCF, **en el mismo orden** que el archivo. Columnas: `id` (nombre IGA, igual que en el VCF), `arbol_tag`, `arbol_id`, `sitio_n`, `sitio`, `clase_elev`, `lat`, `lon`, `elevacion_m`. **9 muestras no tienen ficha** en el material publicado (quedan en `NA`).
- `lenga_real_sitios.csv`: los 20 sitios (21–25 árboles cada uno), con altitud y clase de elevación (`high`/`middle`/`low`/`unpaired`).

### Cómo se generó (reproducible)

```bash
./scripts/extraer_vcf_real.sh /ruta/variants-gatk_haplotypecaller_SNP.vcf.gz datos_ejemplo
Rscript scripts/hacer_metadatos_reales.R Npumilio_IDs_vcforder_all_info.xlsx datos_ejemplo/lenga_real_1782snp.vcf.gz
```

El script deja el encabezado con solo los contigs usados, quita las dos líneas `##GATKCommandLine` del pipeline original (82 KB de rutas) y agrega una línea `##subsetting` que documenta la regla de selección.

> El archivo completo (495 MB) **no** se versiona: se descarga de Zenodo si hace falta.
