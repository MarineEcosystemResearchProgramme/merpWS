#' Fetch recent raw EMODnet data
#'
#' The function returns recent (up to two months old)
#' high-resolution time series from the EMODnet physics portal, 
#' given a location and a parameter.
#'  
#' @return a data.frame containing the requested data. 
#' 
#' @param platformid is the EMODnet specific code for the
#' location at which the data is recorded. The full list
#' of platform ids is provided by the function \code{emodnet_getallplatform} 
#' @param paramcode is the EMODnet specific code for the
#' parameter of interest. The full list
#' of parameters and their corresponding codes is provided 
#' by the function \code{emodnet_getallparam}
#' 
#' @examples
#' library(XML)
#' library(RCurl)
#' library(merpWS)
#' library(magrittr)
#' # get platform ids and parameter codes
#' list_platform <- emodnet_getallplatform()
#' list_param <- emodnet_getallparam()
#' 
#'# get current data for one platform where temperature data is available
#'myresult <- emodnet_getdata_atplatform(platformid = 437, paramcode = "TEMP")

emodnet_getdata_atplatform <- function(platformid, paramcode){
  myurl <- paste("http://www.emodnet-physics.eu/map/Service/WSEmodnet2.aspx?q=GetAllLatestDataCode&PlatformID=",
                 platformid, "&ParamCode=", paramcode, sep = "")
  inter <- getURL(myurl)
  inter1 <- gsub(pattern = "utf-16", replacement = "utf-8", x = inter, fixed = TRUE)# use exact matching
  myxml <- xmlParse(inter1)
  xmltop = xmlRoot(myxml)
  size <- xmlSize(xmltop)
  mynames <- unique(c(unlist(sapply(c(1:size),function(i)names(getChildrenStrings(xmltop[[i]]))))))
  
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

  vres1$rawdata <- as.character(vres1$ParamValue) %>%
    strsplit(., split = ";", fixed = T) %>%
    sapply(., function(x) gsub(x[grep(x, pattern = "TEMP=")], pattern = "TEMP=", replacement = "")) %>%
    gsub(., pattern = ",", replacement = ".") %>%
    as.numeric(.)
  
  # dealing with data quality
  vres1$data_quality <- rep(NA, nrow(vres1))
  vres1$data_quality[grep(vres1$ParamValue, pattern = paste(paramcode, "_QC=0", sep = ""))] <- "unknown"
  vres1$data_quality[grep(vres1$ParamValue, pattern = paste(paramcode, "_QC=1", sep = ""))] <- "good"
  vres1$data_quality[grep(vres1$ParamValue, pattern = paste(paramcode, "_QC=2", sep = ""))] <- "probably_good"
  vres1$data_quality[grep(vres1$ParamValue, pattern = paste(paramcode, "_QC=3", sep = ""))] <- "potentially_correctable"
  vres1$data_quality[grep(vres1$ParamValue, pattern = paste(paramcode, "_QC=4", sep = ""))] <- "bad"
  vres1$data_quality[grep(vres1$ParamValue, pattern = paste(paramcode, "_QC=7", sep = ""))] <- "nominal_value"
  vres1$data_quality[grep(vres1$ParamValue, pattern = paste(paramcode, "_QC=8", sep = ""))] <- "interpolated_value"
  vres1$data_quality[grep(vres1$ParamValue, pattern = paste(paramcode, "_QC=9", sep = ""))] <- "missing_value"
  vres1[grep(vres1$ParamValue, pattern = paste(paramcode, "=", sep = "")), ]
}