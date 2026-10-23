# Diversidad genética en lenga · Secciones 1 a 3

Material docente en **R** para un curso de genética de poblaciones aplicado a *Nothofagus pumilio* (lenga), la especie arbórea dominante de los bosques subantárticos de Patagonia.

Este repositorio contiene una **introducción** (Sección 0) y las **tres primeras secciones** del curso: del archivo VCF a las estimaciones de diversidad genética y al filtrado de un archivo real. Está pensado para trabajarse en **JupyterLab** con kernel de **R**, explicando en clase y con ejercicios guiados.

> **Nota sobre los datos:** se usan datos **simulados** (`00_simular_datos.R`) que imitan rasgos generales de la lenga (rango latitudinal ~2.000 km, estructura alineada con la latitud, gradiente de temperatura). **No son datos biológicos reales**: sirven para practicar el flujo de análisis con una «verdad» conocida.
>
> Aparte, el repositorio **sí incluye datos reales de ejemplo** en `datos_ejemplo/`, los dos de Sekely et al. (2024): un recorte mínimo —3 sitios × 6 árboles × 301 SNP— para mirar un VCF verdadero en la Sección 0, y un **extracto del VCF publicado** —207 muestras × 1 782 SNP, con `GT:AD:DP:GQ`— que es el que se trabaja en la Sección 3. El archivo completo de ese estudio (20 sitios, 502 muestras, 116 136 variantes, 495 MB) está disponible en Zenodo, DOI [`10.5281/zenodo.10018374`](https://doi.org/10.5281/zenodo.10018374) (CC-BY-4.0), pero el curso **no** lo necesita: el extracto se generó con `scripts/extraer_vcf_real.sh` y se puede reproducir.

---

## Contenido

Cada **sección** es una unidad autónoma de contenido:

| Sección | Notebook | Contenido | Tarea |
|---|---|---|---|
| 0 | `seccion0_introduccion.ipynb` | Contexto: la lenga, el estudio, cómo se genera un VCF | Mirar un VCF real + hipótesis de diversidad (antes de leer el paper) + **presentación completa del paper** con las cinco preguntas metodológicas (`10.1002/ppp3.10504`) |
| 1 | `seccion1_importar_y_QC.ipynb` | Control de calidad de **datos faltantes**: VCF → matriz de dosis → filtrado por call rate (MAF y LD se cierran en las Secciones 2 y 3) | 5 líneas de Métodos con los dos umbrales + tabla de sensibilidad |
| 2 | `seccion2_diversidad_genetica.ipynb` | Ho, He, Fis, bootstrap, gradiente latitudinal | Gráfico «publicable» de He con IC + conclusión sin «significativo» |
| 3 | `seccion3_revision_vcf.ipynb` | Un **VCF real**: anatomía, ficha técnica y tres señales de alerta (parálogos, profundidad/calidad, réplicas) | Ficha técnica completa + tabla de tres alertas con su decisión |

Cada sección termina con una **Tarea** que se revisa al comienzo de la clase siguiente, y cada notebook incluye:

- objetivos de aprendizaje,
- teoría con ejemplos numéricos e intuición,
- preguntas de anticipación («¿qué esperas?») para discutir antes de ejecutar,
- ejercicios guiados (E1, E2…) con su «idea clave»,
- errores y dudas frecuentes,
- resumen de las ideas principales.

Las **copias para trabajar** —donde van tus respuestas y tus figuras— están en [`tareas/`](tareas/); los notebooks de la raíz son el material de clase (ver *Cómo empezar → 6*).

## Cómo empezar

### 1. Traer el repositorio

```bash
git clone https://github.com/jsepulvedayanez/curso_diversidad_genetica.git
cd curso_diversidad_genetica
```

Si no tienes `git`, descarga el ZIP con **Code → Download ZIP** en la página del repositorio.

### 2. Preparar el entorno (una sola vez)

Sigue la guía de instalación que te enviamos (`COMO_INSTALAR.docx`); la misma guía está en este repositorio: [`docs/guia_instalacion.md`](docs/guia_instalacion.md). Los dos scripts del paquete también están aquí:

```bash
Rscript 00_instalar_paquetes.R        # instala los paquetes de R
Rscript 00_verificar_instalacion.R    # debe terminar en TODO LISTO
```

### 3. Generar los datos del curso (una sola vez)

El repositorio **no incluye** los datos de trabajo: se generan con una semilla fija, así que te queda el mismo archivo que usamos en clase. Toma un par de segundos:

```bash
Rscript 00_simular_datos.R            # escribe data/lenga_sim.vcf y los metadatos
```

Si `data/` está vacío, los notebooks no pueden leer el VCF: este paso es obligatorio antes de la Sección 1. Los **datos reales de ejemplo** (`datos_ejemplo/`) ya vienen en el repositorio: no hay que descargar nada.

### 4. Abrir los notebooks

```bash
conda activate genetica
jupyter lab
```

Elige el kernel de **R** (`ir`) y ejecuta las celdas en orden, de arriba hacia abajo.

### 5. Antes de cada clase

```bash
git pull
```

### 6. Dónde hacer los ejercicios: `tareas/`

En `tareas/` están las **copias de los notebooks para trabajar**. Ahí van tus respuestas, tus figuras y tus notas; los notebooks de la raíz son el material de clase y **no se editan** (si los modificas, el próximo `git pull` choca).

```text
seccion0_introduccion.ipynb            # original (no editar)
tareas/seccion0_introduccion.ipynb     # tu copia (editar acá)
```

Instrucciones completas, cómo entregar y problemas frecuentes: [`tareas/README.md`](tareas/README.md).

## Requisitos

- **R** ≥ 4.2
- Paquetes de R: `ggplot2`, `vcfR`, `adegenet`, `hierfstat`, `pegas`, `vegan`, `LEA` y `IRkernel`
- **JupyterLab** con kernel de R

Guía de instalación paso a paso, con tres rutas alternativas (conda, R propio y Colab) y una tabla de problemas frecuentes: [`docs/guia_instalacion.md`](docs/guia_instalacion.md). Al terminar, `Rscript 00_verificar_instalacion.R` debe terminar en **`TODO LISTO`**.

### Instalación

La forma más simple es con Miniforge + conda (entorno aislado, sin tocar tu R):

```bash
conda create -n genetica -c conda-forge -c bioconda \
  r-base r-irkernel jupyterlab r-ggplot2 r-vcfr \
  r-adegenet r-hierfstat r-pegas r-vegan bioconductor-lea
conda activate genetica
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
├── seccion0_introduccion.ipynb       # Sección 0 (contexto y origen de los datos)
├── seccion1_importar_y_QC.ipynb      # Sección 1
├── seccion2_diversidad_genetica.ipynb# Sección 2
├── seccion3_revision_vcf.ipynb       # Sección 3
├── tareas/                           # copias de trabajo (aquí se edita)
│   ├── seccion0_introduccion.ipynb
│   ├── seccion1_importar_y_QC.ipynb
│   ├── seccion2_diversidad_genetica.ipynb
│   ├── seccion3_revision_vcf.ipynb
│   ├── figuras/                      # figuras para las entregas
│   └── notas/                        # borradores y apuntes
├── R/
│   └── helpers.R                     # funciones del curso (importación, QC, diversidad)
├── docs/
│   └── formato_vcf.md                # explicación de cada columna del VCF
├── datos_ejemplo/
│   ├── lenga_ejemplo.vcf             # VCF real recortado (3 sitios × 6 ind × 301 SNP)
│   ├── lenga_ejemplo_meta.csv        # metadatos (id, pop, lat, lon, alt)
│   ├── lenga_real_1782snp.vcf.gz     # extracto del VCF publicado (207 muestras × 1 782 SNP)
│   ├── lenga_real_muestras.csv       # una fila por muestra, en el orden del VCF
│   ├── lenga_real_sitios.csv         # los 20 sitios de muestreo
│   └── LEEME.md                      # qué es cada archivo y cómo se generó
├── scripts/                          # generación reproducible del extracto real
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

## Datos reales de ejemplo

Además de la simulación, el repo incluye un **VCF real** de lenga ya recortado para empezar sin descargar nada:

```
datos_ejemplo/lenga_ejemplo.vcf       # 3 sitios × 6 individuos × 301 SNP (solo el campo GT)
datos_ejemplo/lenga_ejemplo_meta.csv  # id, pop, loc, lat, lon, alt
```

- Los 3 sitios cubren todo el rango latitudinal: **Epulaufquen** (norte, ~36.8°S), **Lago Guacho** (centro, ~43.8°S) y **Ushuaia** (sur, ~54.8°S).
- Viene **sin filtrar** a propósito (incluye SNP monomórficos y raros) para que practiques el QC de la Sección 1.

Y para la Sección 3, un **extracto del VCF publicado**:

```
datos_ejemplo/lenga_real_1782snp.vcf.gz  # 207 muestras × 1 782 SNP, GT:AD:DP:GQ
datos_ejemplo/lenga_real_muestras.csv    # id, árbol, sitio, clase de elevación, lat, lon, altitud
datos_ejemplo/lenga_real_sitios.csv      # los 20 sitios (10 árboles cada uno)
```

- 200 árboles (10 por sitio) + 6 réplicas + 1 muestra que quedó casi sin datos: las tres cosas son parte de la actividad.
- Un SNP al azar por contig, en 1 782 contigs: son nodos de un ensamblaje *de novo*, no cromosomas.
- Ficha completa y receta de generación en [`datos_ejemplo/LEEME.md`](datos_ejemplo/LEEME.md).
- La explicación de cada columna del VCF está en [`docs/formato_vcf.md`](docs/formato_vcf.md).

**Fuente y licencia:** subconjunto del dataset de Sekely et al. (2024), *Plants, People, Planet* (DOI: 10.1002/ppp3.10504), depositado en Zenodo (DOI: 10.5281/zenodo.10018374) bajo licencia **CC-BY-4.0**.

## Licencia

[MIT](LICENSE) — úsalo, adáptalo y compártelo citando la fuente.
