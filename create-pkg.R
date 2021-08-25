## Package development
## -------------------
## OBS!! Make sure to run R from root package directory!
pkgneed <- c('readxl','odbc','RSQLite','openxlsx', 'backports')
## install.packages(pkgneed)
packages <- c("usethis", "roxygen2", "rmarkdown", "knitr", "pkgdown", "systemfonts", "here", "fs",
              "data.table", pkgneed)
## install.packages(pkgs)
## devtools::install_github("ropenscilabs/travis")

## Now load or install&load all with pacman
pacman::p_load(packages, character.only = TRUE)

sapply(packages, require, character.only = TRUE)


## Check packages availabe or install it if not then load all
newpkg <- packages[!(packages  %in% installed.packages()[, "Package"])]
if(length(newpkg)) install.packages(newpkg)
sapply(packages, require, character.only = TRUE)

## Looping
devtools::load_all()
devtools::document()

devtools::check()
devtools::test()


# Run to build the website
pkgdown::build_site()
pkgdown::build_news(preview = TRUE)

## Run in console
## devtools::test_file() #for a specific active file
## test_coverage()


usethis::edit_r_buildignore()



## STEP 1
## Create package from start
##--------------------------
pkgs <- c("usethis", "roxygen2", "devtools", "rmarkdown", "knitr", "pkgdown", "here", "fs", "data.table")
install.packages(pkgs)
sapply(pkgs, require, character.only = TRUE)
devtools::install_github("ropenscilabs/travis")

## Setup R pkg structure
create_package("~/Git-personal/norgeo")

## build ignore
use_build_ignore("^draft$", escape = FALSE)
use_build_ignore("^start_pkg$", escape = FALSE)
use_build_ignore(".travis.yml")

## Add DESCRIPTION
usethis::use_description()

## licence
usethis::use_mit_license(name = "Yusman Kamaleri")

## create README.md for Github start page
use_readme_rmd()

## Create MIT license file
usethis::use_mit_license("Yusman Kamaleri")

usethis::use_vignette()

## to use pipe %>%
use_pipe()

## ## Optional to add to .gitignore root dir
## pkgdowntravis.Rproj
## .Rproj*



## create R file
## -------------
library(here)
library(fs)

fs::file_create(here("R", "add_change.R"))
fs::file_create(here("R", "utils.R"))
fs::file_create(here("R", "multiple_change.R"))

## add package to DESCRIPTION
usethis::use_package("fs")
usethis::use_package("DBI")
usethis::use_package("RSQLite")
## Add more package dependencies
pkgs <- c("data.table", "fs", "readxl", "odbc", "DBI", "openxlsx")
sapply(pkgs, usethis::use_package)


## Add bug reports and link to pkgdown index
usethis::use_github_links()


## Test
##-----
usethis::use_test("Files")
usethis::use_test("Save_file")


## Pkgdown
## ---------
library(pkgdown)

# Run once to configure package to use pkgdown
usethis::use_pkgdown()

# Run to build the website
pkgdown::build_site()



## ## Initialize Git Repository
## git init
## git add --all
## git commit -m "first commit"
## git remote add origin https://github.com/username/pkgname.git
## git push origin master


## Travis CI setup
##-------------------
## OBS!! This doesn't work with organization account so have to link with private account
## that has access to the organization account
## go to https://travis-ci.org and sign in with your Github account,
## then run use_travis in the package home directory
usethis::use_travis()


## Create package site with CI
## ----------------------------
## Option 1:
## 1.Go to https://travis-ci.org and link your Github account
## 2.Enter to ur Travis CI profile page and enable the Travis for the project repo
## this is where an on/off button next to 'Settings' on each repos
## 3.Add 'pkgdown' under Suggests: in the DESCRIPTION so Travis install pkgdown when build
## 4.Add docs/* in .gitignore to ignore entire local docs folder
## 5.Add a file with name .travis.yml in ur repo folder withe the following content:

