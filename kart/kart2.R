list.of.packages <- c("cowplot", "googleway", "ggplot2", "ggrepel",
"ggspatial", "libwgeom", "sf", "rnaturalearth", "rnaturalearthdata")

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("ggplot2")
theme_set(theme_bw())
library("sf")

library("rnaturalearth")
library("rnaturalearthdata")

world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
class(world)

ggplot(data = world) +
    geom_sf()

library("ggspatial")
ggplot(data = world) +
    geom_sf() +
    annotation_scale(location = "bl", width_hint = 0.5) +
    annotation_north_arrow(location = "bl", which_north = "true",
        pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
        style = north_arrow_fancy_orienteering) +
    coord_sf(xlim = c(-102.15, -74.12), ylim = c(7.65, 33.97))


## Lager navn i kartet
library("sf")
world_points<- st_centroid(world)
world_points <- cbind(world, st_coordinates(st_centroid(world$geometry)))

ggplot(data = world) +
geom_sf() +
geom_text(data= world_points,aes(x=X, y=Y, label=name),
    color = "darkblue", fontface = "bold", check_overlap = FALSE) +
annotate(geom = "text", x = -90, y = 26, label = "Gulf of Mexico",
    fontface = "italic", color = "grey22", size = 6) +
coord_sf(xlim = c(-102.15, -74.12), ylim = c(7.65, 33.97), expand = FALSE)
