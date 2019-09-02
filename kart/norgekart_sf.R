## Lager kart med Simple Feature

list.of.packages <- c("leaflet","ggplot2","dplyr","gridExtra","psych","data.table","sf","ggrepel")

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "https://cloud.r-project.org/")
sapply(list.of.packages, require, character.only = TRUE)

#kart fylke
kart_sf = sf::st_read("~/Git-personal/Rujukan-R/norge/NOR_adm1.shp", stringsAsFactors = FALSE)
## kart kommune
kart_sf2 = sf::st_read("~/Git-personal/Rujukan-R/norge/NOR_adm2.shp", stringsAsFactors = FALSE)
class(kart_sf)

swed_sf = sf::st_read("~/Git-personal/kart/sweden/se_10km.shp", stringsAsFactors = FALSE)
plot(st_geometry(swed_sf))

## plot(kart_sf) #ikke kjør. Denne lages 6 kart
plot(st_geometry(kart_sf)) #bruk denne for å plotte et kart
plot(st_geometry(kart_sf2)) #bruk denne for å plotte et kart på kommune

## Se inhold og struktur
st_geometry(kart_sf)
head(kart_sf)
st_geometry(kart_sf2)
kart_sf2
dim(kart_sf2)

## bytte Åstfold to Østfold
library(dplyr)
kart_sf <- kart_sf %>%
  mutate(NAME_1, fylke=ifelse(ID_1==1, 'Østfold', NAME_1))

## sør- og nord Trøndelag slår sammen siden jan 2018
kart_sf <- kart_sf %>%
  mutate(ID_1, fID = ifelse(ID_1 %in% c(9, 14), 50, ID_1))

kart_sf <- kart_sf %>%
  mutate(fylke, region=ifelse(fID==50, 'Trøndelag', fylke))


## saveRDS(kart_sf, "kartNorge_sf.RDS")



kart_sf %>%
  select(fylke, ID_1)

unique(kart_sf$fID)
unique(kart_sf$fylke)
unique(kart_sf$region)


idfylke <- group_by(kart_sf, )

str(kart_sf)
nrow(kart_sf)

kart_sf$fylke

hso <- c("Østfold", "Akershus", "Aust-Agder", "Buskerud", "Hedmark", "Oppland", "Oslo", "Telemark", "Vest-Agder", "Vestfold")
hsv <- c("Hordaland", "Rogaland", "Sogn og Fjordane")
hsm <- c("Møre og Romsdal", "Trøndelag", "Trøndelag")
hsn <- c("Finnmark", "Nordland", "Troms")

hso1 <- c()


kart_sf <- kart_sf %>%
  mutate(fylke, helsereg = ifelse(fylke %in% hso, 1, ifelse(fylke %in% hsv, 2, ifelse(fylke %in% hsm, 3, 4))))

## dekningsgrad BDR
kart_sf <- kart_sf %>%
  mutate(helsereg, helsenavn =
                     ifelse(fylke == 1, "Helse Sør-Øst",
                       ifelse(fylke == 2, "Helse Vest",
                         ifelse(fylke == 3, "Helse Midt", "Helse Nord")))) %>%
  mutate(helsereg, dekning =
                     ifelse(fylke == 1, 99,
                       ifelse(fylke == 2, 98,
                         ifelse(fylke == 3, 98, 97))))

library(plotly)
## tooltips ved hoving
plot_ly(
  kart_sf,
  split = ~fylke, #for at hoveron blir categorisert riktig så må bruke 'Split'
  color = ~helsereg,
    text = ~paste("Dekningsgrad ", dekning),
  hoverinfo = "text",
  hoveron = "fill" #brukes for å vise utvalgte tooltips annen enn district
)

kart_sf




## Hvis det er behov å konvertere sf til data.frame
## bruk st_geometry
kart_df <- kart_sf
class(kart_df) #class sf og data.frame
sf::st_geometry(kart_df) <- NULL
class(kart_df) #class data.frame
str(bodo)

## Simple kart
library(ggplot2)
g1 <- ggplot(kart_sf, aes(fill=as.factor(helsereg))) + geom_sf()
g1 + geom_point(data = bodo, mapping = aes(lon, lan)) + coord_sf()
g1 + theme(legend.position = 'none')
g1

