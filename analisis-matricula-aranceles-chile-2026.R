# Analisis de Datos Cuantitativos
# Matricula en Educacion Superior 2026

# Requerimiento 1 ----

library(tidyverse)
library(janitor)

list.files("datos")

# Requerimiento 1: Importar base de datos

matricula_2026 <- read_delim(
  "datos/20260810_Matrícula_Ed_Superior_2026_PUBL_MRUN.csv",
  delim = ";",
  show_col_types = FALSE
)

# Verificar la importacion de la base

dim(matricula_2026)
names(matricula_2026)
problems(matricula_2026)


# Requerimiento 2: Exploracion de la base de datos ----

glimpse(matricula_2026)

problems(matricula_2026)

# Requerimiento 2: Clases de las variables ----

class(matricula_2026$anio_ing_carr_ori)
class(matricula_2026$nomb_inst)
class(matricula_2026$rango_edad)
class(matricula_2026$region_sede)
class(matricula_2026$valor_arancel)


# Requerimiento 3: Seleccion de variables ----

matricula_reducida <- matricula_2026 |>
  select(
    mrun,
    gen_alu,
    rango_edad,
    tipo_inst_1,
    tipo_inst_2,
    tipo_inst_3,
    nomb_inst,
    dur_total_carr,
    region_sede,
    nivel_global,
    nivel_carrera_2,
    valor_arancel,
    acreditada_inst,
    acreditada_carr,
    acre_inst_anio,
    nomb_carrera
  )

# Comprobar dimensiones y variables

dim(matricula_reducida)
names(matricula_reducida)


# Requerimiento 4: Descripcion de estudiantes ----

# Tabla de frecuencias segun sexo

tabla_sexo <- matricula_reducida |>
  tabyl(gen_alu)

tabla_sexo

# Requerimiento 4: Rango de edad ----

tabla_edad <- matricula_reducida |>
  tabyl(rango_edad)

tabla_edad


# Revisar clasificacion de instituciones

matricula_reducida |>
  tabyl(tipo_inst_2)


# Tabla definitiva de tipos de instituciones

tabla_institucion <- matricula_reducida |>
  count(tipo_inst_2, name = "n") |>
  complete(
    tipo_inst_2 = c(
      "Centros de Formación Técnica",
      "Institutos Profesionales",
      "Universidades (carrera en convenio)",
      "Universidades CRUCH",
      "Universidades Privadas"
    ),
    fill = list(n = 0)
  ) |>
  mutate(porcentaje = round(n / sum(n) * 100, 2))

tabla_institucion

# Revisar categorias de tipo_inst_1

matricula_reducida |>
  tabyl(tipo_inst_1)

# Comparar las tres clasificaciones institucionales

matricula_reducida |>
  count(tipo_inst_1, tipo_inst_2, tipo_inst_3)




# Requerimiento 4: Nivel de estudios ----

tabla_nivel <- matricula_reducida |>
  tabyl(nivel_carrera_2)

tabla_nivel




# Requerimiento 4: Años de acreditación ----

tabla_acreditacion <- matricula_reducida |>
  tabyl(acre_inst_anio)

tabla_acreditacion



# Revisar casos sin información de acreditación

matricula_reducida |>
  filter(is.na(acre_inst_anio)) |>
  tabyl(acreditada_inst)

# Requerimiento 5: Matricula por institucion ----

tabla_top10 <- matricula_reducida |>
  count(nomb_inst, sort = TRUE) |>
  head(10)

tabla_top10



# Requerimiento 5: Identificar carreras de Antropologia ----

matricula_reducida |>
  filter(str_detect(nomb_carrera, regex("antropolog", ignore_case = TRUE))) |>
  count(nomb_carrera, sort = TRUE)


# Requerimiento 5: Matricula en Antropologia por institucion ----

tabla_antropologia <- matricula_reducida |>
  filter(nomb_carrera == "ANTROPOLOGIA") |>
  count(nomb_inst, sort = TRUE)

tabla_antropologia


# Revisar carrera de Antropologia-Arqueologia

matricula_reducida |>
  filter(nomb_carrera == "ANTROPOLOGIA-ARQUEOLOGIA") |>
  count(nomb_inst, sort = TRUE)



