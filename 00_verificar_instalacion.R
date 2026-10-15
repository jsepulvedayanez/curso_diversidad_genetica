# ─────────────────────────────────────────────────────────────────────────────
# Verificación de la instalación  (debe terminar con «TODO LISTO»)
#
# Uso, desde la carpeta del curso:
#     Rscript 00_verificar_instalacion.R        (o  source("00_verificar_instalacion.R"))
#
# Además de revisar los paquetes, prueba el flujo completo de la Sección 1:
# simula los datos, los importa y aplica el filtro de control de calidad.
# ─────────────────────────────────────────────────────────────────────────────

pk  <- c("ggplot2", "vcfR", "adegenet", "hierfstat", "pegas", "vegan", "LEA", "IRkernel")
ok  <- sapply(pk, requireNamespace, quietly = TRUE)
ver <- sapply(pk, function(p) tryCatch(as.character(utils::packageVersion(p)), error = function(e) "—"))

print(data.frame(paquete = pk, instalado = ok, version = ver, row.names = NULL))
cat("\nVersión de R:", as.character(getRversion()), "\n")
cat("Carpeta de trabajo:", getwd(), "\n")
cat("¿Existe R/helpers.R?:", file.exists("R/helpers.R"), "\n")

falta <- pk[!ok]
if (length(falta)) {
  cat("\nFALTAN PAQUETES:", paste(falta, collapse = ", "), "\n")
  cat("Ejecuta:  source(\"00_instalar_paquetes.R\")   (LEA se instala con BiocManager)\n")
  cat("Revisa la sección «Problemas frecuentes» de la guía.\n")
  stop("Instalación incompleta", call. = FALSE)
}

if (!file.exists("R/helpers.R")) {
  cat("\nNo encuentro R/helpers.R: estás abierto en otra carpeta.\n",
      "Cierra Jupyter y vuelve a abrirlo DENTRO de la carpeta del curso.\n")
  stop("Carpeta de trabajo incorrecta", call. = FALSE)
}

# ---- Prueba del flujo de la Sección 1 ----------------------------
cat("\n--- Prueba del flujo completo (Sección 1) ---\n")
source("R/helpers.R")
if (!file.exists("data/lenga_sim.vcf")) source("00_simular_datos.R")

x <- read_vcf_dosage("data/lenga_sim.vcf")
G <- x$G
cat("Matriz G:", nrow(G), "individuos x", ncol(G), "SNP\n")

q <- qc_filter(G, ind_cr = 0.80, snp_cr = 0.90, maf = 0.05)
print(data.frame(etapa = c("Original", "Filtrado"),
                 individuos = c(nrow(G), nrow(q$G)),
                 snps = c(ncol(G), ncol(q$G))))

esperado <- nrow(G) == 240 && ncol(G) == 1500
if (esperado && nrow(q$G) == 234 && ncol(q$G) == 1174) {
  cat("\nTODO LISTO ✔  (los números coinciden con los de la clase)\n")
} else if (esperado) {
  cat("\nLos paquetes funcionan, pero el filtro dio otros números:",
      "revisa que no hayas modificado R/helpers.R ni los umbrales.\n")
} else {
  cat("\nLa instalación funciona, pero los datos no tienen el tamaño esperado",
      "(240 x 1500). Si borraste la carpeta data/, vuelve a ejecutar 00_simular_datos.R.\n")
}
