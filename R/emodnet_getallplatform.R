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
