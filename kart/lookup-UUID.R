## Find the download URLs for a given UUID from Geonorge's Atom feed

find_geonorge_urls <- function(uuid) {
  # Build Atom feed URL pattern from UUID metadata page
  base <- "http://nedlasting.geonorge.no/geonorge/ATOM-feeds/"

  # Read the metadata API
  meta_url <- paste0("https://kartkatalog.geonorge.no/api/getdata/", uuid)

  # Parse the known Atom feed directly using xml2
  # For kommuner 2024 (cbb37488):
  atom_url <- "http://nedlasting.geonorge.no/geonorge/ATOM-feeds/AdministrativeEnheterKommuner2024_AtomFeedGML.xml"

  feed <- xml2::read_xml(atom_url)
  ns   <- xml2::xml_ns(feed)
  hrefs <- xml2::xml_attr(
    xml2::xml_find_all(feed, ".//d1:link", ns), "href"
  )
  urls <- hrefs[grepl("\\.zip$", hrefs)]

  # Print nicely
  dt <- data.table(
    crs   = regmatches(urls, regexpr("\\d{4,5}(?=_Kommuner)", urls, perl=TRUE)),
    region = regmatches(urls, regexpr("(?<=Norge_|Oslo_|Rogaland_|Vestland_)\\w+(?=_Kommuner)",
                                       urls, perl=TRUE)),
    url   = urls
  )
  print(dt)
  invisible(urls)
}

# Use it:
urls <- find_geonorge_urls("cbb37488-12a0-4c56-9322-0f03ff62f046")
# Pick the one you want, e.g. EPSG:4258 all of Norway:
target <- urls[grepl("0000_Norge_4258", urls)]


# =================================================================
# STEP 1: Download — verified URLs from live Atom feed (2026-02-28)
# UUID cbb37488 = "Administrative enheter kommuner 2024" (GML only)
# =================================================================

# All of Norway, EPSG:4258 (lat/lon, easiest to work with)
url_gml <- "https://nedlasting.geonorge.no/geonorge/Basisdata/Kommuner2024/GML/Basisdata_0000_Norge_4258_Kommuner2024_GML.zip"

tmp_zip <- tempfile(fileext = ".zip")
tmp_dir <- file.path(tempdir(), "kommuner2024")
dir.create(tmp_dir, showWarnings = FALSE)

download.file(url_gml, tmp_zip, mode = "wb")
unzip(tmp_zip, exdir = tmp_dir)

# See what files unpacked
list.files(tmp_dir, recursive = TRUE)
