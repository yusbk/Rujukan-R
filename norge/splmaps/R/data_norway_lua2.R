# ***************************** #
# map default ----

## data.table ----
#' Maps of Norwegian municipalities in data.table format
#'
#' We conveniently package map datasets for Norwegian municipalities
#' (taken from Geonorge) that can be used in ggplot2 without needing any geo
#' libraries. This data is licensed under Creative Commons BY 4.0 (CC BY 4.0).
#'
#' Borders for 2020 and 2019 are provided.
#'
#' @format
#' \describe{
#' \item{long}{Location code.}
#' \item{lat}{Location name.}
#' \item{order}{The order that this line should be plotted in.}
#' \item{group}{Needs to be used as 'group' aesthetic in ggplot2.}
#' \item{location_code}{Location code (municipality code).}
#' }
#' @source \url{https://kartkatalog.geonorge.no/metadata/norske-fylker-og-kommuner-illustrasjonsdata-2020-(klippet-etter-kyst)/7408853f-eb7d-48dd-bb6c-80c7e80f7392}
#' @source \url{https://kartkatalog.geonorge.no/metadata/uuid/cb02ab77-d3e6-4500-8a92-ea67367e7734}
#' @examples
#' # 2020 borders
#' library(ggplot2)
#' q <- ggplot(mapping = aes(x = long, y = lat))
#' q <- q + geom_polygon(
#'   data = splmaps::nor_lau2_map_b2020_default_dt,
#'   mapping = aes(group = group),
#'   color = "black",
#'   fill = "white",
#'   size = 0.2
#' )
#' q <- q + theme_void()
#' q <- q + coord_quickmap()
#' q
#'
#' # 2019 borders
#' library(ggplot2)
#' q <- ggplot(mapping = aes(x = long, y = lat))
#' q <- q + geom_polygon(
#'   data = splmaps::nor_lau2_map_b2019_default_dt,
#'   mapping = aes(group = group),
#'   color = "black",
#'   fill = "white",
#'   size = 0.2
#' )
#' q <- q + theme_void()
#' q <- q + coord_quickmap()
#' q
#' @name nor_lau2_map_bxxxx_default_dt
"nor_lau2_map_b2020_default_dt"

#' @rdname nor_lau2_map_bxxxx_default_dt
"nor_lau2_map_b2019_default_dt"

#' @rdname nor_lau2_map_bxxxx_default_dt
"nor_lau2_position_geolabels_b2020_default_dt"

#' @rdname nor_lau2_map_bxxxx_default_dt
"nor_lau2_position_geolabels_b2019_default_dt"

## sf format ----
#' Maps of Norwegian municipalities in sf format
#'
#' This data is licensed under Creative Commons BY 4.0 (CC BY 4.0).
#'
#' Borders for 2020 and 2019 are provided.
#'
#' @format
#' \describe{
#' \item{geometry}{Multipolygon}
#' \item{location_code}{Location code (municipality code).}
#' }
#' @source \url{https://kartkatalog.geonorge.no/metadata/norske-fylker-og-kommuner-illustrasjonsdata-2020-(klippet-etter-kyst)/7408853f-eb7d-48dd-bb6c-80c7e80f7392}
#' @source \url{https://kartkatalog.geonorge.no/metadata/uuid/cb02ab77-d3e6-4500-8a92-ea67367e7734}
#' @name nor_lau2_map_bxxxx_default_sf
"nor_lau2_map_b2020_default_sf"

#' @rdname nor_lau2_map_bxxxx_default_sf
"nor_lau2_map_b2019_default_sf"

# ***************************** #
# map insert oslo ----

