## Run in older version of R to save the list of installed packages before upgrading to a new version of R
old_packages <- installed.packages()[, "Package"]
saveRDS(old_packages, "packages4-5-1.rds")

## Run in new version of R to install the same packages as in the old version
packages <- readRDS("packages4-5-1.rds")
install.packages(packages)

## Alternatively, use renv to manage package versions across R versions
install.packages("renv")
renv::init()
renv::snapshot()

## Install packages in new R version using renv
install.packages("renv")
renv::restore()

