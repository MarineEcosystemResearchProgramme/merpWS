#' Explore CEFAS data sources availabe from CEFAS API
#'
#' The function returns all recordset names matching 
#' a user-provided keyword 
#'
#' \code{explore_cefas_data} takes two arguments. The first
#' one list_sources is a list of names to look into. In the context 
#' of the CEFAS API this will typically be the "Name" columns of the
#' data returned by the function get_cefas_datasets(). The 
#' second argument keyword is a keyword provided by the user. 
#' The inputed keyword is not case sensitive. 
#'  
#' @return a subset data.frame containing all data sources whose
#' names match the provided keyword.
#' 
#' @examples
#' mydata <- get_cefas_datasets()
#' explore_cefas_data(list_sources = mydata$list_data_sets$Name, keyword = "Plankton")
#' 
#' 
explore_cefas_data <- function(list_sources = list_data_sets$Name, keyword){
  list_sources[grep(list_sources, pattern = keyword, ignore.case = T)]
}