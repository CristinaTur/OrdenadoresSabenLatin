install.packages("stylo")
install.packages("reader")
library(stylo)
library(tidytext)
library(tidyverse)
library(reader)

#Agamenón

agamemnon_texto <- read_lines("corpus/agamemnon.txt",
                              skip=30)

#Hércules loco

herc_fur_texto <- read_lines("corpus/HercFur.txt",
                             skip=26)
#Medea

medea_texto <- read_lines("corpus/medea.txt",
                          skip=26)
#Edipo Tirano

oedipus_texto <- read_lines("corpus/oedipus.txt",
                            skip=28)
#Fedra

phaedra_texto <- read_lines("corpus/phaedra.txt",
                            skip=25)

#Fenicias

phoenissae_texto <- read_lines("corpus/phoenissae.txt",
                               skip=25)

#Tiestes

thyestes_texto <- read_lines("corpus/thyestes.txt",
                             skip=27)

#Troyanas

troades_texto <- read_lines("corpus/troades.txt",
                            skip=33)

#Hércules en el Eta

hercules_eta <- read_lines("corpus/hercOet.txt",
                          skip=30)

#Octavia

octavia_texto <- read_lines("corpus/octavia.txt",
                      skip=27)


x= stylo()

distancia<-as.data.frame(x$distance.table)


