# Diversidad genética en lenga · Secciones 1 y 2

Material docente en **R** para un curso de genética de poblaciones aplicado a *Nothofagus pumilio* (lenga), la especie arbórea dominante de los bosques subantárticos de Patagonia.

Este repositorio contiene las **dos primeras secciones** del curso: del archivo VCF a las estimaciones de diversidad genética. Está pensado para trabajarse en **JupyterLab** con kernel de **R**, explicando en clase y con ejercicios guiados.

> **Nota sobre los datos:** se usan datos **simulados** (`00_simular_datos.R`) que imitan rasgos generales de la lenga (rango latitudinal ~2.000 km, estructura alineada con la latitud, gradiente de temperatura). **No son datos biológicos reales**: sirven para practicar el flujo de análisis con una «verdad» conocida.

---

## Contenido

Cada **sección** es una unidad autónoma de contenido:

| Sección | Notebook | Contenido | Tarea |
|---|---|---|---|
| 1 | `seccion1_importar_y_QC.ipynb` | VCF → matriz de dosis, QC, MAF, LD | Justificar umbrales de QC (5 líneas de Métodos) |
| 2 | `seccion2_diversidad_genetica.ipynb` | Ho, He, Fis, bootstrap, gradiente latitudinal | Gráfico «publicable» de He con IC + conclusión sin «significativo» |

Cada sección termina con una **Tarea** que se revisa al comienzo de la clase siguiente, y cada notebook incluye:

- objetivos de aprendizaje,
- teoría con ejemplos numéricos e intuición,
- preguntas de anticipación («¿qué esperas?») para discutir antes de ejecutar,
- ejercicios guiados (E1, E2…) con su «idea clave»,
- errores y dudas frecuentes,
- resumen de las ideas principales.

## Requisitos

- **R** ≥ 4.2
- Paquetes de R: `ggplot2`, `vcfR`, `adegenet`, `hierfstat`, `pegas`, `vegan`, `LEA` y `IRkernel`
- **JupyterLab** con kernel de R

### Instalación

La forma más simple es con Miniforge + conda (entorno aislado, sin tocar tu R):

```bash
conda create -n lenga -c conda-forge -c bioconda \
  r-base r-irkernel jupyterlab r-ggplot2 r-vcfr \
  r-adegenet r-hierfstat r-pegas r-vegan bioconductor-lea
conda activate lenga
```

O, si ya tienes R instalado por separado, dentro de R:

```r
source("00_instalar_paquetes.R")
```

## Cómo usar

1. Clona el repositorio y entra a la carpeta.
2. Activa el entorno (si usaste conda) y lanza Jupyter **desde la carpeta del curso** (para que encuentre `R/helpers.R` y `data/`):

   ```bash
   jupyter lab
   ```

3. Abre `seccion1_importar_y_QC.ipynb`, verifica que el kernel sea **R** y ejecuta la primera celda. Los datos simulados se crean solos la primera vez.

También puedes verificar la instalación desde la terminal:

```bash
Rscript 00_verificar_instalacion.R
```

Debe terminar con `TODO LISTO`.

## Estructura del repositorio

```
├── seccion1_importar_y_QC.ipynb      # Sección 1
├── seccion2_diversidad_genetica.ipynb# Sección 2
├── R/
│   └── helpers.R                     # funciones del curso (importación, QC, diversidad)
├── 00_instalar_paquetes.R            # instala dependencias (ruta B)
├── 00_simular_datos.R                # genera el VCF y metadatos simulados
├── 00_verificar_instalacion.R        # chequea que todo esté listo
└── data/                             # se crea al ejecutar (ignorado por git)
```

## Formato de datos

Todo el curso trabaja con un contrato simple:

- `G`: matriz **individuos × SNP** con la dosis del alelo ALT (`0`, `1`, `2` o `NA`).
- `meta`: `data.frame` con una fila por individuo (`id`, `pop`, `lat`, `lon`, `alt`).

Si tienes datos reales, basta con llevarlos a ese formato (`data/geno_clean.rds` + `data/meta_clean.rds`) y el resto del código corre sin cambios.

## Licencia

[MIT](LICENSE) — úsalo, adáptalo y compártelo citando la fuente.
