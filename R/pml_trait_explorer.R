#' Query the PML trait explorer tool
#' 
#' The function returns estimated trait data for marine species
#' as calculated by the PML trait explorer. 
#'
#' \code{pml_trait_explorer} takes aphia ids and
#' returns JSON data of estimated trait values
#' for the species considered. 
#' 
#' @param aphia_id is the WoRMS identifier for the species of interest.
#' This can be a single value or multiple values separated by commas.
#' @param stat is the trait statistic to return. Options are 'mean'
#' for the expected value, 'sd' for the standard error, 'distmean' for the
#' location parameter of the probability distribution and 'distsd' for the
#' scale parameter of the probability distribution.
#' 
#' @return a data.frame with a row for each aphia id and in columns
#' the available estimated traits. 
#' 
#' @examples
#' aphia_id <- c(107552,107381)
#' pml_trait_explorer(aphia_id = aphia_id, stat = "mean")

pml_trait_explorer <- function(aphia_id = NULL, stat = "mean"){
  if(is.null(aphia_id)) {
    print("The function requires a species ID!")
  }
  else{
    if(length(aphia_id) > 1) aphia_id <- paste0(aphia_id, sep = c(rep(",", (length(aphia_id) -  1)), ""), collapse = "")
    myurl <- paste("http://server1.pml.ac.uk/traitexplorer/traitexplorer.py?querytype=2&aphiaids=", aphia_id,"&statistic=",stat,
                   "&format=json", sep = "")
    jsonlite::fromJSON(myurl)
  }
}
