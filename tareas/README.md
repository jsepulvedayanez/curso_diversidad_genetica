# `tareas/` — tus copias de trabajo

Aquí están las **copias de los notebooks para que trabajes**. Son tuyas: los ejercicios, las respuestas y las figuras van acá.

| Archivo | Qué contiene |
|---|---|
| `seccion0_introduccion.ipynb` | Pipeline, formato VCF y las tareas de la Sección 0 |
| `seccion1_importar_y_QC.ipynb` | QC de datos faltantes y sus ejercicios |
| `seccion2_diversidad_genetica.ipynb` | Ho, He, Fis, bootstrap y gradiente latitudinal |
| `seccion3_revision_vcf.ipynb` | Un VCF real: anatomía, ficha técnica, señales de alerta, filtros y diversidad + PCA sobre el archivo limpio |

## La regla

> **Los notebooks de la raíz del repositorio no se editan.** Se leen y se ejecutan tal cual: son el material de clase, y si los modificas, el próximo `git pull` te va a chocar. Tus respuestas van en la copia de esta carpeta.

Las copias se generaron desde los originales; el código y los textos son idénticos. Solo cambian dos cosas al principio:

1. Una celda de texto que dice de dónde salió la copia.
2. Una celda de código que ajusta la ruta de trabajo (`setwd("..")` si el kernel arrancó dentro de `tareas/`), porque el curso usa rutas relativas a la raíz del repositorio. **Ejecútala primero, siempre.**

En la Sección 3 ese ajuste de ruta no está en una celda aparte: va al final de la celda **Preparación (ejecutar primero)**, que igual hay que correr antes que nada.

## Cómo trabajar

```bash
git clone https://github.com/jsepulvedayanez/curso_diversidad_genetica.git
cd curso_diversidad_genetica
Rscript 00_simular_datos.R      # una sola vez: genera data/
conda activate genetica
jupyter lab                     # abrir desde la raíz del repo
```

Después abres el notebook de `tareas/` que corresponda a la clase, verificas que el kernel sea **R** (`ir`) y ejecutas de arriba hacia abajo.

Si prefieres no tocar `main`, crea una rama para tu trabajo:

```bash
git checkout -b tareas
```

## Cómo entregar

Al terminar una tarea, avisa con un commit y sube tus cambios:

```bash
git add tareas/
git commit -m "Tarea sección 2"
git push
```

Si trabajas sobre un **fork** (una copia del repositorio en tu cuenta), después de ese `push` GitHub te ofrece el botón **Compare & pull request**; ábrelo hacia el repositorio del curso con el título `Tarea sección 2`. Así queda la revisión con los comentarios al lado de cada línea.

Si trabajas clonando directamente el repositorio del curso, con el `push` a tu rama basta: avisa por el canal de la clase con el nombre de la rama.

## Si una sección se actualiza

A veces el material cambia (una explicación mejor, un error corregido). Cuando eso pase, actualiza **solo esa copia** sin perder tu trabajo:

```bash
git stash                     # guarda tus cambios un momento
git pull                      # trae la versión nueva
git stash pop                 # recupera tus cambios
```

Si el aviso dice que el notebook original cambió, cópialo de nuevo y vuelve a pasar tus respuestas:

```bash
cp seccion2_diversidad_genetica.ipynb tareas/seccion2_diversidad_genetica.ipynb
```

> ¿Cómo saber si tu copia está vieja? La primera celda dice el commit y la fecha desde la que se generó. Compárala con el último commit del repositorio (`git log --oneline -1`).

## Reglas del repositorio

- **`data/` no se sube**: está en `.gitignore` y se regenera con `Rscript 00_simular_datos.R`.
- **No subas notebooks con salidas enormes.** Antes de commitear: *Kernel → Restart & Clear Output*. Si la salida es la figura de la tarea, guárdala como imagen aparte.
- **Figuras con nombres sin espacios ni tildes**: `he_por_poblacion.png`, no `He por población final.png`.
- **Un commit por tarea**, con mensaje corto en inglés (`Add section 2 report`), como el resto del repositorio.
- **Nunca `git push --force`** mientras tengas una entrega abierta.

## Problemas frecuentes

| Síntoma | Qué pasó | Solución |
|---|---|---|
| `error: Your local changes would be overwritten by merge` | editaste un notebook de la raíz | `git stash`, `git pull`, `git stash pop` y mueve tus cambios a `tareas/` |
| `cannot open file 'data/lenga_sim.vcf'` | falta generar los datos | `Rscript 00_simular_datos.R` desde la raíz |
| `no such file 'R/helpers.R'` | abriste Jupyter desde otra carpeta | abre Jupyter **desde la raíz del repositorio** |
| El push pide contraseña y falla | GitHub ya no acepta contraseña | usa un *token* personal o GitHub Desktop |
| El kernel no es `ir` | quedó otro kernel seleccionado | menú *Kernel → Change kernel → R* |

## Dónde va cada cosa

```
tareas/
├── seccion0_introduccion.ipynb          # tu copia de la Sección 0
├── seccion1_importar_y_QC.ipynb         # tu copia de la Sección 1
├── seccion2_diversidad_genetica.ipynb   # tu copia de la Sección 2
├── figuras/                             # tus figuras para las entregas
└── notas/                               # borradores, hipótesis, apuntes
```
