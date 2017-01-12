#' Download CEFAS data using the CEFAS API
#' 
#' The function returns CEFAS data as a csv file directly
#' loaded into R
#'
#' \code{download_cefas_data} takes one argument recordset_id. It loads
#' the corresponding data into R. It takes one argument recordset_id
#' that identifies the data to download. The list of csv
#' files and their corresponding recordset ids can be found be running the
#' function get_cefas_datasets and extracting the to_download object.  
#' 
#' @param recordset_id is the ID number of the recordset to download.
#' 
#' @return a fields data.frame containg the name of all fields, an Id reference for each field,
#' the type of information it contains, the exact column name and information about
#' minimum/maximum values
#' 
#' @examples
#' mydata <- get_cefas_datasets()
#' mydownloadable <- mydata$to_download
#' get_cefas_dataset_fields(mydownloadable$Id[1])
#' 
download_cefas_data <- function(recordset_id){
  myurl <- paste("https://cefasapp.cefas.co.uk/api/export/", recordset_id, "?bypassemail=true", sep = "")
  dat <- suppressWarnings(jsonlite::fromJSON(readLines(myurl)))
  return(read.csv(url(dat$Links$Download$Href)))
}