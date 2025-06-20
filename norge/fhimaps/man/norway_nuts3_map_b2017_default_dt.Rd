% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_norway_map.R
\docType{data}
\name{norway_nuts3_map_b2017_default_dt}
\alias{norway_nuts3_map_b2017_default_dt}
\alias{norway_nuts3_position_geolabels_b2017_default_dt}
\title{Map of Norwegian counties (2017 borders) in data.table format}
\format{
\describe{
\item{long}{Location code.}
\item{lat}{Location name.}
\item{order}{The order that this line should be plotted in.}
\item{group}{Needs to be used as 'group' aesthetic in ggplot2.}
\item{location_code}{Location code (county code).}
}

An object of class \code{data.table} (inherits from \code{data.frame}) with 19 rows and 3 columns.
}
\source{
\url{https://kartkatalog.geonorge.no/metadata/uuid/cb02ab77-d3e6-4500-8a92-ea67367e7734}
}
\usage{
norway_nuts3_map_b2017_default_dt

norway_nuts3_position_geolabels_b2017_default_dt
}
\description{
We conveniently package map datasets for Norwegian county
(taken from Geonorge) that can be used in ggplot2 without needing any geo
libraries. This data is licensed under Creative Commons 0.
}
\examples{
library(ggplot2)
q <- ggplot(mapping = aes(x = long, y = lat))
q <- q + geom_polygon(
  data = fhimaps::norway_nuts3_map_b2017_default_dt,
  mapping = aes(group = group, fill = location_code),
  color = "black",
  fill = "white",
  size = 0.2
 )
q <- q + geom_label(
  data = fhimaps::norway_nuts3_position_geolabels_b2017_default_dt,
  mapping = aes(label = location_code),
  color = "red"
)
q <- q + theme_void()
q <- q + coord_quickmap()
q
}
\keyword{datasets}
