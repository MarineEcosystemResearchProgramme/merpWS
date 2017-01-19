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
  inter <- getURL(myurl)# erroneous encoding
  inter1 <- gsub(pattern = "utf-16", replacement = "utf-8", x = inter, fixed = TRUE)# use exact matching
  myxml <- xmlParse(inter1)# erroneous encoding!xmlParse always used the encoding provided by the document, which is wrong in this case. so we need to change
  xmltop = xmlRoot(myxml)
  size <- xmlSize(xmltop)
  mynames <- unique(unlist(sapply(c(1:size),function(i)names(getChildrenStrings(xmltop[[i]])))))
  
  # need to figure out all the names present in the dataset, because not all entries will have the same number
  vres <- matrix(NA,ncol= length(mynames),nrow=size)
  nbnames <- length (mynames)
  for (i in 1:size)
  {
    othernames <- names(getChildrenStrings(xmltop[[i]]))
    idx <- match(othernames,mynames)
    nbnames <- c(nbnames, length (othernames))
    vres[i,c(idx)] <- getChildrenStrings(xmltop[[i]])
  }
  vres1 <- as.data.frame(vres)
  names(vres1) <- mynames
  vres1
}