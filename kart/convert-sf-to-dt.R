library(sf)
library(data.table)

## Datakilde: Kommuner i Norge, GeoJSON format, nedlastning.geonorge.no
## https://register.geonorge.no/navnerom/https-data-geonorge-no-sosi-administrativeenheter

### EXAMPLE 1 --------------------------------------

# =================================================================
# Verified GeoJSON URLs — current kommuner (updated 2025-12-10)
# Source: Basisdata/Kommuner (not the 2024 historical version)
# =================================================================

# Pick one CRS:
# EPSG:4258 = ETRS89 lat/lon (nearly identical to WGS84, easiest)
# EPSG:25833 = UTM zone 33N (native Norwegian CRS, most accurate)

url_geojson <- "https://nedlasting.geonorge.no/geonorge/Basisdata/Kommuner/GeoJSON/Basisdata_0000_Norge_4258_Kommuner_GeoJSON.zip"

# =================================================================
# STEP 1: Download + unzip
# =================================================================
tmp_zip <- tempfile(fileext = ".zip")
tmp_dir <- file.path(tempdir(), "kommuner_geojson")
dir.create(tmp_dir, showWarnings = FALSE)

download.file(url_geojson, tmp_zip, mode = "wb")
unzip(tmp_zip, exdir = tmp_dir)

list.files(tmp_dir, recursive = TRUE)   # see what we got

# =================================================================
# STEP 2: List layers + read
# =================================================================
geojson_file <- list.files(tmp_dir,
                            pattern = "\\.geojson$|\\.json$",
                            full.names = TRUE, recursive = TRUE)[1]

# Always check layers first
st_layers(geojson_file)

# Read — GeoJSON typically has one layer, but specify to be safe
kommuner_sf <- st_read(geojson_file)

# Inspect ACTUAL column names (never assume!)
names(kommuner_sf)
head(kommuner_sf)
st_crs(kommuner_sf)

# =================================================================
# STEP 3: Reproject + fix encoding
# =================================================================
kommuner_sf <- st_transform(kommuner_sf, crs = 4326)

# Fix Ã encoding issues if present
names(kommuner_sf) <- iconv(names(kommuner_sf), from = "latin1", to = "UTF-8")

chr_cols <- names(kommuner_sf)[sapply(st_drop_geometry(kommuner_sf), is.character)]
for (col in chr_cols) {
  kommuner_sf[[col]] <- iconv(kommuner_sf[[col]], from = "latin1", to = "UTF-8")
}

# Check real column names now
print(names(kommuner_sf))

# =================================================================
# STEP 4: sf → data.table
# =================================================================
# Attributes only
attrs_dt <- as.data.table(st_drop_geometry(kommuner_sf))

# Find the real kommune number + name columns
id_col   <- grep("nummer|lokalId|id",  names(attrs_dt), value = TRUE, ignore.case = TRUE)[1]
navn_col <- grep("navn|name",           names(attrs_dt), value = TRUE, ignore.case = TRUE)[1]
cat("ID column:  ", id_col, "\n")
cat("Name column:", navn_col, "\n")

# Rename to friendly names for downstream use
kommuner_dt <- as.data.table(kommuner_sf)
setnames(kommuner_dt, old = c(id_col, navn_col),
                      new = c("kommunenummer", "kommunenavn"))

kommuner_dt[, .(kommunenummer, kommunenavn)] |> head(10)

# =================================================================
# STEP 5: Explode to lon/lat for ggplot2
# =================================================================
coords_dt <- as.data.table(st_coordinates(kommuner_sf))
setnames(coords_dt, c("lon", "lat", "point_id", "ring_id", "polygon_idx"))

attrs_renamed <- copy(attrs_dt)
setnames(attrs_renamed, old = c(id_col, navn_col),
                        new = c("kommunenummer", "kommunenavn"))
attrs_renamed[, polygon_idx := .I]

plot_dt <- coords_dt[attrs_renamed, on = "polygon_idx"]

# Highlight Oslo
plot_dt[, is_oslo := kommunenummer == "0301"]

