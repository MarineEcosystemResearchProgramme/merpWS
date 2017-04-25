#' Function to list the stations for which EMODnet has physics data
#'
#' This function uploads EMODnet metadata about the location of stations
#' as well as the physics parameters that have been monitored at these stations. 
#' 
#' \code{emodnet_getallplatform} produces a list of platform at which data has been monitored.
#' The function takes no parameter and gives an exhaustive list of stations. 
#' 

emodnet_getallplatform <- function(){
  myurl <- "http://www.emodnet-physics.eu/map/Service/WSEmodnet2.aspx?q=GetAllPlatforms&Format=text/xml"
  temp <- getURL(myurl)
  temp <- gsub(pattern = "utf-16", replacement = "utf-8", x = temp, fixed = TRUE)
  if(grep(temp, pattern = "&") == 1) temp <- gsub(temp, pattern = "&", replacement = "&amp;")
  myxml <- xmlParse(temp)
  xmltop <- xmlRoot(myxml)
  size <- xmlSize(xmltop)
  mynames <- unique(unlist(sapply(c(1:size), function(i)names(getChildrenStrings(xmltop[[i]])))))
  
  res <- matrix(NA, ncol = length(mynames), nrow = size)
  nbnames <- length(mynames)
  for (i in 1:size)
  {
    othernames <- names(getChildrenStrings(xmltop[[i]]))
    idx <- match(othernames, mynames)
    nbnames <- c(nbnames, length(othernames))
    res[i, c(idx)] <- getChildrenStrings(xmltop[[i]])
  }
  res <- as.data.frame(res)
  names(res) <- mynames
  res
}
