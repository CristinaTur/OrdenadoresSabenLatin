install.packages("tm")
install.packages("topicmodels")
install.packages("scales")

library(tidyverse)
library(tidytext)
library(tm)
library(topicmodels)
library(scales)
library(dplyr)

#intento de hacer que lea lemas en lugar de texto real 

install.packages("udpipe")
library(udpipe)
library(tidyverse)
udpipe_download_model(language = "latin-proiel")
proiel <- udpipe_load_model(file = 'latin-proiel-ud-2.5-191206.udpipe')

republica_texto <- readLines("republica.txt")
republica_texto <- gsub("[-–—]", " — ", republica_texto)
republica_texto <- gsub(" ([\\.,;:])", "\\1", republica_texto)
republica_texto <- gsub(" {2,10}", " ", republica_texto)
republica_texto <- gsub("^ ", "", republica_texto)
analisis_republica <- udpipe_annotate(proiel, republica_texto, tagger = "default", parser = "none")
analisis_republica <- as_tibble(analisis_republica) 

republica_lematizado <- analisis_republica%>%
  select(lemma)%>%
  filter(lemma!= 'greek.expression')

republica_lematizado <- toString(republica_lematizado)

#Paginación de textos

texto.entrada <- republica_lematizado
texto.todo <- paste(texto.entrada, collapse = " ")
por.palabras <- strsplit(texto.todo, " ")
texto.palabras <- por.palabras[[1]]
trozos <- split(texto.palabras,
                ceiling(seq_along(texto.palabras)/350))

republica <- tibble(texto = character(),
                 pagina = numeric())

for (i in 1:length(trozos)){
  fragmento <- trozos[i]
  fragmento.unido <- tibble(texto = paste(unlist(fragmento),
                                          collapse = " "),
                            pagina = i)
  republica <- bind_rows(republica, fragmento.unido)
  }

 
#Tabla para guardar el texto paginado

republica_paginado <- tibble(texto = character(),
                  pagina = numeric())
 
for (i in 1:length(trozos)){
    fragmento <- trozos[i]
    fragmento.unido <- tibble(texto = paste(unlist(fragmento),
                                            collapse = " "),
                              pagina = i)
    republica_paginado <- bind_rows(republica_paginado, fragmento.unido)
}

#Clave para saber en qué folio está cada palabra y eliminación de palabras vacías

por_pagina_palabras <- republica_paginado %>%
  unnest_tokens(palabra, texto)

stopwords_lat <- read_tsv("stopwords_lat.tsv",
                      locale = default_locale(),
                      show_col_types = FALSE)  

filtro_rep <- read_csv("filtro_rep.csv",
                          locale = default_locale(),
                          show_col_types = FALSE)
filtro_rep <- filtro_rep[2]

palabra_conteo <- por_pagina_palabras %>%
  anti_join(stopwords_lat) %>%
  anti_join(filtro_rep) %>% 
  count(pagina,palabra, sort = T) %>%
  ungroup()
  


#Matriz Document-Term
  
paginas_dtm <- palabra_conteo %>%
    cast_dtm(pagina, palabra, n)

#modelo LDA
install.packages("reshape2")
library(reshape2)


paginas_lda <- LDA(paginas_dtm, k = 2, control = list(seed = 0))

paginas_lda_td <- tidy(paginas_lda, matrix = "beta")

#Para visualizar los números mejor
options(scipen=999)


terminos_frecuentes <- paginas_lda_td %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

#Gráfica
terminos_frecuentes %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()
