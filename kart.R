list.of.packages <- c("maps","mapdata","maptools","rgdal","ggmap","leaflet","tigris",
                      "sp","ggplot2","plyr","animation","gridExtra","psych","rstudioapi",
                      "data.table")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(geojsonR)

nokart <- geojsonR::FROM_GeoJson(url_file_string = "~/Documents/kart/Basisdata_0000_Norge_25833_Kommuner_GEOJSON.geojson")

## --------
library(maps)
library(mapdata)
library(maptools)
library(rgdal)
library(ggmap)
library(leaflet)
library(tigris)
library(sp)
library(ggplot2)
library(plyr)
library(animation)
library(gridExtra)
library(psych)
library(rstudioapi)
library(data.table)

## Sjekk forskjellige driver som kan brukes
ogrDrivers()$name

## Bruk av GeoJSON fil
## Sjekk layer
ogrListLayers(dsn = "~/Documents/kart/Basisdata_0000_Norge_25833_Kommuner_GEOJSON.geojson")
norgeKart <- rgdal::readOGR(dsn = "~/Documents/kart/Basisdata_0000_Norge_25833_Kommuner_GEOJSON.geojson",
  layer = "administrative_enheter.avtaltavgrensningslinje")

plot(norgeKart)


## Bruk av Shapefile
library(rgdal)
ogrListLayers(dsn = "~/Documents/kart/norge")
norgeSF <- rgdal::readOGR(dsn = "~/Documents/kart/norge", layer = "NOR_adm1", encoding = "UTF-8")
plot(norgeSF)

library(broom)
library(rgeos)
library(maptools)
str(norgeSF@data)
norgeDF <- broom::tidy(norgeSF, region = "NAME_1")
head(norgeDF)

## hvis region ikke funker for 'tidy' er fordi pakke maptools, rgeos, eller broom ikke er installert.
## Hvis man ikke kan installere pakke 'rgeos' kan være at man må først installere
## sudo apt-get install libgeos++-dev

fylke <- data.frame(norgeSF@data$NAME_1)
names(fylke) <- "fylke"
fylke
fylke$id <- seq(0, nrow(fylke) - 1)

library(data.table)
norgeDT <- as.data.table(norgeDF)norgeDT[, unique(id)]

library(ggplot2)
ggplot(data = norgeDT, aes(long, lat, map_id = id)) +
  geom_map(aes(map_id = id, fill = as.factor(id)), map = norgeDT) +
  coord_map()


fylkeid <- norgeDT[, .(id = unique(id))]
fylkeid[, tall := sample(30:95, 19, replace = T)]

norgeDD <- fylkeid[norgeDT, on = "id"]
dim(norgeDD)

ggplot(data = norgeDD, aes(long, lat, map_id = id)) +
  geom_map(data = norgeDD, aes(map_id = id, fill = tall), map = norgeDD) +
  coord_map()


ggplot(data = norgeDD, aes(long, lat, map_id = id)) +
  geom_map(data = norgeDD, aes(map_id = id, fill = as.factor(tall)), map = norgeDD) +
  coord_map()

##### ----------
## SF format

library(sf)
norgesf <- sf::st_read("~/Git-personal/Rujukan-R/norge/NOR_adm1.shp")
class(norgesf)

dim(norgesf)

library(ggplot2)
ggplot(data = norgesf) + geom_sf()

## text
norge_txt <- st_centroid(norgesf) #convert til point spatial
norge_txt <- cbind(norgesf, st_coordinates(st_centroid(norgesf$geometry)))

ggplot(data = norgesf) +
  geom_sf() +
  geom_text(data = norge_txt, aes(x = X, y = Y, label = NAME_1),
    fontface = "bold", check_overlap = FALSE) +
  coord_sf()

library("ggrepel")
ggplot(data = norgesf) +
  geom_sf() +
  geom_text_repel(data = norge_txt, aes(x = X, y = Y, label = NAME_1),
    fontface = "bold") +
  coord_sf()

## eksample repel
geom_text_repel(data = flcities, aes(x = lng, y = lat, label = city),
        fontface = "bold", nudge_x = c(1, -1.5, 2, 2, -1), nudge_y = c(0.25,
            -0.25, 0.5, 0.5, -0.5)) +
