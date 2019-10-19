## Chapter 2 execises

install.packages(c('sf', 'raster'))
install.packages(c('remotes', 'spData'))
remotes::install_github("Nowosad/spDataLarge")

## Start
library(spData)
library(spDataLarge)

## Sjekk hvilke vignette som er tilgjengelig
vignette(package = 'sf')
vignette('sf1')
