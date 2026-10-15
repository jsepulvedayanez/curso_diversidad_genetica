# ============================================================
# Funciones de apoyo del curso (genética de poblaciones de lenga)
# Secciones 1–2: importación/QC y diversidad genética.
#
# Formato de datos que usamos en TODO el curso:
#   G    : matriz individuos x SNP con dosis del alelo ALT (0/1/2/NA)
#   meta : data.frame con una fila por individuo (id, pop, lat, lon, alt)
# Si tu estudiante consigue datos reales, solo debe llevarlos a este formato.
# ============================================================
suppressPackageStartupMessages(library(ggplot2))
theme_set(theme_minimal(base_size = 13))

# ---- Importación -------------------------------------------------
read_vcf_dosage <- function(path) {
  vcf <- vcfR::read.vcfR(path, verbose = FALSE)
  gt  <- vcfR::extract.gt(vcf, element = "GT", as.numeric = FALSE)  # SNP x ind
  dos <- matrix(NA_integer_, nrow(gt), ncol(gt), dimnames = dimnames(gt))
  dos[gt %in% c("0/0", "0|0")] <- 0L
  dos[gt %in% c("0/1", "1/0", "0|1", "1|0")] <- 1L
  dos[gt %in% c("1/1", "1|1")] <- 2L
  list(G = t(dos),
       snp = data.frame(id = rownames(gt),
                        chrom = vcf@fix[, "CHROM"],
                        pos = as.integer(vcf@fix[, "POS"]),
                        stringsAsFactors = FALSE))
}

# ---- Control de calidad ------------------------------------------
snp_summary <- function(G) {
  p <- colMeans(G, na.rm = TRUE) / 2
  data.frame(snp = colnames(G),
             call_rate = colMeans(!is.na(G)),
             maf = pmin(p, 1 - p),
             het_obs = colMeans(G == 1, na.rm = TRUE),
             stringsAsFactors = FALSE)
}

qc_filter <- function(G, ind_cr = 0.80, snp_cr = 0.90, maf = 0.05) {
  keep_i <- rowMeans(!is.na(G)) >= ind_cr
  G <- G[keep_i, , drop = FALSE]
  cr <- colMeans(!is.na(G))
  p  <- colMeans(G, na.rm = TRUE) / 2
  m  <- pmin(p, 1 - p)
  keep_s <- cr >= snp_cr & !is.na(m) & m >= maf
  list(G = G[, keep_s, drop = FALSE], keep_ind = keep_i, keep_snp = keep_s)
}

impute_mean <- function(G) {
  mu  <- colMeans(G, na.rm = TRUE)
  idx <- which(is.na(G), arr.ind = TRUE)
  if (nrow(idx)) G[idx] <- mu[idx[, 2]]
  G
}

# Carga los datos limpios; si no existen, repite el QC de la sección 1
load_clean <- function() {
  if (file.exists("data/geno_clean.rds") && file.exists("data/meta_clean.rds"))
    return(list(G = readRDS("data/geno_clean.rds"),
                meta = readRDS("data/meta_clean.rds")))
  if (!file.exists("data/lenga_sim.vcf")) source("00_simular_datos.R")
  x <- read_vcf_dosage("data/lenga_sim.vcf")
  meta <- read.csv("data/lenga_sim_muestras.csv", stringsAsFactors = FALSE)
  meta <- meta[match(rownames(x$G), meta$id), ]
  q <- qc_filter(x$G)
  list(G = q$G, meta = meta[q$keep_ind, ])
}

# Región aproximada por latitud
assign_region <- function(lat)
  cut(lat, c(-Inf, -48.1, -41.3, Inf), labels = c("Sur", "Centro", "Norte"))

# ---- Diversidad ---------------------------------------------------
diversity_by_pop <- function(G, pop) {
  pop <- factor(pop)
  do.call(rbind, lapply(levels(pop), function(k) {
    Gk <- G[pop == k, , drop = FALSE]
    n  <- colSums(!is.na(Gk))                 # individuos genotipados por SNP
    p  <- colMeans(Gk, na.rm = TRUE) / 2
    ok <- n > 1
    he <- (2 * n / (2 * n - 1)) * 2 * p * (1 - p)   # He insesgada (Nei 1978)
    ho <- colMeans(Gk == 1, na.rm = TRUE)
    data.frame(pop = k, n_ind = nrow(Gk),
               Ho = mean(ho[ok]), He = mean(he[ok]),
               Fis = 1 - mean(ho[ok]) / mean(he[ok]),
               prop_polim = mean(p[ok] > 0 & p[ok] < 1),
               stringsAsFactors = FALSE)
  }))
}
