## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(splmaps)
library(ggplot2)
library(data.table)
library(magrittr)

## ----fig.height=6, fig.width=6------------------------------------------------
pd <- copy(splmaps::nor_lau2_map_b2020_default_dt)
q <- ggplot()
q <- q + geom_polygon(data = pd, aes( x = long, y = lat, group = group), 
                      color="black", fill="white", size=0.1)
q <- q + theme_void()
q <- q + coord_quickmap()
q <- q + labs(title = "Default layout")
q