bodo  <- data.frame(navn = "Bodø", lan = 67.2804, lon = 14.4049)
ggplot(kart_sf) + geom_sf() +
  geom_point(data = bodo, mapping = aes(lon, lan), size = 4, shape = 20, color = "red") +
  geom_text(data = bodo, mapping = aes(lon, lan, label = navn), nudge_x = -2) +
  coord_sf()

bodo
plotg1 <- plotly::ggplotly(g1)


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
utNavn <- c(12, 2, 1) #velge fykle Oslo, Akerhus, Østfold og Vestfold
vest <- 19

g2 +
  geom_text_repel(data = subset(fylkeco, ID_1 %in% utNavn), aes(X, Y, label=fylke), size=3,
                  nudge_x = c(2, 3, 4), #spesifere hvor tekst starter på x-aksen. 2 for Østfold mens 4 for Oslo dvs. reverse som på utNavn rekkefølge
                  direction = "y", #spesifisere at tekst fordeles langs y-aksen
                  force = 2) + #forstår ikke hvordan force funker
  geom_text_repel(data = subset(fylkeco, ID_1 == 19), aes(X, Y, label = fylke), size = 3,
    nudge_y = -1, #direction downwards 1 y-scale
    direction = "x") +
  geom_point(data = subset(fylkeco, ID_1 %in% c(utNavn, 19)), aes(X, Y), color = "red", size = 1) +
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


## plotte utvalgte fylke med base graphics
valgFylke <- subset(kart_sf, ID_1 %in% c(12, 10, 14, 7))
plot(st_geometry(kart_sf))
plot(st_geometry(valgFylke), add = TRUE, col = "red")


##############################
## plotly style
library(plotly)
library(ggplot2)

packageVersion("plotly")


nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

nc
class(nc)

p <- plot_ly(nc)
p

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = api_create(p, filename="sf-1")
chart_link

p <- plot_geo(nc)
p
# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = api_create(p, filename="sf-geo")
chart_link

library(plotly)
library(sf)

nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

p <- plot_mapbox(nc, split=~NAME) %>%
  layout(
    mapbox = list(
      zoom = 6
    )
  )

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = api_create(p, filename="sf-mapbox")
chart_link

## 3D testVirtual
demo("sf-plotly-3D-globe", package = "plotly")

## litt mer avansert
## #################
# load trails data (an sf object bundled with the mapview package)
# install.packages('mapview')
data(franconia, package = "mapview")
franconia

# Compare this result with: `plot_ly(franconia, split = ~NAME_ASCI, color = I("black"))`
plot_ly(franconia, split = ~NAME_ASCI)
plot_ly(franconia, split = ~NAME_ASCI, color = I("black"))#alt NAME_ASCI blir svart

plot_ly(
  franconia,
  split = ~NUTS_ID, #trenger fordi color 'SHAPE_AREA' er nummerisk for at det ikke bare bli et type farge.
  color = ~SHAPE_AREA,
  alpha = 1,
  showlegend = FALSE
)

## tooltips ved hoving
plot_ly(
  franconia,
  split = ~NUTS_ID, #for at hoveron blir categorisert riktig så må bruke 'Split'
  color = ~district,
  stroke = I("black"),
  text = ~paste(NAME_ASCI, "\n is in", district),
  hoverinfo = "text",
  hoveron = "fill" #brukes for å vise utvalgte tooltips annen enn district
)

## #####################
## interaktiv Norge
## ###################

kart_sf
nok1 <- plot_ly(kart_sf, split = ~fylke)
nok1

nok2 <- plot_geo(kart_sf)
nok2

nok3 <- plot_mapbox(kart_sf, split=~fylke) %>%
  layout(
    mapbox = list(
      zoom = 6
    )
  )

nok3


cols <- c("#89C5DA", "#DA5724", "#74D944", "#CE50CA", "#3F4921", "#C0717C", "#CBD588", "#5F7FC7", "#673770", "#D3D93E", "#38333E", "#508578", "#D7C1B1", "#689030", "#AD6F3B", "#CD9BCD", "#D14285", "#6DDE88", "#652926", "#7FDCC0", "#C84248", "#8569D5", "#5E738F", "#D1A33D", "#8A7C64", "#599861")

plot_ly(kart_sf, color = ~fylke, colors = cols)

## Check json info
nok1
plotly_json(nok1)
schema()

plotly_json(plotg1)
