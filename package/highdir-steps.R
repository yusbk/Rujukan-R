library(devtools)
devtools::load_all()
devtools::test()

devtools::document()
roxygen2::roxygenise(clean = TRUE)

devtools::check()


# Build site
pkgdown::build_site()

pkgdown::build_news()

pkgdown::preview_site()

# Build vignettes
devtools::build()

pkgdown::build_home() #raskere

# Create README markdown from Rmd file
devtools::build_readme()

# Install package locally with vignettes
# to ensure examples and vignettes are run and built correctly
devtools::install(build_vignettes = TRUE)
library(highdir)


## When error or warning after test()
## To clean up all previous Rd files
## Run document() again after running these code:
unlink("man", recursive = TRUE)
dir.create("man")

file.remove("man/hd_data1.Rd")
file.remove("man/hd_data2.Rd")
file.remove("data/hd_data1.rda")
file.remove("data/hd_data2.rda")

devtools::document()
devtools::check()

usethis::use_lifecycle_badge("stable")
usethis::use_cran_badge()

## Rebuild package for install locally
## devtools::install() ## this need to use renv
remotes::install_github("folkehelsestats/highdir")


## Upload to Shiny.io -----------------------------------------------
## Se file c:/Users/ykama/Git-hdir/highdir-app/run-locally.R

# 4) Deploy

source("c:/Users/ykama/OneDrive - Helsedirektoratet/keys/shiny-token.R")
do.call(rsconnect::setAccountInfo, ybkShinyToken)

rsconnect::deployApp(appDir = "~/Git-hdir/highdir-app",
                     appName = "highdir",
                     forceUpdate = TRUE
                     # envManagement = FALSE #
                     ) #skip renv

## To check error ##
rsconnect::showLogs(appName = "highdir", streaming = TRUE)

## Debug locally
options(shiny.fullstacktrace = TRUE)
runApp()


#################################
#### REFERENCES
#################################
## Exclude files or folder ----------
usethis::use_build_ignore("misc") #ignore misc folder
usethis::use_git_ignore("misc")

## add package to DESCRIPTION
usethis::use_package("fs")


usethis::use_vignette("start-use")
usethis::use_vignette("specification")


## install package and build vignettes
devtools::install(build_vignettes = TRUE)
browseVignettes("highdir")
## Build vignettes temprarily
devtools::build_rmd("vignettes/my-vignette.Rmd")
devtools::build_rmd("vignettes/quick-start.Rmd")


## Pkgdown and logo
## ----------------
library(pkgdown)

# Run once to configure package to use pkgdown
usethis::use_pkgdown()

# 1) Add logo and favicons
## Logo must be located automatically in 'man/figures/logo.png'
## when running this code:
usethis::use_logo("misc/highdir6.png")  # copies to man/figures/logo.svg (and png if provided)
## Create favicon will pick the logo file automatically if it's there
pkgdown::build_favicons(overwrite = TRUE)

# Edit _pkgdown.yml:
# template:
#   bootstrap: 5
#   logo: man/figures/logo.png
#   favicon: man/figures/favicon.png

# 2) README header (manually edit README.Rmd):
#   <img src="man/figures/logo.png" align="right" height="160" />

# 3) pkgdown setup
usethis::use_pkgdown()

# Build site
pkgdown::build_site()

# 4) Knit README
devtools::build_readme()

# Add logo in vignettes and articles
# only after you run usethis::use_logo()
knitr::include_graphics(system.file("man", "figures", "logo.png", package = "yourpkg"))

# Eller use relatively to knit inside the repo:
knitr::include_graphics("man/figures/logo.png")


### Github Action ---
### Run Github Action first before codecov
# ensure config in .git path is using
## [remote "origin"]                                  ##
## 	url = git@work:folkehelsestats/highdir        ## change to url = git@github.com:accoutname/repo
## 	fetch = +refs/heads/*:refs/remotes/origin/*   ##

usethis::use_github_action()

## Code coverage ------
## Link the repo to codecov.io first
## After running the use_coverage, you get a url to be paste in README. Click the link to
## register the TOKEN to the Github and to link the two together. Just follow the instruction.
library(usethis)
use_coverage(type = c("codecov"))


## CRAN submission
## -----------------------------------------------------------------------------
devtools::submit_cran()


## Dataset ---------------------------------------------------------------------
# Datasets in data/ must be .rda (created via usethis::use_data()) #

# This saves mydata as data/mydata.rda.
usethis::use_data(mydata, overwrite = TRUE)