library(ggplot2)
ggplot(plot_dt,
       aes(lon, lat,
           group = interaction(polygon_idx, ring_id),
           fill  = is_oslo)) +
  geom_polygon(color = "white", linewidth = 0.05) +
  coord_sf() +
  scale_fill_manual(values = c("grey75", "tomato"),
                    labels = c("Other", "Oslo")) +
  theme_minimal() +
  labs(title = "Norske kommuner", fill = NULL)




### EXAMPLE 2 --------------------------------------

# =============================================================
# CORRECT URLs (verified from Atom feed, updated 2025-12-10)
# =============================================================

# Option 1: All of Norway, EPSG:25833 (UTM33 — native CRS)
url_utm33 <- "https://nedlasting.geonorge.no/geonorge/Basisdata/Kommuner/GeoJSON/Basisdata_0000_Norge_25833_Kommuner_GeoJSON.zip"

# Option 2: All of Norway, EPSG:4258 (ETRS89 lat/lon — closest to WGS84)
url_etrs89 <- "https://nedlasting.geonorge.no/geonorge/Basisdata/Kommuner/GeoJSON/Basisdata_0000_Norge_4258_Kommuner_GeoJSON.zip"

# Option 3: Only Oslo fylke, EPSG:4258
url_oslo <- "https://nedlasting.geonorge.no/geonorge/Basisdata/Kommuner/GeoJSON/Basisdata_03_Oslo_4258_Kommuner_GeoJSON.zip"

# =============================================================
# STEP 1: Download and unzip
# =============================================================
tmp_zip <- tempfile(fileext = ".zip")
tmp_dir <- file.path(tempdir(), "kommuner")
dir.create(tmp_dir, showWarnings = FALSE)

download.file(url_etrs89, tmp_zip, mode = "wb")
unzip(tmp_zip, exdir = tmp_dir)

# See what files we got
list.files(tmp_dir, recursive = TRUE)

# =============================================================
# STEP 2: Read into sf
# =============================================================
geojson_file <- list.files(tmp_dir, pattern = "\\.geojson$|\\.json$",
                            full.names = TRUE, recursive = TRUE)[1]

kommuner_sf <- st_read(geojson_file)

# Inspect
print(st_crs(kommuner_sf))   # EPSG:4258
print(names(kommuner_sf))
print(nrow(kommuner_sf))     # ~356 kommuner

# Reproject to WGS84 (4326) — nearly identical to 4258 but standard
kommuner_sf <- st_transform(kommuner_sf, crs = 4326)

# =============================================================
# STEP 3: sf → data.table (two methods)
# =============================================================

# -- Method A: Keep geometry as list-column (attribute work) --
kommuner_dt <- as.data.table(kommuner_sf)
names(kommuner_dt)

# Check what objtype values exist — this tells us what features are in the data
unique(kommuner_dt$objtype)

# Also check the lokalId — it may contain the kommune number
head(kommuner_dt[, .(objtype,
                     identifikasjon.Identifikasjon.lokalId,
                     identifikasjon.Identifikasjon.navnerom)])

## kommuner_dt[, .(kommunenummer, kommunenavn)]   # fast attribute queries

# -- Method B: Explode to lon/lat rows (for plotting) ---------
coords_dt <- as.data.table(st_coordinates(kommuner_sf))
# st_coordinates returns: X=lon, Y=lat, L1=point, L2=ring, L3=polygon row index
setnames(coords_dt, c("lon", "lat", "point_id", "ring_id", "polygon_idx"))

attrs_dt <- as.data.table(st_drop_geometry(kommuner_sf))
attrs_dt[, polygon_idx := .I]   # .I = row number, matches L3

plot_dt <- coords_dt[attrs_dt, on = "polygon_idx"]

# Plot all kommuner
library(ggplot2)
ggplot(plot_dt, aes(lon, lat,
       group = interaction(polygon_idx, ring_id))) +
  geom_polygon(fill = "steelblue", color = "white", linewidth = 0.05) +
  coord_sf() +
  theme_minimal() +
  labs(title = "Norske kommuner (2025)")
