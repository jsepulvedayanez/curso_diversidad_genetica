# ─────────────────────────────────────────────────────────────────────────────
# Instalación de los paquetes del curso  (ruta B: R instalado por separado)
#
# Uso, desde la carpeta del curso:
#     Rscript 00_instalar_paquetes.R        (o  source("00_instalar_paquetes.R")  en R)
#
# Si instalaste todo con conda/Miniforge (ruta A de la guía), NO necesitas este
# archivo: el entorno ya viene con los paquetes.
# ─────────────────────────────────────────────────────────────────────────────

cat("Versión de R:", as.character(getRversion()), "\n")
if (getRversion() < "4.2") warning("El curso espera R >= 4.2; con versiones anteriores puede fallar algún paquete.")

# --- Paquetes de CRAN ---------------------------------------------
cran <- c("ggplot2", "vcfR", "adegenet", "hierfstat", "pegas", "vegan", "IRkernel")
nuevos <- setdiff(cran, rownames(installed.packages()))
if (length(nuevos)) {
  cat("Instalando desde CRAN:", paste(nuevos, collapse = ", "), "\n")
  cat("(puede tardar entre 5 y 20 minutos)\n")
  install.packages(nuevos, repos = "https://cloud.r-project.org")
} else {
  cat("Los paquetes de CRAN ya estaban instalados.\n")
}

# --- LEA (vive en Bioconductor, no en CRAN) -----------------------
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cloud.r-project.org")
}
if (!requireNamespace("LEA", quietly = TRUE)) {
  cat("Instalando LEA desde Bioconductor...\n")
  BiocManager::install("LEA", ask = FALSE, update = FALSE)
}

# --- Registrar R como kernel de Jupyter ---------------------------
if (requireNamespace("IRkernel", quietly = TRUE)) {
  res <- try(IRkernel::installspec(user = TRUE), silent = TRUE)
  if (inherits(res, "try-error")) {
    cat("No se pudo registrar el kernel.\n",
        "Causa habitual: 'jupyter' no está en el PATH de la terminal.\n",
        "Alternativa: abre JupyterLab y en R ejecuta IRkernel::installspec(user = TRUE).\n")
  } else {
    cat("Kernel de R registrado para Jupyter.\n")
  }
}

cat("\nTerminado. Ahora verifica con:\n    Rscript 00_verificar_instalacion.R\n")
