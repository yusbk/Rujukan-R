## Lager kart med Simple Feature

list.of.packages <- c("leaflet","ggplot2","dplyr","gridExtra","psych","data.table","sf","ggrepel")

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
sapply(list.of.packages, require, character.only = TRUE)

kart_sf = sf::st_read("~/Git-personal/Rujukan-R/norge/NOR_adm1.shp", stringsAsFactors = FALSE)
class(kart_sf)

## plot(kart_sf) #ikke kjør. Denne lages 6 kart

head(kart_sf)

## bytte Åstfold to Østfold
library(dplyr)
kart_sf <- kart_sf %>%
  mutate(NAME_1, fylke=ifelse(ID_1==1, 'Østfold', NAME_1))

## Hvis det er behov å konvertere sf til data.frame
## bruk st_geometry
kart_df <- kart_sf
class(kart_df) #class sf og data.frame
sf::st_geometry(kart_df) <- NULL
class(kart_df) #class data.frame


## Simple kart
library(ggplot2)
g1 <- ggplot(kart_sf, aes(fill=fylke)) + geom_sf()
g1

## Bruk av forskjellige Coordinate Reference System
## F.eks 4326 og 2154

## Discrete eller dichotomous data
g2 <- ggplot(kart_sf) +
  aes(fill=fylke) +
  scale_fill_viridis_d() + #viridis d for discrete
  geom_sf() +
  coord_sf(crs = 4326, datum = sf::st_crs(4326)) +
  ggtitle("Fylker i Norge") +
  theme(title = element_text(size = 16))

g2

## Contineous data
g3 <- ggplot(kart_sf) +
  aes(fill=ID_1) +
  scale_fill_viridis_c() + #viridis c for contineous
  geom_sf() +
  coord_sf(crs = 2154, datum = sf::st_crs(2154)) +
  ggtitle("Fylker i Norge") +
  theme(title = element_text(size = 16))

g3


## add points
kart_centroid <- kart_sf %>% sf::st_centroid() #create point
kart_centroid #her vises geometry som POINT

g2 + geom_sf(data = kart_centroid, aes(fill = fylke), colour = "red")

## get coordinate for fylke dvs. X og Y for å lage text
## dvs. verdi i geometry for lat og long delest til X og Y
## for at man kan brukes til å defenere i geom_aes
fylkeco <- cbind(kart_centroid, st_coordinates(st_centroid(kart_sf)))
fylkeco #her ser man X og Y tilsvarer verdi i geometry

## kart med fylkesnavn
g2 +
  geom_text(data = fylkeco, aes(X, Y, label=fylke), size=3) +
  coord_sf()


## For at tekstene ikke legges oppe hverandre, kan bruke ggrepel pakke
library(ggrepel)
utNavn <- c(12, 2, 19, 1) #velge fykle Oslo, Akerhus, Østfold og Vestfold

g2 +
  geom_text_repel(data = subset(fylkeco, ID_1 %in% utNavn), aes(X, Y, label=fylke), size=3,
                  nudge_x = 6, #spesifere hvor tekst starter på x-aksen
                  direction = "y", #spesifisere at tekst fordeles langs y-aksen
                  force = 20) + #forstår ikke hvordan force funker
  geom_point(data = subset(fylkeco, ID_1 %in% utNavn), aes(X, Y), color = "red", size = 1) +
  coord_sf()


# Viser bare fylke Akerhus og Oslo
# if 'expand = TRUE' to expand the limit by a fraction so data and axes don't overlap
g3 +
  geom_text(data = fylkeco, aes(X, Y, label=fylke), size=5) +
  coord_sf(xlim = c(9.5, 12.5), ylim = c(59, 61), expand = FALSE)  #exactly match the limits provided

g2 +
  geom_text(data = fylkeco, aes(X, Y, label=fylke), size=5) +
  coord_sf(xlim = c(9.5, 12.5), ylim = c(58.8, 60.7), expand = TRUE)  #tilpasse størrelse hvis overlapper



fylkeco
