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
  temp <- getURL(myurl)
  temp <- gsub(pattern = "utf-16", replacement = "utf-8", x = temp, fixed = TRUE)
  myxml <- xmlParse(temp)
  xmltop <- xmlRoot(myxml)
  size <- xmlSize(xmltop)
  mynames <- unique(c(unlist(sapply(c(1:size), function(i) names(getChildrenStrings(xmltop[[i]]))))))
  
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

  res$rawdata <- as.character(res$ParamValue) %>%
    strsplit(., split = ";", fixed = T) %>%
    sapply(., function(x) gsub(x[grep(x, pattern = "TEMP=")], pattern = "TEMP=", replacement = "")) %>%
    gsub(., pattern = ",", replacement = ".") %>%
    as.numeric(.)
  
  mydates <- as.character(res$Date) %>%
    strsplit(., split = " ", fixed = T) %>%
    sapply(., function(x) strsplit(x[1], split = "/", fixed = T))
  
  res$year <- sapply(mydates, function(x) x[1])
  res$month <- sapply(mydates, function(x) x[2])
  res$day <- sapply(mydates, function(x) x[3])
  
  # dealing with data quality
  res$data_quality <- rep(NA, nrow(res))
  res$data_quality[grep(res$ParamValue, pattern = paste(paramcode, "_QC=0", sep = ""))] <- "unknown"
  res$data_quality[grep(res$ParamValue, pattern = paste(paramcode, "_QC=1", sep = ""))] <- "good"
  res$data_quality[grep(res$ParamValue, pattern = paste(paramcode, "_QC=2", sep = ""))] <- "probably_good"
  res$data_quality[grep(res$ParamValue, pattern = paste(paramcode, "_QC=3", sep = ""))] <- "potentially_correctable"
  res$data_quality[grep(res$ParamValue, pattern = paste(paramcode, "_QC=4", sep = ""))] <- "bad"
  res$data_quality[grep(res$ParamValue, pattern = paste(paramcode, "_QC=7", sep = ""))] <- "nominal_value"
  res$data_quality[grep(res$ParamValue, pattern = paste(paramcode, "_QC=8", sep = ""))] <- "interpolated_value"
  res$data_quality[grep(res$ParamValue, pattern = paste(paramcode, "_QC=9", sep = ""))] <- "missing_value"
  res[grep(res$ParamValue, pattern = paste(paramcode, "=", sep = "")), ]
}