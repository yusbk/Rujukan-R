## R script yang dilarikan setiap kali R dimulakan.
## .Rprofile yang diletakkan di ~/domain_name tidak dipakai sekiranya
## terdapat .Rprofile di projek folder


## local creates a new, empty environment
## This avoids polluting the global environment with
## the object r
local({
  r = getOption("repos")
  r["CRAN"] = "https://cran.rstudio.com/"
  options(repos = r)
})


## R prompt
options(prompt = "R> ")

## Libraries
.libPaths("~/Rpackages")

## ## Create new environment for functions
## ## so it won't de deleted with rm(list=ls())
## .env = new.env()
## ## headtail
## .env$ht = function(d, n = 6) rbind(head(d, n), tail(d, n))
## ## first 5 rows and 5 colmns
## .evn$hh = function(d) d[1:5, 1:5]
## attach(.env)
