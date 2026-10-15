# ─────────────────────────────────────────────────────────────────────────────
# Verificación del entorno  (debe terminar con «TODO LISTO»)
#
# Uso:
#     Rscript 00_verificar_instalacion.R        (o  source("00_verificar_instalacion.R"))
#
# Revisa los paquetes del curso y, si además estás en la carpeta completa del
# curso, prueba el flujo de la Sección 1 (simular → importar → filtrar).
# Funciona igual si solo tienes la carpeta de instalación.
# ─────────────────────────────────────────────────────────────────────────────

pk  <- c("ggplot2", "vcfR", "adegenet", "hierfstat", "pegas", "vegan", "LEA", "IRkernel")
ok  <- sapply(pk, requireNamespace, quietly = TRUE)
ver <- sapply(pk, function(p) tryCatch(as.character(utils::packageVersion(p)), error = function(e) "—"))

print(data.frame(paquete = pk, instalado = ok, version = ver, row.names = NULL))
cat("\nVersión de R:", as.character(getRversion()), "\n")
cat("Carpeta de trabajo:", getwd(), "\n")
cat("¿Existe R/helpers.R (carpeta del curso)?:", file.exists("R/helpers.R"), "\n")

falta <- pk[!ok]
if (length(falta)) {
  cat("\n══════════════════════════════════════════════\n")
  cat("FALTA INSTALAR:", paste(falta, collapse = ", "), "\n")
  cat("Ejecuta:  source(\"00_instalar_paquetes.R\")\n")
  cat("(LEA viene de Bioconductor; el script lo instala solo.)\n")
  cat("Revisa la sección «Problemas frecuentes» de la guía.\n")
  cat("══════════════════════════════════════════════\n")
} else if (!file.exists("R/helpers.R")) {
  cat("\n══════════════════════════════════════════════\n")
  cat("TODO LISTO ✔  El entorno está listo: los paquetes están instalados\n")
  cat("y cargan sin errores.\n")
  cat("\nNo encuentro R/helpers.R porque esta carpeta es solo la instalación,\n")
  cat("y eso es lo esperado. Cuando tengas la carpeta completa del curso,\n")
  cat("abre Jupyter DENTRO de ella y ejecuta otra vez este script para\n")
  cat("probar también el flujo de la Sección 1.\n")
  cat("══════════════════════════════════════════════\n")
} else {
  # ---- Prueba del flujo de la Sección 1 --------------------------
  cat("\n--- Prueba del flujo completo (Sección 1) ---\n")
  source("R/helpers.R")
  if (!file.exists("data/lenga_sim.vcf")) source("00_simular_datos.R")

  G <- read_vcf_dosage("data/lenga_sim.vcf")$G
  cat("Matriz G:", nrow(G), "individuos x", ncol(G), "SNP\n")

  q <- qc_filter(G, ind_cr = 0.80, snp_cr = 0.90, maf = 0.05)
  print(data.frame(etapa = c("Original", "Filtrado"),
                   individuos = c(nrow(G), nrow(q$G)),
                   snps = c(ncol(G), ncol(q$G))))

  if (nrow(G) == 240 && ncol(G) == 1500 && nrow(q$G) == 234 && ncol(q$G) == 1174) {
    cat("\nTODO LISTO ✔  (los números coinciden con los de la clase)\n")
  } else {
    cat("\nLos paquetes funcionan, pero los números no son los esperados",
        "(240×1500 → 234×1174). Revisa que no hayas modificado\n",
        "R/helpers.R ni los umbrales del filtro.\n")
  }
}
