## NOrsk kart

# Lager mappe
rm(list=ls())

library(rgdal) #for spatial data; sp package will also be loaded
library(rgeos)

library(ggplot2)
library(ggmap)

library(raster) #for metadata/attributes - vectors or rasters

hovedDir <- "P:\\R_coder\\R_map"

# Zip fil
#  filSti <- file.path(hovedDir, "NOR_adm.zip", fsep = "\\")

# lage mappe
# dir.create(file.path(hovedDir, "norskkart", fsep = "\\"))

folderDir <- paste(hovedDir, "norskkart", sep = "\\")

## unzip
# utils::unzip(filSti, exdir = folderDir)

shp <- rgdal::readOGR(dsn = "P:\\R_coder\\R_map\\norskkart", "NOR_adm1", stringsAsFactors = F, encoding = "UTF-8")
shpcsv <- read.csv("P:\\R_coder\\R_map\\norskkart\\NOR_adm1.csv", encoding = "UTF-8")
shpsf <- sf::st_read("P:\\R_coder\\R_map\\norskkart\\NOR_adm1.csv")

class(shp)
str(as(shp[,2:5], "Spatial"), max.level = 5)
names(shp@data)
class(shpcsv)
names(shpcsv)



plot(shp) #verifiserer filen funker

names(shp)
shp@data
head(shp)
rgdal::ogrListLayers("P:\\R_coder\\R_map\\norskkart\\NOR_adm1.shp")

class(shp)
raster::crs(shp) #coordinate reference system
raster::extent(shp) #extent of shapefile

summary(shp@data) #bare dataene
summary(shp) #hele

## option 1
kart <- ggplot() + geom_polygon(data = shp_df,
                                aes(x=long, y = lat, group = group, fill=id), color = "black")
x11()
kart + theme_void()
dev.off()


## konvertere til data.frame
library(dplyr)
shp@data <- shp@data %>% mutate(id = row.names(.))
shp_df <- broom::tidy(shp, region = "id")
shp_df <- shp_df %>% left_join(shp@data, by = c("id"="id"))
shp_df

ggplot() + geom_polygon(data = shp_df,
                        aes(x=long, y = lat, group = group, fill=NAME_1), color = "black")


## option 2
x11()
plot(shp, main = "Kart av Norge")
dev.off()


#######################
## get coordinate

library(geonames)
cities <- c("Oslo", "Trondheim", "Bergen")

# conveninence function to look up and format results  
GNsearchAF <- function(x) {  
  res <- GNsearch(name=x, country="NO")  
  return(res[1, ])  
}

# loop over city names and reformat  
GNresult <- sapply(cities, GNsearchAF)  
GNresult <- do.call("rbind", GNresult)  
GNresult <- cbind(city=row.names(GNresult),  
                  subset(GNresult, select=c("lng", "lat", "adminName1")))  

##############################
## Test Afganistan
library(geonames)

# list of city names (in Afghanistan)  
cities <- c("Gereshk", "Lahkar Gah", "Lashkar Gah", "Marjah", "Nad-e Ali")  
# conveninence function to look up and format results  
GNsearchAF <- function(x) {  
  res <- GNsearch(name=x, country="AF")  
  return(res[1, ])  
}

# loop over city names and reformat  
GNresult <- sapply(cities, GNsearchAF)  
GNresult <- do.call("rbind", GNresult)  
GNresult <- cbind(city=row.names(GNresult),  
                  subset(GNresult, select=c("lng", "lat", "adminName1")))  

### option 2
library(geonames)
library(magrittr)
library(ggplot2)
library(maps)
options(geonamesUsername = "*your_username*")
places <- c("Niederösterreich", "Wien", "Kärnten")
get_coords <- function(name, country, fcode) {
  res <- GNsearch(name_equals = name, country = country, fcode = fcode)  
  out <- data.frame(name = res$toponymName, lat = res$lat, lon = res$lng)
  return(out)  
}

GNresult <- places %>% 
  map(get_coords, country = "AT", fcode = "ADM1") %>% 
  rbindlist()


##########################
# use sf package
##########################

library(sf)

kart_sf <- sf::st_read("P:\\R_coder\\R_map\\norskkart\\NOR_adm1.shp", stringsAsFactors=F) #viktig å beholder string istedenfor factor
class(kart_sf)
head(kart_sf)
str(kart_sf$NAME_1)

# konverterer sf data til data.frame
data_kart_sf <- sf::st_read("P:\\R_coder\\R_map\\norskkart\\NOR_adm1.shp", stringsAsFactors=F)
class(data_kart_sf) #class sf og data.frame
sf::st_geometry(data_kart_sf) <- NULL
class(data_kart_sf) #class data.frame

# bytte Åstfold to Østfold
library(dplyr)
kart_df <- kart_sf %>% 
  mutate(NAME_1, NAME_1=ifelse(ID_1==1, 'Østfold', NAME_1))

kart_df

library(ggplot2)
g1 <- ggplot(kart_df, aes(fill=NAME_1)) + geom_sf()
g1

g2 <- ggplot(kart_df) +
  aes(fill=NAME_1) +
  # scale_fill_viridis_d() + #viridis d for discrete
  geom_sf() +
  coord_sf(crs = 4326, datum = sf::st_crs(4326)) +
  ggtitle("Fylker i Norge") +
  theme(title = element_text(size = 16))

g2

g3 <- ggplot(kart_df) +
  aes(fill=ID_1) +
  scale_fill_viridis_c() + #viridis c for contineous
  geom_sf() +
  coord_sf(crs = 2154, datum = sf::st_crs(2154)) +
  ggtitle("Fylker i Norge") +
  theme(title = element_text(size = 16))

g3

## add points
kart_centroid <- kart_sf %>% sf::st_centroid() #create point
kart_centroid

g2 + geom_sf(data = kart_centroid, aes(fill = NAME_1), colour = "red")


# get coordinate for fylke dvs. X og Y for å lage text
fylkeco <- cbind(kart_centroid, st_coordinates(st_centroid(kart_sf)))
fylkeNy <- fylkeco %>% 
  mutate(NAME_1, fylke=ifelse(ID_1==1, 'Østfold', NAME_1))

############################
## kart med fylkesnavn
g2 + 
  geom_text(data = fylkeNy, aes(X, Y, label=NAME_1), size=3) +
  coord_sf()

library(ggrepel)
utNavn <- c(12, 2, 19, 1)
g2 + 
  geom_text_repel(data = subset(fylkeNy, ID_1 %in% utNavn), aes(X, Y, label=fylke), size=3, 
                   nudge_x = -2 - -7,
                  direction = "y",
                  force = 20) +
  coord_sf()


# Akerhus og Oslo
# if 'expand = TRUE' to expand the limit by a fraction so data and axes don't overlap
g3 + 
  geom_text(data = fylkeco, aes(X, Y, label=NAME_1), size=5) +
  coord_sf(xlim = c(9.5, 12.5), ylim = c(59, 61), expand = FALSE)  #exactly match the limits provided  

g2 + 
  geom_text(data = fylkeco, aes(X, Y, label=NAME_1), size=5) +
  coord_sf(xlim = c(9.5, 12.5), ylim = c(58.8, 60.7), expand = TRUE)  #tilpasse størrelse hvis overlapper