#' Maps of Norwegian municipalities with an insert for Oslo in data.table format
#'
#' We conveniently package map datasets for Norwegian municipalities
#' (taken from Geonorge) that can be used in ggplot2 without needing any geo
#' libraries. This data is licensed under Creative Commons BY 4.0 (CC BY 4.0).
#'
#' Borders for 2020 and 2019 are provided.
#'
#' @format
#' \describe{
#' \item{long}{Location code.}
#' \item{lat}{Location name.}
#' \item{order}{The order that this line should be plotted in.}
#' \item{group}{Needs to be used as 'group' aesthetic in ggplot2.}
#' \item{location_code}{Location code (county code).}
#' }
#' @source \url{https://kartkatalog.geonorge.no/metadata/norske-fylker-og-kommuner-illustrasjonsdata-2020-(klippet-etter-kyst)/7408853f-eb7d-48dd-bb6c-80c7e80f7392}
#' @source \url{https://kartkatalog.geonorge.no/metadata/uuid/cb02ab77-d3e6-4500-8a92-ea67367e7734}
#' @examples
#' # 2020 borders
#' library(ggplot2)
#' q <- ggplot(mapping = aes(x = long, y = lat))
#' q <- q + geom_polygon(
#'   data = splmaps::nor_lau2_map_b2020_insert_oslo_dt,
#'   mapping = aes(group = group),
#'   color = "black",
#'   fill = "white",
#'   size = 0.2
#' )
#' q <- q + annotate(
#'   "text",
#'   x = splmaps::nor_xxx_position_title_insert_oslo_b2020_insert_oslo_dt$long,
#'   y = splmaps::nor_xxx_position_title_insert_oslo_b2020_insert_oslo_dt$lat,
#'   label = "Oslo"
#' )
#' q <- q + theme_void()
#' q <- q + coord_quickmap()
#' q
#'
#' # 2019 borders
#' library(ggplot2)
#' q <- ggplot(mapping = aes(x = long, y = lat))
#' q <- q + geom_polygon(
#'   data = splmaps::nor_lau2_map_b2019_insert_oslo_dt,
#'   mapping = aes(group = group),
#'   color = "black",
#'   fill = "white",
#'   size = 0.2
#' )
#' q <- q + annotate(
#'   "text",
#'   x = splmaps::nor_xxx_position_title_insert_oslo_b2019_insert_oslo_dt$long,
#'   y = splmaps::nor_xxx_position_title_insert_oslo_b2019_insert_oslo_dt$lat,
#'   label = "Oslo"
#' )
#' q <- q + theme_void()
#' q <- q + coord_quickmap()
#' q
#' @name nor_lau2_map_bxxxx_insert_oslo_dt
"nor_lau2_map_b2020_insert_oslo_dt"

#' @rdname nor_lau2_map_bxxxx_insert_oslo_dt
"nor_lau2_map_b2019_insert_oslo_dt"

#' @rdname nor_lau2_map_bxxxx_insert_oslo_dt
"nor_lau2_position_geolabels_b2020_insert_oslo_dt"

#' @rdname nor_lau2_map_bxxxx_insert_oslo_dt
"nor_lau2_position_geolabels_b2019_insert_oslo_dt"

# ***************************** #
# map split ----

#' Split map of Norwegian municipalities in data.table format
#'
#' We conveniently package map datasets for Norwegian municipalities
#' (taken from Geonorge) that can be used in ggplot2 without needing any geo
#' libraries. This data is licensed under Creative Commons BY 4.0 (CC BY 4.0).
#'
#' Borders for 2020 are provided.
#'
#' @format
#' \describe{
#' \item{long}{Location code.}
#' \item{lat}{Location name.}
#' \item{order}{The order that this line should be plotted in.}
#' \item{group}{Needs to be used as 'group' aesthetic in ggplot2.}
#' \item{location_code}{Location code (municipality code).}
#' }
#' @source \url{https://kartkatalog.geonorge.no/metadata/norske-fylker-og-kommuner-illustrasjonsdata-2020-(klippet-etter-kyst)/7408853f-eb7d-48dd-bb6c-80c7e80f7392}
#' @examples
#' library(ggplot2)
#' q <- ggplot(mapping = aes(x = long, y = lat))
#' q <- q + geom_polygon(
#'   data = splmaps::nor_lau2_map_b2020_split_dt,
#'   mapping = aes(group = group),
#'   color = "black",
#'   fill = "white",
#'   size = 0.2
#' )
#' q <- q + theme_void()
#' q <- q + coord_quickmap()
#' q
#' @name nor_lau2_map_bxxxx_split_dt
"nor_lau2_map_b2020_split_dt"




