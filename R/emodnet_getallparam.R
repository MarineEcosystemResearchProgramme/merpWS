#' Function to list the physics parameters for which EMODnet has data
#'
#' This function uploads EMODnet metadata about both the individual parameters
#' and the parameter groups for which data is available. 
#' 
#' \code{getallparam} produces a list of parameters for which data is available.
#' It can be used in tandem with other functions that list all stations 
#' (potentially within a given ecoregion). The function takes no parameter and
#' gives an exhaustive list of parameters. 
#' 

emodnet_getallparam <- function(){
  myurl <- "http://www.emodnet-physics.eu/map/Service/WSEmodnet2.aspx?q=GetAllParameters&Format=txt/xml"
  temp <- getURL(myurl)
  temp <- gsub(pattern = "utf-16", replacement = "utf-8", x = temp, fixed = TRUE)
  myxml <- xmlParse(temp)
  xmltop <- xmlRoot(myxml)
  size <- xmlSize(xmltop)
  mynames <- unique(unlist(sapply(c(1:size), function(i)names(getChildrenStrings(xmltop[[i]])))))
  
  # need to figure out all the names present in the dataset, because not all entries will have the same number
  res <- matrix(NA, ncol = length(mynames), nrow = size)
  nbnames <- length (mynames)
  for (i in 1:size)
  {
    othernames <- names(getChildrenStrings(xmltop[[i]]))
    idx <- match(othernames, mynames)
    nbnames <- c(nbnames, length (othernames))
    res[i, c(idx)] <- getChildrenStrings(xmltop[[i]])
  }
  res <- as.data.frame(res)
  names(res) <- mynames
  res
}