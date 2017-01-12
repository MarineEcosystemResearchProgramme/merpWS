merpWS
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

##### Functions to access marine data via Web Services

An increasing number of marine data portals are making web services available. These allow, alongside traditional downloads from the browser, to access data programmaticely directly from scripting softwares such as Rstudio.

The main advantages are two-folds: 1) the data fetched by R scripts are always up to date, a feature particularly useful when using data portals that are constantly added to; 2) fetching, formatting and cleaning steps can be done as part of a single seamless workflow.

merpWS is a collection of R functions making use of available marine web services to retrieve data from the main marine data portals.

Installation
------------

merpWS can be installed using the install\_github function from the devtools package.

``` r
library(devtools)
devtools::install_github(repo = "MarineEcosystemResearchProgramme/merpWS")
library(merpWS)
```

Usage
-----

Below is the list of available functions:
+ explore\_cefas\_data

-   get\_cefas\_dataset\_fields

-   get\_cefas\_datasets

Each function has a help file which can be accessed in R by typing ? followed by the name of the function.

Development
-----------

merpWS functions are being developed openly on github.
