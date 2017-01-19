#' Function to extract and map obis records
#'
#' This is a wrapper for the occurrence function in the robis package that extracts obis
#' data for a given taxa and plot its records on a map. The option of gridding the data
#' is available.  
#' 
#' @return \code{plot_obis} returns a data.frame containing the extracted obis data 
#' and a map showing occurrences.  
#' 
#' @param area.x is a vector of longitudes for the area of interest.
#' Alongside area.y it describes the shape of a polygon in which \code{plot_obis}
#' looks for records. Coordinates must be provided following the shape of the area
#' clockwise, see example. 
#' If NULL the function returns all available records. 
#' @param area.y is a vector of latitudes for the area of interest
#' @param myzoom is the zoom to be applied to plot the gridded data on ggmap map
#' @param lon_centre is the user-defined longitude the map will be centred on. Default to mean 
#' longitude of observations.
#' @param lat_centre is the user-defined latitude the map will be centred on. Default to mean 
#' latitude of observations.
#' @param gridded is a logical argument setting whether to grid extracted obis data.
#' @param myresolution is the size of the cells the data is to be aggregated over
#' 
#' @examples
#' library(robis)
#' library(wellknown)
#' # extract records for area of interest. Provide coordinates for the contour of the area
#' # going clockwise and repeating the initial coordinates at the end to "close" the polygon 
#' records <- plot_obis("Asterias rubens", area.x = c(-10, -10, 10, 10, -10), area.y = c(40, 60, 60, 40, 40),
#' myresolution = 0.5, myzoom = 5, gridded = T)
#' # examine the data
#' head(records$obis_data)
#' # plot the data
#' records$myplot

plot_obis <- function(scientificname, year = NULL, area.x = NULL, area.y = NULL, myzoom = 7, lat_centre = NULL, lon_centre = NULL, 
                      gridded  = F, myresolution = 0.5){
  
  list.coord <- vector("list", length = length(area.x))
  for(i in 1:length(area.x)) list.coord[[i]] <- c(area.x[i], area.y[i])
  if(!is.null(area.x)) {
    mydata <- occurrence(scientificname, year = year, geometry = polygon(list.coord))
  }
  if(is.null(area.x)) mydata <- occurrence(scientificname, year = year)
  if(!gridded){
    if(is.null(lat_centre)){
      mymap <- get_map(location=c(mean(mydata$decimalLongitude),mean(mydata$decimalLatitude)),"satellite",zoom=myzoom,scale="auto")
    }
    else{
      mymap <- get_map(location=c(lon_centre,lat_centre),"satellite",zoom=myzoom,scale="auto")
    }
    p <- ggmap(mymap)
    p <- p + geom_point(data = mydata, aes(x = decimalLongitude, y = decimalLatitude))
  }
  
  dat <- NULL
  if(gridded){
    breakx <- seq(min(floor(mydata$decimalLongitude)), max(ceiling(mydata$decimalLongitude)), by = myresolution)
    breaky <- seq(min(floor(mydata$decimalLatitude)), max(ceiling(mydata$decimalLatitude)), by = myresolution)
    cellx <- cut(mydata$decimalLongitude, breaks = breakx, labels = breakx[1:(length(breakx)-1)])
    celly <- cut(mydata$decimalLatitude, breaks = breaky, labels = breaky[1:(length(breaky)-1)])
    mycoord <- paste(cellx, celly, sep = "_")
    Records <- table(mycoord)
    
    inter <- expand.grid(breakx, breaky)
    dat <- data.frame(x0 = inter[, 1], x1 = inter[, 1] + 1, y0 = inter[, 2], y1 = inter[, 2] + 1)
    dat$mycoord <- paste(dat$x0, dat$y0, sep = "_")
    
    dat$Records <- rep(NA, nrow(dat))
    
    idx <- match(dat$mycoord, names(Records))
    dat$Records <- as.numeric(Records)[idx]
    dat$id <- c(1: nrow(dat))
    dat$myresolution <- rep(myresolution, nrow(dat))
    
    if(is.null(lat_centre)){
      mymap <- get_map(location=c(mean(mydata$decimalLongitude),mean(mydata$decimalLatitude)),"satellite",zoom=myzoom,scale="auto")
    }
    else{
      mymap <- get_map(location=c(lon_centre,lat_centre),"satellite",zoom=myzoom,scale="auto")
    }
    p <- ggmap(mymap)
    p <- p + geom_tile(data = dat, aes(x = (x0 + x1) / 2, y = (y0 + y1) / 2, width = myresolution, height = myresolution, fill = Records, group = id)) +
      scale_fill_gradient(low = "yellow", high = "red", na.value = NA) +
      theme(axis.text = element_text(size = 14), axis.title = element_text(size = 18) , plot.margin = unit(c(t = 1,b = 10,r = 10,l = 10), unit = "mm")) +
      labs(x= "Longitude", y = "Latitude")
  }
  return(list(obis_data = mydata, gridded_data = dat, myplot = p))
}


