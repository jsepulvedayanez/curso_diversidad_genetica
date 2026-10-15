# Guía de instalación — Curso de diversidad genética en lenga (*Nothofagus pumilio*)

Trabajaremos con **JupyterLab** y **R**. Son unos 20–40 minutos, casi todo descarga automática.
**Hazlo antes de la primera clase** y avísame si algo falla.

> Estas instrucciones cubren los tres sistemas (Windows, macOS, Linux). Si un paso falla, cópiame el mensaje de error completo: con eso lo resolvemos rápido.

## Qué vas a tener al final

- **R** con los paquetes del curso: `ggplot2`, `vcfR`, `adegenet`, `hierfstat`, `pegas`, `vegan`, `LEA`.
- **JupyterLab** con el kernel de **R** registrado.
- La **carpeta del curso** con los tres notebooks (`seccion0`, `seccion1`, `seccion2`), las funciones `R/helpers.R`, los datos de ejemplo y las diapositivas.

## Los archivos del curso

```
curso_lenga_estudiante/
├── GUIA_INSTALACION.md / .docx        ← esta guía
├── seccion0_introduccion.ipynb        ← Sección 0: contexto y origen de los datos
├── seccion1_importar_y_QC.ipynb       ← Sección 1: control de calidad (la primera clase)
├── seccion2_diversidad_genetica.ipynb ← Sección 2: diversidad
├── R/helpers.R                        ← funciones del curso
├── 00_instalar_paquetes.R             ← instalación automática (ruta B)
├── 00_verificar_instalacion.R         ← comprueba que todo esté listo
├── 00_simular_datos.R                 ← genera los datos simulados (se ejecuta solo)
├── diapos/00_introduccion_metodologia.html  ← diapositivas (se abren en el navegador)
├── datos_ejemplo/                     ← un VCF real de lenga, recortado
└── docs/formato_vcf.md                ← explicación de cada columna del VCF
```

---

## Ruta A (recomendada): Miniforge + conda

Instala todo en un entorno aislado, sin tocar el R que ya tengas.

### 1. Instalar Miniforge
Descarga el instalador para tu sistema desde <https://github.com/conda-forge/miniforge> (sección *Download*) y ejecútalo con las opciones por defecto.

- **Windows:** después abre **«Miniforge Prompt»** desde el menú Inicio.
- **macOS / Linux:** abre una **Terminal** nueva.

### 2. Crear el entorno del curso
Copia y pega **una sola línea** (puede tardar varios minutos):

```
conda create -n lenga -c conda-forge -c bioconda r-base r-irkernel jupyterlab r-ggplot2 r-vcfr r-adegenet r-hierfstat r-pegas r-vegan bioconductor-lea
```

Cuando pregunte `Proceed ([y]/n)?`, escribe `y` y Enter.

### 3. Activar el entorno
```
conda activate lenga
```
Debe aparecer `(lenga)` al inicio de la línea. **Este paso se repite cada vez que abras una terminal nueva.**

### 4. Abrir el curso
Descomprime `curso_lenga_estudiante.zip` (por ejemplo en `Documentos`). En la terminal, entra a la carpeta y abre Jupyter:

```
cd ruta/a/curso_lenga_estudiante
jupyter lab
```

En Windows una ruta típica sería `cd C:\Users\TuUsuario\Documents\curso_lenga_estudiante`.

Se abrirá el navegador. En el panel izquierdo verás los notebooks `seccion0_...`, `seccion1_...` y `seccion2_...`.

### 5. Verificar
Abre `seccion1_importar_y_QC.ipynb`. Arriba a la derecha debe decir **R** (si dice otra cosa, haz clic ahí y elige *R*). Ejecuta la primera celda con **Shift + Enter**: debe crear los datos simulados sin error.

Desde la terminal, con el entorno activado, puedes hacer la prueba completa:

```
Rscript 00_verificar_instalacion.R
```

Debe terminar con **`TODO LISTO`** y mostrar la tabla `Original / Filtrado`. Eso significa que los paquetes, los datos y el flujo de la Sección 1 funcionan.