usethis::use_data(hd_data1, overwrite = TRUE)
usethis::use_data(hd_data2, overwrite = TRUE)



### Testing
## 1. Test that the class of hd() is correct
hd(alco2, x = "year", y = "adj_mean", group = "kjonn") +
  hd_geom_arearange(ymin = "lower_95CI", ymax = "upper_95CI")

# 1. Does R know what class hd() returns?
x <- hd(alco2, x = "year", y = "adj_mean", group = "kjonn")
class(x)          # must print: [1] "hd"

# 2. Is the + method registered?
existsMethod("+", "hd")          # S4 check (probably FALSE, that's fine)
exists("+.hd", mode = "function") # must be TRUE
getAnywhere("+.hd")               # should show your function

# 3. Is the geom constructor found?
hd_geom_arearange
# should print the function body, not "Error: object not found"

# Is it registered as an S3 method?
methods("+")   # "+.hd" should appear here — if it doesn't, that's the bug

# Workaround to test the logic without fixing NAMESPACE yet:
`+.hd`(
  hd(alco2, x = "year", y = "adj_mean", group = "kjonn"),
  hd_geom_arearange(ymin = "lower_95CI", ymax = "upper_95CI")
)
# If this works, the function is correct — only dispatch is broken



df <- data.frame(
  age  = c("18-24", "25-34", "35-44", "45-54"),
  pct  = c(42, 55, 48, 60),
  lo   = c(37, 50, 43, 55),
  hi   = c(47, 60, 53, 65)
)


hd(df, x = "age", y = "pct")

hd(df, x = "age", y = "pct") +
hd_geom_arearange(ymin = "lo", ymax = "hi") +
hd_opts(title = "Estimate with 95% CI", ylim = c(30, 70))

## Examples
## ---------------------------------------------------------------------------
# Regional health indicator dataset
regions <- data.frame(
  region = c("Oslo", "Viken", "Vestland", "Rogaland",
             "Trondelag", "Innlandet", "Agder",
             "Nordland", "Troms og Finnmark"),
  rate   = c(68.4, 71.2, 87.8, 64.5, 61.3, 6.1, 54.2, 49.8, 42.1),
  n      = c(402, 448, 681, 318, 297, 251, 198, 177, 148)
)

spec_rb <- hd_spec(regions,
                   x    = "region",
                   y    = "rate",
                   n    = "n")

opts_rb <- hd_opts(
  title    = "Health indicator by region",
  subtitle = "Source: Norwegian Directorate of Health",
  ylab     = "Rate per 100 000",
  flip     = TRUE
)

# Static ggplot2 — value labels placed inside or outside bars automatically
hd_make(spec_rb, "ranked_bar", opts_rb, backend = "ggplot2", ascending = TRUE)
hd_make(spec_rb, "ranked_bar", opts_rb, backend = "highcharter", ascending = FALSE)

hd_make(spec_rb, "ranked_bar", opts_rb,
        ascending = TRUE,
        aim       = 63,
        vs        = "Oslo",
        backend   = "ggplot2")

hd_make(spec_rb, "ranked_bar", opts_rb,
        ascending = FALSE,
        aim       = 63,
        vs        = "Oslo",
        backend   = "highcharter")

## Testing
## ---------------------------------------------------------------------------

# Basic scatter plot - layered API
hd(mtcars, x = "wt", y = "mpg", backend = "ggplot2") +
 hd_geom_scatter() +
 hd_opts(title = "Scatter Plot of mtcars")

# Basic scatter plot - declarative API
car <- hd_spec(mtcars, x = wt, y = mpg)
opt <- hd_opts(title = "Scatter Plot of mtcars")
hd_make(car, geom = "scatter")


library(highcharter)
hc <- highchart() %>%
#   hc_chart(type = "scatter") %>%
  hc_title(text = "Scatter Plot of MPG vs Weight") %>%
  hc_xAxis(title = list(text = "Weight (1000 lbs)")) %>%
  hc_yAxis(title = list(text = "Miles Per Gallon")) %>%
  hc_add_series(
    data = mtcars,
    type = "scatter",
    hcaes(x = wt, y = mpg),
    name = "Cars"
  )

hc

car <- hd_spec(mtcars, x = "wt", y = "mpg")
opt <- hd_opts(title = "Scatter Plot of mtcars")
hd_make(car, geom = "scatter")

hd(car) +
  hd_geom_scatter() +
  hd_opts(title = "Scatter Plot of mtcars")
