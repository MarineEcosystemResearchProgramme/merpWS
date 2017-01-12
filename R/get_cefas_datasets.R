#' List CEFAS data sources availabe from CEFAS API
#'
#' The function returns all recordsets as well as a
#' subset of recordsets that can be downloaded (i.e. csv files)
#' using the API. 
#'
#' \code{get_cefas_datasets} takes no argument. The original API returns
#'  a list of csv files and pdfs, not all of them can be downloaded. This functions
#'  returns both the full set of recordsets and a subset containing all csv files
#'  which in principle can all be downloaded. Note that this is a smallest
#'  set of datasets that can be accessed from the CEFAS data hub. 
#'  
#' @return two data.frames data_sources (integral list of recordsets)
#' and to_download (list of all csv files)
#' 
#' @examples
#' mydata <- get_cefas_datasets()
#' 
#' 
get_cefas_datasets <- function()
{
  myurl <- "https://cefasapp.cefas.co.uk/api/Recordsets"
  dat <- suppressWarnings(jsonlite::fromJSON(readLines(myurl)))
  return(list(data_sources = dat, to_download = dat[grep(dat$Name, pattern = ".csv"),]))
}