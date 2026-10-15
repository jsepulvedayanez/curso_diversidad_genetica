# ============================================================
# Simulación de un conjunto SNP "tipo lenga" para el curso
# NO son datos reales. Imita rasgos generales descritos para N. pumilio:
#  - rango latitudinal de ~2000 km (36-55 S)
#  - estructura genética alineada con la latitud
#  - gradiente de temperatura confundido con la latitud
#  - un set de SNPs asociados al clima (candidatos a adaptación)
# Salidas en data/: lenga_sim.vcf, lenga_sim_muestras.csv,
#                   lenga_sim_ambiente.csv, sim_verdad.rds (solo docente)
# ============================================================
set.seed(2026)
dir.create("data", showWarnings = FALSE)

n_pop <- 20; n_ind <- 12; S <- 1500
pop_ids <- sprintf("L%02d", 1:n_pop)

# --- Geografía y ambiente por población ---
lat   <- seq(-36, -54.5, length.out = n_pop) + rnorm(n_pop, 0, 0.25)
lon   <- -71.3 - 0.12 * (abs(lat) - 36) + rnorm(n_pop, 0, 0.15)
alt   <- round(seq(1500, 500, length.out = n_pop) + rnorm(n_pop, 0, 80))
tmean <- round(9 + 0.35 * (lat + 45) - 0.003 * (alt - 1000) + rnorm(n_pop, 0, 0.2), 2)
prec  <- round(pmin(pmax(exp(rnorm(n_pop, log(1200), 0.45)), 400), 2800))
region_sim <- cut(1:n_pop, c(0, 6, 13, 20), labels = c("Norte", "Centro", "Sur"))

# --- Frecuencias alélicas (Balding-Nichols jerárquico) ---
bn <- function(p, F) rbeta(length(p), p * (1 - F) / F, (1 - p) * (1 - F) / F)
p_anc  <- pmin(pmax(rbeta(S, 0.7, 0.7), 0.03), 0.97)
p_reg  <- lapply(levels(region_sim), function(r) bn(p_anc, 0.05))
names(p_reg) <- levels(region_sim)

lat_s  <- as.numeric(scale(lat)); temp_s <- as.numeric(scale(tmean))
beta_lat <- rnorm(S, 0, 0.15)                    # deriva suave a lo largo de la latitud
beta_tmp <- numeric(S)
outl <- sort(sample(S, 40))                      # SNPs asociados a temperatura
beta_tmp[outl] <- rnorm(40, 0, 0.9)
F_pop <- seq(0.02, 0.07, length.out = n_pop)     # más deriva hacia el sur

# --- Genotipos (HWE con endogamia f = 0.03) ---
draw_geno <- function(p, f, n) {
  q <- 1 - p
  p0 <- q^2 + f * p * q; p1 <- 2 * p * q * (1 - f)
  u <- matrix(runif(n * length(p)), n)
  (u >= rep(p0, each = n)) + (u >= rep(p0 + p1, each = n))
}
G <- matrix(NA_integer_, n_pop * n_ind, S)
for (i in 1:n_pop) {
  pr <- pmin(pmax(p_reg[[as.character(region_sim[i])]], 0.01), 0.99)
  pr <- plogis(qlogis(pr) + beta_lat * lat_s[i] + beta_tmp * temp_s[i])
  pp <- pmin(pmax(bn(pr, F_pop[i]), 0), 1)
  G[((i - 1) * n_ind + 1):(i * n_ind), ] <- draw_geno(pp, 0.03, n_ind)
}
ind_pop <- rep(pop_ids, each = n_ind)
ind_id  <- paste0(ind_pop, "_", sprintf("%02d", rep(1:n_ind, n_pop)))

# --- "Accidente de laboratorio": una muestra mal etiquetada (para clase 4) ---
swap_idx <- 5                                    # figura como L01
G[swap_idx, ] <- G[17 * n_ind + 3, ]             # pero su genotipo es de L18

# --- Datos faltantes realistas ---
miss <- matrix(runif(length(G)) < 0.03, nrow(G))
bad_ind <- sample(nrow(G), 6)
for (b in bad_ind) miss[b, ] <- miss[b, ] | runif(S) < 0.25
bad_snp <- sample(S, 60)
miss[, bad_snp] <- miss[, bad_snp] | matrix(runif(nrow(G) * 60) < 0.4, nrow(G))
G[miss] <- NA

snp_ids <- sprintf("snp%04d", 1:S)
dimnames(G) <- list(ind_id, snp_ids)

# --- Escribir VCF ---
chrom <- sort(rep(1:13, length.out = S))
pos <- unlist(lapply(table(chrom), function(n) sort(sample(1e5:5e7, n))))
ref <- sample(c("A", "C", "G", "T"), S, TRUE)
alt_a <- vapply(ref, function(r) sample(setdiff(c("A", "C", "G", "T"), r), 1), "")
tG <- t(G)
gt <- matrix("./.", S, ncol(tG))
gt[!is.na(tG) & tG == 0] <- "0/0"
gt[!is.na(tG) & tG == 1] <- "0/1"
gt[!is.na(tG) & tG == 2] <- "1/1"
header <- c("##fileformat=VCFv4.2", "##source=simulacion_lenga_curso",
            '##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">',
            paste0("##contig=<ID=chr", 1:13, ">"))
colhdr <- paste(c("#CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO",
                  "FORMAT", ind_id), collapse = "\t")
body <- paste(paste0("chr", chrom), pos, snp_ids, ref, alt_a, ".", "PASS", ".", "GT",
              apply(gt, 1, paste, collapse = "\t"), sep = "\t")
writeLines(c(header, colhdr, body), "data/lenga_sim.vcf")

# --- Metadatos ---
muestras <- data.frame(id = ind_id, pop = ind_pop,
                       lat = round(rep(lat, each = n_ind), 3),
                       lon = round(rep(lon, each = n_ind), 3),
                       alt = rep(alt, each = n_ind))
write.csv(muestras, "data/lenga_sim_muestras.csv", row.names = FALSE)
write.csv(data.frame(pop = pop_ids, lat = round(lat, 3), lon = round(lon, 3),
                     alt = alt, tmean = tmean, prec = prec),
          "data/lenga_sim_ambiente.csv", row.names = FALSE)

# --- Verdad de la simulación (solo docente) ---
saveRDS(list(snp_outliers = snp_ids[outl], mislabeled = ind_id[swap_idx],
             bad_individuals = ind_id[bad_ind], bad_snps = snp_ids[bad_snp],
             region = setNames(as.character(region_sim), pop_ids)),
        "data/sim_verdad.rds")
message("Datos simulados escritos en data/")