language: r
cache: packages

after_success:
  - Rscript -e 'pkgdown::build_site()'

deploy:
  provider: pages
skip-cleanup: true
github-token: $GITHUB_PAT
keep-history: true
local-dir: docs
on:
  branch: master

## cache:packages - tells Travis to cache package that has dependencies to speed up
## after_success: - To run when R CMD CHECK succeeded ie. build pkgdown and create docs folder in
## Travis's server
## deploy: - Tell Travis to go ahead upload docs to GitHub specified via provider: pages.
## The 'on' tell travis to do it only on the master branch.
## The default for GitHub targe branch will be gh-pages

## For github-token: $GITHUB_PAT
## Go to GitHub profile setting and create a new Personal Access Token (PAT) under the Developer Settings tab.
## Give meaningful Token description eg. auto-upload pkg docs folder
## Select 'public_repo' for public packages or just 'repo' for private package.
## Copy the PAT and head over to Travis repository settings, where you can specify env variable.
## Make sure to name the env variable GITHUB_PAT and paste the value.

## Now you can commit the repo DESCRIPTION and .travis.yml to the master and Travis will
## create the website




## Option 2:
## ------------
## customize _pkgdown.yml
## add _pkgdown.yml to .Rbuildignore
usethis::use_build_ignore(files = "_pkgdown.yml")

## then give Personal Access Token (PAT) to Github and Travis via API Key.
## 1. Create GitHub PAT
usethis::browse_github_token()
## then click button "Generate token" on the website
## create .Renviron file in home directory and save it like
GITHUB_PAT = paste your PAT here
## to check when restart R run
system('echo $GITHUB_PAT')

## 2. Create Travis API Key
travis::browse_travis_token()
## this will require you to login, then click "Copy Token" on the right bottom
## save it in the .Renviron file. Check the URL if it's .org or .com as this should
## be written differently in .Renviron ie. R_TRAVIS_ORG vs. R_TRAVIS_COM in .Renviron
R_TRAVIS_ORG = paste your travis token here

## important to restart R so the values in .Renviron are activated
## Create deploy key
travis::use_travis_deploy()
## if doesn't work then try
travis::use_travis_deploy(endpoint = '.org')

## if this works, then head over to TRAVIS settings page under "more options"
## and you should see the TRAVIS_DEPLOY_KEY somewhere at the bottom
## copy the API and add to .travis.yml, like this
before_cache: Rscript -e 'remotes::install_cran("pkgdown")'
deploy:
  provider: script
script: Rscript -e 'pkgdown::deploy_site_github(ssh_id = Sys.getenv("TRAVIS_DEPLOY_KEY", ""))'
skip_cleanup: true

## commit and push to GitHub and gh-pages will be created when Travi CI has finished
## if gh-pages fail to be created, create it as orphan gh-pages with the following
git checkout --orphan gh-pages
# Clean all (untracked) files:
git reset --hard
# Create first commit:
git commit --allow-empty -m "Initializing gh-pages branch"
# push to remote
git push origin gh-pages

## Then change GitHub Pages to gh-pages if it was /docs folder before
## source https://sahirbhatnagar.com/blog/2020/03/03/creating-a-website-for-your-r-package/


### TEST package
## -------------
fylke_folder <- "C:\\Users\\ybka\\Documents\\GitFH\\khfunction\\geo\\fylke"

dir_ls(fylke_folder)

select_ssb("jan2018", "change", fylke_folder)

f2018 <- add_change("jan2018", "change", year = 2018, type = "fylke", folder.path = fylke_folder)
f2020 <- add_change("jan2020", "change", year = 2020, type = "fylke", folder.path = fylke_folder)

merge_multi(f2020, f2018)

norgeo:::check_element(f2020, f2018)

merge_geo(list(f2018, f2020), output = "complete")
merge_geo(list(f2018, f2020), output = "change")
