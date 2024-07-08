install.packages("udpipe")
library(udpipe)
library(tidyverse)
udpipe_download_model(language = "ancient_greek-proiel")
proiel <- udpipe_load_model(file = 'ancient_greek-proiel-ud-2.5-191206.udpipe')

leyes_texto <- readLines("leyes.txt")
leyes_texto <- gsub("[-–—]", " — ", leyes_texto)
leyes_texto <- gsub(" ([\\.,;:])", "\\1", leyes_texto)
leyes_texto <- gsub(" {2,10}", " ", leyes_texto)
leyes_texto <- gsub("^ ", "", leyes_texto)
analisis_leyes <- udpipe_annotate(proiel, leyes_texto, tagger = "default", parser = "default")
analisis_leyes <- as_tibble(analisis_leyes) 


#Gráfica

clases <- analisis_leyes %>%
    drop_na(upos) %>%
    count(upos, sort = T)

ggplot(clases, aes(upos, n)) +
    geom_col() +
    coord_flip()

analisis_leyes %>%
  filter(upos == "NOUN") %>%
  drop_na(lemma) %>%
  count(lemma, sort = T)%>%
  mutate(lemma = reorder(lemma, n)) %>%
  top_n(10) %>%
  ggplot(aes(lemma, n)) +
  geom_col(fill = "blue") +
  coord_flip()