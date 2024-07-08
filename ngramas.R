install.packages("tidytext")
install.packages("reader")
install.packages("scales")
install.packages(c("igraph","ggraph"))

library(tidyverse)
library(tidytext)
library(reader)
library(dplyr)

library(ggplot2)
library(igraph)
library(ggraph)
library(grid)

ruta <- getwd()
leyes <- readLines(paste(ruta,
                         "/leyes.txt",
                         sep = ""))
leyes <- tibble(texto = tolower(leyes_texto))

bigramas <- leyes %>%
  unnest_tokens(bigrama,
                texto,
                token = "ngrams",
                n = 2) 
bigramas_separados <- bigramas %>%
  separate(bigrama,
           c("item1", "item2"),
           sep = " ")
rm (bigramas)

stopwords <- read_tsv("stop-words-greek.csv",
                      locale = default_locale(),
                      show_col_types = FALSE)

bigramas_filtrados <- bigramas_separados %>%
  filter(!item1 %in% stopwords$palabra,
         !item2 %in% stopwords$palabra)
rm(bigramas_separados)

recuento_bigramas <- bigramas_filtrados %>%
  count(item1, item2, sort = T)

#Red de palabras

grafo_bigramas <-recuento_bigramas %>%
  filter(n > 5) %>%
  graph_from_data_frame()

ggraph(grafo_bigramas) +
  geom_edge_link(aes(edge_alpha = "n"),
                 show.legend=FALSE,
                 arrow = arrow(type = "closed",
                               length = unit(3,"mm"))) +
  geom_node_point(color ="blue") +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void()