# Requerimiento 5: Ranking de Antropologia
# Este ranking considera Antropologia y
# Antropologia-Arqueologia como programas relacionados.
# Se conserva tambien el analisis exclusivo de Antropologia
# para comparar ambos criterios.

tabla_antropologia_total <- matricula_reducida |>
  filter(nomb_carrera %in% c(
    "ANTROPOLOGIA",
    "ANTROPOLOGIA-ARQUEOLOGIA"
  )) |>
  count(nomb_inst, sort = TRUE)

tabla_antropologia_total


# Requerimiento 6: Matricula de carreras en la UC ----

matricula_reducida |>
  filter(nomb_inst == "PONTIFICIA UNIVERSIDAD CATOLICA DE CHILE") |>
  count(nivel_global)


# Requerimiento 6: Matricula por institucion, nivel y carrera ----

tabla_tres_variables <- matricula_reducida |>
  group_by(nomb_inst, nivel_global, nomb_carrera) |>
  summarise(
    matriculas = n(),
    .groups = "drop"
  )


# Requerimiento 6: Top 5 carreras de la UC ----

tabla_top5_uc <- tabla_tres_variables |>
  filter(nomb_inst == "PONTIFICIA UNIVERSIDAD CATOLICA DE CHILE") |>
  arrange(desc(matriculas)) |>
  head(5)

tabla_top5_uc



# Requerimiento 6: Top 5 carreras de postgrado en la UC ----

tabla_top5_postgrado <- tabla_tres_variables |>
  filter(
    nomb_inst == "PONTIFICIA UNIVERSIDAD CATOLICA DE CHILE",
    nivel_global == "Postgrado"
  ) |>
  arrange(desc(matriculas)) |>
  head(5)

tabla_top5_postgrado


# Revisar nombres completos de los programas

View(tabla_top5_uc)
View(tabla_top5_postgrado)




# Requerimiento 7: Clasificacion geografica ----

matricula_reducida |>
  tabyl(region_sede)





# Requerimiento 7: Crear zonas geograficas ----

matricula_reducida <- matricula_reducida |>
  mutate(
    zona_geografica = case_when(
      region_sede %in% c(
        "Arica y Parinacota", "Tarapacá",
        "Antofagasta", "Atacama", "Coquimbo"
      ) ~ "Norte",
      
      region_sede %in% c(
        "Valparaíso", "Metropolitana",
        "Lib. Gral. B. O'Higgins", "Maule"
      ) ~ "Centro",
      
      region_sede %in% c(
        "Ñuble", "Biobío", "La Araucanía",
        "Los Ríos", "Los Lagos",
        "Aysén", "Magallanes"
      ) ~ "Sur"
    )
  )



# Requerimiento 7: Verificar zonas geograficas ----

tabla_zonas <- matricula_reducida |>
  tabyl(zona_geografica)

tabla_zonas



# Requerimiento 7: Verificar regiones y zonas ----

matricula_reducida |>
  count(region_sede, zona_geografica)



# Requerimiento 8: Analisis de aranceles ----

matricula_reducida |>
  filter(str_detect(
    nomb_carrera,
    regex("antropolog|sociolog|trabajo social|psicolog",
          ignore_case = TRUE)
  )) |>
  count(nomb_carrera, sort = TRUE)



# Requerimiento 8: Seleccionar las cuatro carreras ----

carreras_sociales <- matricula_reducida |>
  filter(
    nomb_carrera %in% c(
      "ANTROPOLOGIA",
      "SOCIOLOGIA",
      "TRABAJO SOCIAL",
      "PSICOLOGIA"
    ),
    nivel_global == "Pregrado"
  )

# Comprobar cuantas matriculas tiene cada carrera

carreras_sociales |>
  count(nomb_carrera)



# Requerimiento 8: Revisar valores de aranceles ----

summary(carreras_sociales$valor_arancel)




# Requerimiento 8: Revisar aranceles bajos ----

carreras_sociales |>
  filter(valor_arancel < 10000) |>
  count(nomb_carrera, valor_arancel)


# Requerimiento 8: Verificar formato de los aranceles ----