---

## Ruta B: R instalado por separado + Jupyter

Úsala si prefieres instalar R directamente o si la ruta A falla.

1. **Instalar R ≥ 4.2** desde <https://cran.r-project.org>.
   - **Windows:** instala también **Rtools** (la versión que corresponda a tu R; está en la misma página de CRAN).
   - **macOS:** en la Terminal, `xcode-select --install`.
   - **Linux (Ubuntu/Debian):** `sudo apt install r-base r-base-dev libcurl4-openssl-dev libssl-dev libxml2-dev`.
2. **Instalar JupyterLab** (por ejemplo con Miniforge y luego `pip install jupyterlab`).
3. En la carpeta del curso, abre R y ejecuta:
   ```r
   source("00_instalar_paquetes.R")
   ```
   Instala los paquetes (incluido `LEA`, que viene de Bioconductor) y registra R como kernel de Jupyter. Puede tardar 10–20 minutos.
4. En la terminal: `jupyter lab`, y continúa como en los pasos 4–5 de la ruta A.

---

## Ruta C (último recurso): Google Colab

Si nada funciona: <https://colab.research.google.com> → *Cambiar tipo de entorno de ejecución* → **R**. Hay que subir la carpeta del curso e instalar los paquetes **en cada sesión** (`install.packages(...)` y `BiocManager::install("LEA")`), lo que es lento. Úsala solo para salir del paso; avísame si llegaste aquí.

---

## Cómo trabajar durante el curso

- Abre siempre Jupyter **desde la carpeta del curso** (para que encuentre `R/helpers.R` y `data/`).
- Ejecuta las celdas **en orden**. La primera celda de cada notebook es *Preparación*: siempre primero.
- La primera vez se crean los **datos simulados** en `data/` (tarda unos segundos).
- Las celdas de **ejercicios** (E1, E2…) están casi vacías: ahí escribes tu código.
- Guarda con **Ctrl + S** (**Cmd + S** en Mac).
- Para cerrar: guarda, cierra la pestaña y en la terminal presiona **Ctrl + C** (dos veces).

## Problemas frecuentes

| Síntoma | Qué hacer |
|---|---|
| `conda: command not found` | Cierra y abre la terminal; en Windows usa **Miniforge Prompt**, no PowerShell normal. |
| No aparece el kernel **R** en Jupyter | Con el entorno activado: `R -e "IRkernel::installspec(user = TRUE)"` y reinicia Jupyter. |
| `there is no package called 'xxx'` | En R: `install.packages("xxx")`. Para `LEA`: `BiocManager::install("LEA")`. |
| Error de compilación en Windows | Falta **Rtools**, o su versión no coincide con tu R. |
| `cannot open file 'R/helpers.R'` | Abriste Jupyter desde otra carpeta. Ciérralo y ábrelo dentro de `curso_lenga_estudiante`. |
| `cannot open file 'data/lenga_sim.vcf'` | Ejecuta `source("00_simular_datos.R")` en una celda. |
| Los gráficos salen enormes o diminutos | Vuelve a ejecutar la celda *Preparación* del notebook. |
| La instalación se queda en `Solving environment` | Es normal si tarda varios minutos; si pasan más de 30, cancela con Ctrl + C y avísame. |
| El verificador dice «Los paquetes funcionan, pero el filtro dio otros números» | Modificaste `helpers.R` o los umbrales: restaura el archivo original y avísame. |

## Antes de la primera clase

- [ ] Instalación terminada y `Rscript 00_verificar_instalacion.R` termina en **`TODO LISTO`**
- [ ] `seccion1_importar_y_QC.ipynb` abre con kernel **R** y la celda *Preparación* corre sin error
- [ ] Abrí `seccion0_introduccion.ipynb` y leí sus objetivos
- [ ] Abrí las diapositivas (`diapos/00_introduccion_metodologia.html`) en el navegador

Si algo no cuadra, envíame: **sistema operativo**, **ruta seguida** (A, B o C) y **el mensaje de error completo**.
