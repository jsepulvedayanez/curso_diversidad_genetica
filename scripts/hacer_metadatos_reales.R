#!/usr/bin/env Rscript
# Arma las tablas de metadatos del extracto real de la Sección 3.
#
#   Rscript scripts/hacer_metadatos_reales.R <Npumilio_IDs_vcforder_all_info.xlsx> <lenga_real_1782snp.vcf.gz> [carpeta_salida]
#
# El xlsx es el material suplementario publicado en Zenodo (10.5281/zenodo.10018374).
# Genera, con el mismo orden de muestras que el VCF:
#   lenga_real_muestras.csv  (una fila por muestra; 9 muestras no tienen ficha en el xlsx)
#   lenga_real_sitios.csv    (una fila por sitio de muestreo)
suppressPackageStartupMessages(library(readxl))

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) stop("uso: hacer_metadatos_reales.R <xlsx> <vcf.gz> [carpeta_salida]")
xlsx <- args[1]
vcf  <- args[2]
dir  <- if (length(args) >= 3) args[3] else "datos_ejemplo"

ids  <- as.data.frame(read_excel(xlsx, sheet = "IDs_vcforder"))
loc  <- as.data.frame(read_excel(xlsx, sheet = "Locality data"))
muestras <- system2("bcftools", c("query", "-l", shQuote(vcf)), stdout = TRUE)

m <- ids[match(muestras, ids$ids), ]
k <- match(m$loc, loc$loc)

muestras_tab <- data.frame(
  id = muestras,
  arbol_tag = m$tree.id,
  arbol_id = m$full.id,
  sitio_n = m$loc,
  sitio = loc$Site.name[k],
  clase_elev = loc$El.class[k],
  lat = round(m$latitude, 5),
  lon = round(m$longitude, 5),
  elevacion_m = m$elevation,
  stringsAsFactors = FALSE
)

sitios_tab <- data.frame(
  sitio_n = loc$loc,
  sitio = loc$Site.name,
  clase_elev = loc$El.class,
  lat = round(loc$latitude, 5),
  lon = round(loc$longitude, 5),
  elevacion_m = loc$elevation,
  n_arboles = as.integer(table(factor(m$loc, levels = loc$loc))),
  stringsAsFactors = FALSE
)

write.csv(muestras_tab, file.path(dir, "lenga_real_muestras.csv"), row.names = FALSE, na = "NA")
write.csv(sitios_tab,   file.path(dir, "lenga_real_sitios.csv"),   row.names = FALSE)

cat("muestras:", nrow(muestras_tab), "| sin ficha en el xlsx:", sum(is.na(muestras_tab$arbol_id)), "\n")
cat("sitios:", nrow(sitios_tab), "| arboles por sitio:", paste(range(sitios_tab$n_arboles), collapse = "-"), "\n")
