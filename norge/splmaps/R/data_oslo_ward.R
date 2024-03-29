## data.table ----

#' Map of Oslo wards (bydeler) in data.table format
#'
#' We conveniently package map datasets for Oslo wards (bydeler)
#' (taken from Oslo municipality) that can be used in ggplot2 without needing any geo
#' libraries. This data is licensed under Creative Commons BY 4.0 (CC BY 4.0).
#'
#' Borders provided for 2020.
#'
#' @format
#' \describe{
#' \item{long}{Location code.}
#' \item{lat}{Location name.}
#' \item{order}{The order that this line should be plotted in.}
#' \item{group}{Needs to be used as 'group' aesthetic in ggplot2.}
#' \item{location_code}{Location code (ward code).}
#' }
#' @examples
#' library(ggplot2)
#' q <- ggplot(mapping = aes(x = long, y = lat))
#' q <- q + geom_polygon(
#'   data = splmaps::oslo_ward_map_b2020_default_dt,
#'   mapping = aes(group = group, fill = location_code),
#'   color = "black",
#'   fill = "white",
#'   size = 0.2
#' )
#' q <- q + geom_label(
#'   data = splmaps::oslo_ward_position_geolabels_b2020_default_dt,
#'   mapping = aes(label = location_code),
#'   color = "red"
#' )
#' q <- q + theme_void()
#' q <- q + coord_quickmap()
#' q
#' @name oslo_ward_map_bxxxx_default_dt
"oslo_ward_map_b2020_default_dt"

#' @rdname oslo_ward_map_bxxxx_default_dt
"oslo_ward_position_geolabels_b2020_default_dt"

## sf format ----

#' Map of Oslo wards (bydeler) in sf format
#'
#' This data is licensed under Creative Commons BY 4.0 (CC BY 4.0).
#'
#' Borders provided for 2020.
#'
#' @format
#' \describe{
#' \item{geometry}{Multipolygon}
#' \item{location_code}{Location code (municipality code).}
#' }
#' @name oslo_ward_map_bxxxx_default_sf
"oslo_ward_map_b2020_default_sf"
