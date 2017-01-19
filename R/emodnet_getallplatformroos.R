#' Function to list the stations for which EMODnet has physics data within a given region
#'
#' This function uploads EMODnet metadata about the location of stations
#' as well as the physics parameters that have been monitored at these stations. It 
#' differs from getallplatform because it filters information by ecoregions or ROOS
#' i.e. Regional Operational Oceanographic System
#' 
#' \code{getallplatformroos} produces a list of platform at which data has been monitored 
#' within a given region. 
#' 
#' @param roosid is a character variable "1" to "6". 
#' BOOS is Baltic, NOOS is north West European Shelves ("3"), IBI is Irland Biscay Iberia, MOON mediterranean

emodnet_getallplatformroos <- function(roosid){
  myurl <- paste("http://www.emodnet-physics.eu/Map/service/WSEmodnet2.aspx?q=GetAllPlatformsRoos&RoosID=",roosid,"&Format=txt/xml", sep = "")
  inter <- getURL(myurl)
  inter1 <- gsub(pattern = "utf-16", replacement = "utf-8", x = inter, fixed = TRUE)# use exact matching
  myxml <- xmlParse(inter1)# erroneous encoding!xmlParse always used the encoding provided by the document, which is wrong in this case. so we need to change
  xmltop = xmlRoot(myxml)
  size <- xmlSize(xmltop)
  mynames <- unique(unlist(sapply(c(1:size),function(i)names(getChildrenStrings(xmltop[[i]])))))
  
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