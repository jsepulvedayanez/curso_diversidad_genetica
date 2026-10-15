# Solo para la ruta B de la guía (R instalado por separado).
# Si usaste conda (ruta A), NO necesitas este archivo.
cran <- c("IRkernel","ggplot2","vcfR","adegenet","hierfstat","pegas","vegan")
nuevos <- setdiff(cran, rownames(installed.packages()))
if (length(nuevos)) install.packages(nuevos)

if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!requireNamespace("LEA", quietly = TRUE)) BiocManager::install("LEA")

# Registrar R como kernel de Jupyter
IRkernel::installspec(user = TRUE)
