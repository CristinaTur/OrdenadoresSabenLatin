install.packages("tidytext")
install.packages("reader")
install.packages("scales")

library(tidyverse)
library(tidytext)

library(reader) 
library(scales)

#Lectura de ficheros

ruta <- "corpus-teatro/"
ficheros <- list.files(path = ruta,
                       pattern = "*.txt")
autor <- autor <- gsub("\\.txt",
                         "",
                         ficheros,
                         perl = TRUE)
teatro <- tibble(autor = character(),
                    texto = character())
for (i in 1:length(ficheros)){
  obra <- readLines(paste(ruta,
                              ficheros[i],
                              sep = "/"))
  temporal <- tibble(autor = autor[i],
                     texto = tolower(obra))
  teatro <- bind_rows(teatro, temporal)
}
rm(temporal, i, ficheros, ruta, autor, obra)

#Tokenización

teatro_palabras <- teatro %>%
  unnest_tokens(palabra, texto)

#Agrupación y filtrado de frecuencias

frecuencias_teatro <- teatro_palabras %>%
  group_by(autor) %>%
  count(autor, sort =T) %>%
  ungroup()
