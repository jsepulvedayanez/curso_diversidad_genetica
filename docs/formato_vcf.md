# El formato VCF, columna por columna

Un archivo **VCF** (*Variant Call Format*) guarda las variantes genéticas (SNP, indels) de un conjunto de individuos. Tiene tres partes:

1. **Líneas de metadatos** (empiezan con `##`): describen el archivo, los contigs y el significado de los campos `INFO` y `FORMAT`.
2. **Línea de cabecera** (empieza con `#CHROM`): los nombres de las columnas.
3. **Filas de variantes**: una por variante, con el genotipo de cada individuo.

## Las columnas fijas (las 9 primeras)

| Columna | Nombre | Qué significa |
|---|---|---|
| 1 | `CHROM` | Contig o cromosoma donde está la variante. En lenga no son cromosomas completos: son **contigs** del enriquecimiento por sondas. |
| 2 | `POS` | Posición (1-based) de la variante dentro del contig. |
| 3 | `ID` | Identificador de la variante (p. ej. un código `rs`). Un `.` significa "sin identificador". |
| 4 | `REF` | Alelo de referencia (el que hay en el genoma de referencia). |
| 5 | `ALT` | Alelo(s) alternativo(s), separados por coma si hay más de uno. |
| 6 | `QUAL` | Calidad Phred de la llamada: `-10·log10(p(variante falsa))`. A mayor valor, más confianza de que la variante es real. |
| 7 | `FILTER` | `PASS` si pasó todos los filtros; si no, el nombre del filtro que falló (p. ej. `LowQual`). |
| 8 | `INFO` | Anotaciones de la variante, separadas por `;` en formato `CLAVE=VALOR` (p. ej. `DP=123;AF=0.42`). |
| 9 | `FORMAT` | Lista de subcampos (separados por `:`) que lleva cada muestra. |

Después de `FORMAT` viene **una columna por individuo**, con los valores de esos subcampos en el mismo orden.

## Los subcampos de `FORMAT` (lo que hay dentro de cada muestra)

| Subcampo | Nombre | Qué significa |
|---|---|---|
| `GT` | Genotipo | Los alelos que lleva el individuo, separados por `/` (sin fase) o `|` (con fase). `0` = REF, `1` = ALT. `0/1` = heterocigoto, `1/1` = homocigoto ALT, `./.` = **faltante**. |
| `AD` | Allelic depth | Número de lecturas que apoyan cada alelo (REF, ALT). |
| `DP` | Read depth | Número total de lecturas en esa posición (cobertura). |
| `GQ` | Genotype quality | Calidad Phred del genotipo: `-10·log10(p(genotipo incorrecto))`. |
| `PL` | Phred likelihoods | Probabilidades (escala Phred) de cada genotipo posible (0/0, 0/1, 1/1). El menor es el más probable. |
| `PS` | Phasing set | Identificador del bloque de fase (solo si el genotipo está faseado). |
| `RGQ` | Reference genotype quality | Confianza del genotipo de referencia (cuando no se llama variante). |
| `SB` | Strand bias | Valores por hebra para el test de sesgo de hebra. |

## Campos `INFO` frecuentes

| Campo | Qué significa |
|---|---|
| `AC` | Número de alelos ALT en la muestra (allele count). |
| `AF` | Frecuencia del alelo ALT (allele frequency). |
| `AN` | Número total de alelos llamados (allele number = 2 × nº de individuos). |
| `DP` | Cobertura total en la posición. |
| `QD` | Calidad normalizada por cobertura (quality by depth). |
| `FS` / `SOR` | Estadísticos de sesgo de hebra (strand bias). |
| `MQ` | Calidad media de mapeo (mapping quality). |

## Ejemplo comentado (una fila)

```
#CHROM  POS      ID  REF  ALT  QUAL   FILTER  INFO              FORMAT    muestra1        muestra2
contig1 10453    .   A    G    523.77 PASS    DP=210;AF=0.36    GT:AD:DP:GQ:PL   0/1:18,12:30:99:523,0,640   0/0:25,0:25:75:0,75,900
```

Leyendo la fila:

- La variante está en `contig1`, posición `10453`: alelo de referencia `A`, alternativo `G`.
- `QUAL=523.77` → llamada de alta confianza.
- `FILTER=PASS` → pasó los filtros.
- `INFO`: `DP=210` (210 lecturas en total), `AF=0.36` (el alelo G está en el 36 % de los alelos).
- `FORMAT=GT:AD:DP:GQ:PL` → cada muestra lleva esos 5 valores.
- `muestra1 = 0/1:18,12:30:99:523,0,640` → heterocigoto (`0/1`), 18 lecturas de A y 12 de G (`AD=18,12`), 30 lecturas (`DP=30`), genotipo de altísima calidad (`GQ=99`).
- `muestra2 = 0/0:25,0:25:75:0,75,900` → homocigoto de referencia (`0/0`), todas sus lecturas son de A.

**Regla para leer un VCF:** cada fila = una variante; cada columna de muestra = un individuo; el `GT` es lo que convertimos a **dosis** (`0`, `1`, `2` o `NA`) para el resto del curso.