matricula_2026 |>
  filter(valor_arancel < 10000,
         nomb_carrera == "PSICOLOGIA") |>
  count(formato_valores, valor_arancel)



# Requerimiento 8: Revisar monedas de las cuatro carreras ----

matricula_2026 |>
  filter(
    nomb_carrera %in% c(
      "ANTROPOLOGIA",
      "SOCIOLOGIA",
      "TRABAJO SOCIAL",
      "PSICOLOGIA"
    ),
    nivel_global == "Pregrado"
  ) |>
  count(nomb_carrera, formato_valores)




# Requerimiento 8: Revisar aranceles faltantes ----

carreras_sociales |>
  group_by(nomb_carrera) |>
  summarise(
    total = n(),
    faltantes = sum(is.na(valor_arancel)),
    arancel_cero = sum(valor_arancel == 0, na.rm = TRUE)
  )



# Requerimiento 8: Seleccionar aranceles expresados en pesos ----
# Los aranceles se encuentran expresados en pesos y UF.
# Para realizar los calculos en una misma unidad,
# se seleccionaron solamente los registros en pesos.
# Se excluyeron 3077 registros de Psicologia expresados en UF.
# Esta exclusion debe considerarse al interpretar los resultados.

carreras_pesos <- matricula_2026 |>
  filter(
    nomb_carrera %in% c(
      "ANTROPOLOGIA",
      "SOCIOLOGIA",
      "TRABAJO SOCIAL",
      "PSICOLOGIA"
    ),
    nivel_global == "Pregrado",
    formato_valores == "Monto en Pesos"
  )

# Verificar la cantidad de registros por carrera

carreras_pesos |>
  count(nomb_carrera)



# Requerimiento 8: Media y mediana por carrera ----

tabla_aranceles <- carreras_pesos |>
  group_by(nomb_carrera) |>
  summarise(
    promedio = mean(valor_arancel, na.rm = TRUE),
    mediana = median(valor_arancel, na.rm = TRUE),
    .groups = "drop"
  )

tabla_aranceles


# Requerimiento 8: Desviacion estandar y rango intercuartilico ----

tabla_dispersion <- carreras_pesos |>
  group_by(nomb_carrera) |>
  summarise(
    desviacion_estandar = sd(valor_arancel, na.rm = TRUE),
    rango_intercuartilico = IQR(valor_arancel, na.rm = TRUE),
    .groups = "drop"
  )

tabla_dispersion

# Requerimiento 8: Moda de aranceles por carrera ----

tabla_moda <- carreras_pesos |>
  count(nomb_carrera, valor_arancel) |>
  group_by(nomb_carrera) |>
  arrange(desc(n), .by_group = TRUE) |>
  slice_head(n = 1) |>
  ungroup()

tabla_moda

# Requerimiento 8: Cuartiles por carrera ----

tabla_cuartiles <- carreras_pesos |>
  group_by(nomb_carrera) |>
  summarise(
    Q1 = quantile(valor_arancel, 0.25, na.rm = TRUE),
    Q2 = quantile(valor_arancel, 0.50, na.rm = TRUE),
    Q3 = quantile(valor_arancel, 0.75, na.rm = TRUE),
    .groups = "drop"
  )

tabla_cuartiles


# Requerimiento 8: Quintiles por carrera ----

tabla_quintiles <- carreras_pesos |>
  group_by(nomb_carrera) |>
  summarise(
    P20 = quantile(valor_arancel, 0.20, na.rm = TRUE),
    P40 = quantile(valor_arancel, 0.40, na.rm = TRUE),
    P60 = quantile(valor_arancel, 0.60, na.rm = TRUE),
    P80 = quantile(valor_arancel, 0.80, na.rm = TRUE),
    .groups = "drop"
  )

tabla_quintiles


# Requerimiento 8: Percentiles por carrera ----

tabla_percentiles <- carreras_pesos |>
  group_by(nomb_carrera) |>
  summarise(
    P5 = quantile(valor_arancel, 0.05, na.rm = TRUE),
    P95 = quantile(valor_arancel, 0.95, na.rm = TRUE),
    .groups = "drop"
  )

tabla_percentiles


                  
                  
                 