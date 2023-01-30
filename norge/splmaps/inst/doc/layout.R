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

## ----fig.height=6, fig.width=6------------------------------------------------
pd <- copy(splmaps::nor_lau2_map_b2020_split_dt)
q <- ggplot()
q <- q + geom_polygon(data = pd, aes( x = long, y = lat, group = group), 
                      color="black", fill="white", size=0.1)
q <- q + theme_void()
q <- q + coord_quickmap()
q <- q + labs(title = "Split layout")
q

## ----fig.height=6, fig.width=6------------------------------------------------
pd <- copy(splmaps::nor_lau2_map_b2020_insert_oslo_dt)
q <- ggplot()
q <- q + geom_polygon(data = pd, aes( x = long, y = lat, group = group), 
                      color="black", fill="white", size=0.1)

# add title "Oslo"
q <- q + annotate(
  "text", 
  x = splmaps::nor_xxx_position_title_insert_oslo_b2020_insert_oslo_dt$long, 
  y = splmaps::nor_xxx_position_title_insert_oslo_b2020_insert_oslo_dt$lat,
  label = "Oslo"
  )
q <- q + theme_void()
q <- q + coord_quickmap()
q <- q + labs(title = "Insert Oslo layout")
q

## ----fig.height=6, fig.width=6------------------------------------------------
pd <- copy(splmaps::oslo_ward_map_b2020_default_dt)
q <- ggplot()
q <- q + geom_polygon(data = pd, aes(x = long, y = lat, group = group), 
                      color="black", fill="white", size=0.1)
q <- q + theme_void()
q <- q + coord_quickmap()
q <- q + labs(title = "Oslo wards")
q

