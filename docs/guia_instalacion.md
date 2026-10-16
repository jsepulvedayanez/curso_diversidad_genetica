# Cómo instalar el entorno

Guía para dejar instalado **R + JupyterLab + los 7 paquetes** que se usan en el curso.
Son unos 20–40 minutos, casi todo descarga automática. No hay que saber nada de antemano.

> Si un paso falla, copia **el mensaje de error completo** y envíalo.

## Qué se instala

| | |
|---|---|
| **R** | el lenguaje, versión 4.2 o superior |
| **JupyterLab** | el entorno de trabajo donde se ejecuta R |
| **Paquetes de R** | `ggplot2`, `vcfR`, `adegenet`, `hierfstat`, `pegas`, `vegan`, `LEA` |
| **Kernel de R** | para que JupyterLab pueda ejecutar R |

Los dos archivos que acompañan a esta guía:

```
00_instalar_paquetes.R        ← instala los paquetes y registra el kernel (solo Ruta B)
00_verificar_instalacion.R    ← comprueba que todo quedó bien
```

---

## Ruta A (recomendada): Miniforge + conda

Instala todo en un entorno aparte, **sin tocar el R que ya tengas**.

### 1. Instalar Miniforge
Descarga el instalador para tu sistema desde <https://github.com/conda-forge/miniforge> (sección *Download*) y ejecútalo con las opciones por defecto.

- **Windows:** después abre **«Miniforge Prompt»** desde el menú Inicio.
- **macOS / Linux:** abre una **Terminal** nueva.

### 2. Crear el entorno
Copia y pega **una sola línea** (puede tardar varios minutos):

```
conda create -n genetica -c conda-forge -c bioconda r-base r-irkernel jupyterlab r-ggplot2 r-vcfr r-adegenet r-hierfstat r-pegas r-vegan bioconductor-lea
```

Cuando pregunte `Proceed ([y]/n)?`, escribe `y` y Enter.

### 3. Activar el entorno
```
conda activate genetica
```

Debe aparecer `(genetica)` al inicio de la línea. **Este paso se repite cada vez que abras una terminal nueva.**

### 4. Verificar
Con el entorno activado, en la carpeta donde descomprimiste estos archivos:

```
Rscript 00_verificar_instalacion.R
```

Debe listar los siete paquetes como `TRUE` y terminar con **`TODO LISTO ✔`**. Ahí la instalación está completa.

---

## Ruta B: usar un R que ya tengas instalado

Úsala si prefieres no instalar Miniforge o si la Ruta A falla.

1. Asegúrate de tener **R ≥ 4.2** (<https://cran.r-project.org>).
   - **Windows:** instala también **Rtools** (la versión que corresponda a tu R; está en la misma página de CRAN).
   - **macOS:** en la Terminal, `xcode-select --install`.
   - **Linux (Ubuntu/Debian):** `sudo apt install r-base r-base-dev libcurl4-openssl-dev libssl-dev libxml2-dev`.
2. Necesitas además **JupyterLab**, que se instala con Python. Si no lo tienes, la vía simple es instalar Miniforge y luego `pip install jupyterlab`.
3. En la carpeta donde descomprimiste estos archivos, abre **R** y ejecuta:
   ```r
   source("00_instalar_paquetes.R")
   ```
   Instala los paquetes que falten (incluido `LEA`, que viene de Bioconductor) y registra R como kernel de Jupyter. Puede tardar 10–20 minutos.
4. Verifica como en el paso 4 de la Ruta A.

---

## Problemas frecuentes

| Síntoma | Qué hacer |
|---|---|
| `conda: command not found` | Cierra y abre la terminal; en Windows usa **Miniforge Prompt**, no PowerShell normal. |
| La instalación se queda en `Solving environment` | Es normal si tarda varios minutos. Si pasan más de 30, cancela con **Ctrl + C** y avísame. |
| `there is no package called 'xxx'` | En R: `install.packages("xxx")`. Para `LEA`: `BiocManager::install("LEA")`. |
| Error de compilación en Windows | Falta **Rtools**, o su versión no coincide con tu R. |
| `Rscript` no se reconoce como comando | El entorno no está activado: vuelve al paso 3 (`conda activate genetica`). |
| Al verificar aparece algo en `FALSE` | Ese paquete no quedó instalado. El script dice cuál falta y con qué comando instalarlo. |
| Quiero comprobar el kernel de R | Con el entorno activado: `R -e "IRkernel::installspec(user = TRUE)"`. |

---

## Antes de empezar el curso

- [ ] `Rscript 00_verificar_instalacion.R` termina con **`TODO LISTO ✔`**
- [ ] Los siete paquetes aparecen como `TRUE`

Si algo no cuadra, envía: **sistema operativo**, **ruta seguida** (A o B) y **el mensaje de error completo**.
