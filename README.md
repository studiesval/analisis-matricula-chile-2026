# Análisis de matrícula y aranceles en educación superior chilena (2026)

## Objetivo

Explorar registros de matrícula en educación superior en Chile durante 2026, comparando distribuciones por características de estudiantes, tipos de institución, carreras y regiones, y describiendo los aranceles de carreras de ciencias sociales.

## Herramientas y técnicas

- **R**, `tidyverse` y `janitor`.
- Importación, exploración, selección y agrupación de variables.
- Tablas de frecuencia y estadísticas descriptivas: media, mediana, desviación estándar, rango intercuartílico, moda, cuartiles, quintiles y percentiles.
- Clasificación territorial y revisión de datos faltantes y unidades monetarias.

## Archivos

- `analisis-matricula-aranceles-chile-2026.R`: script original del trabajo académico.
- `.gitignore`: excluye datos de gran tamaño, objetos locales y archivos de sesión.

## Fuente y reproducción

El trabajo utiliza la base de matrícula de educación superior 2026 del sistema de información del Ministerio de Educación de Chile (SIES), con el archivo de origen usado en el curso:

`20260810_Matrícula_Ed_Superior_2026_PUBL_MRUN.csv`

El archivo **no se redistribuye** aquí. Para reproducir el análisis, obtén la versión correspondiente de la fuente oficial autorizada y colócala en una carpeta local llamada `datos/` con ese mismo nombre.

En R, instala las dependencias y ejecuta el script desde la raíz del proyecto:

```r
install.packages(c("tidyverse", "janitor"))
source("analisis-matricula-aranceles-chile-2026.R")
```

El script fue elaborado para RStudio e incluye operaciones interactivas como `View()`. **Esta publicación no implica que se haya verificado una nueva ejecución completa del script con el CSV original.**

## Criterios metodológicos y limitaciones

- El script cuenta registros de matrícula: estos no equivalen necesariamente al número de personas únicas.
- Los valores de arancel combinan **pesos y UF**. Para la comparación de aranceles de Antropología, Sociología, Trabajo Social y Psicología, el análisis restringe los registros a los expresados en pesos; no convierte los valores en UF.
- Las estadísticas de arancel se calculan sobre los registros seleccionados, no como un promedio simple entre instituciones.
- Se trata de un análisis descriptivo; no permite establecer relaciones causales.
- Las cifras deben verificarse al reproducir el análisis con la misma versión de la base.

## Estado del proyecto

Trabajo académico realizado en 2026. Se publica como evidencia de experiencia en manejo y análisis cuantitativo de datos con R.
