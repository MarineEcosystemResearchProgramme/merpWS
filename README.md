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

Below are possible workflows making use of merpWS functions. These workflows exemplify how data from different data sources can be combined to create "added data value". Typically we combine an observed variable with one or several explanatory ones, thereby mimicking . Note that web services are in most cases recent additions to data portals and bugs on their end are common. We are working in collaboration with data holding institutes to help them improve their offer.

### Cefas data

CEFAS has recently made its API available. It allows exploring and downloading some the data described in its new Data Hub.

``` r
# list all data files
mydatasets <- get_cefas_datasets()

# extract csv files (only downloadable format)
mydownloads <- mydatasets$to_download
mydata <- mydownloads[explore_cefas_data(mydownloads$Name, keyword = "SWT"), ]
```

CEFAS temperature data from different projects are available. They can be downloaded one by one and aggregated. Below is an example for one of the data sets.

``` r
temp_data <- download_cefas_data(recordset_id = mydata$Id[1])
```

We aggregate 10 CEFAS data sets together to obtain the data.frame temp\_data. The Dates are reformatted to create year, month and day columns.

``` r
# extract date in year, month and day from "Time"
library(magrittr)
inter <- strsplit(as.character(temp_data$Time), split = " ") %>%
  sapply(., function(x) x[[1]]) %>%
  strsplit(., split = "/") 
temp_data$day <- as.numeric(sapply(inter, function(x) x[[1]]))
temp_data$month <- as.numeric(sapply(inter, function(x) x[[2]]))
temp_data$year <- as.numeric(sapply(inter, function(x) x[[3]]))
```

``` r
# plot temperature record locations. 
library(ggplot2)
library(ggmap)
mymap <- get_map(location = c(lon = -2.5, lat = 53.5), zoom = 5, maptype = "satellite")
ggmap(mymap) + geom_point(aes(x = Long, y = Lat), size = 0.5, data = temp_data)
```

<img src="README-figure-1.png" style="display: block; margin: auto;" />

``` r
# get some biotic data from obis for two species of barnacles with different thermal affinities: 
# the southern species Balanus stellatus and the northern species Semibalanus balanoides. 
library(robis)
library(ggmap)
library(mregions)
library(rgeos)
library(sp)
library(merpData)

uk_eez <- mr_shp("MarineRegions:eez", maxFeatures = NULL, filter = "United Kingdom Exclusive Economic Zone")
uk_eez <- SpatialPolygonsDataFrame(gSimplify(uk_eez, tol = 0.01, topologyPreserve = TRUE), 
data = uk_eez@data)

stellatus <- plot_obis("Chthamalus stellatus", shapefile = uk_eez, myresolution = 0.5, 
                     myzoom = 5, gridded = T)$obis_data
stellatus <- format_obis_date(stellatus)
stellatus <- stellatus[!is.na(stellatus$eventDate), ]

balanoides <- plot_obis("Semibalanus balanoides", shapefile = uk_eez, myresolution = 0.5, 
                     myzoom = 5, gridded = T)$obis_data
balanoides <- format_obis_date(balanoides)
balanoides <- balanoides[!is.na(balanoides$eventDate), ]
```

``` r
# draw realized thermal niche by matching occurrences with CEFAS temperature data. This can be a slow process
# that may take a few minutes depending on the size of both data sets to match.
stellatus_temp <- rep(NA, nrow(stellatus))
for(i in 1:length(stellatus_temp)) {
  stellatus_temp[i] <- match_env(env_lon = temp_data$Long, env_lat = temp_data$Lat, env_time = list(year = temp_data$year, month =     temp_data$month), bio_lon = stellatus$decimalLongitude[i], bio_lat = stellatus$decimalLatitude[i], bio_time = list(year = stellatus$year[i], month = stellatus$month[i]), max_dist = 100000, env_variable = temp_data$tC)
  print(stellatus_temp[i])
}

balanoides_temp <- rep(NA, nrow(balanoides))
for(i in 1:length(balanoides_temp)) {
  balanoides_temp[i] <- match_env(env_lon = temp_data$Long, env_lat = temp_data$Lat, env_time = list(year = temp_data$year, month =     temp_data$month), bio_lon = balanoides$decimalLongitude[i], bio_lat = balanoides$decimalLatitude[i], bio_time = list(year = balanoides$year[i], month = balanoides$month[i]), max_dist = 100000, env_variable = temp_data$tC)
  print(balanoides_temp[i])
}

mydf <- data.frame(temp = c(stellatus_temp, balanoides_temp), 
                   species = c(rep("stellatus", length(stellatus_temp)), rep("balanoides", length(balanoides_temp))))
ggplot(mydf) + geom_density(aes(temp, col = species))
```

<img src="README-unnamed-chunk-10-1.png" style="display: block; margin: auto;" />

Development
-----------

merpWS functions are being developed openly on github.
