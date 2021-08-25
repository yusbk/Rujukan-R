
## Når man kjøre i Linux så å disse installeres først

## kableExtra kreves disse pakke avhenginghet å bli installert
libssl-dev #for openssl
libcurl4-openssl-dev #for libcurl
libxml2-dev #for libxml-2.0

## kjøre i terminal
sudo apt install libssl-dev libcurl4-openssl-dev libxml2-dev

## Pakker som jeg trenger hvergang ny installasjon skal gjenomføres.
## Disse skal installeres om det ikke allerede gjort i folder "r-pakker"

load <- function(pkg){
  nypkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(nypkg))
    install.packages(nypkg, dependencies = TRUE, repos = "http://cran.r-project.org")
  sapply(pkg, require, character.only = TRUE)
}

pakker <- c("knitr",
            "data.table",
            "ggplot2",
            "shiny",
            "shinydashboard",
            "DT",
            "kableExtra",
            "gridExtra")

load(pakker)
