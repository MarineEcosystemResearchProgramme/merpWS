#' Search matching strings in RDFs
#'
#' The function searches the bodc or nerc triplestores for a given search word.
#' It returns all matches whether they are present in the subject, predicate or object.  
#'
#' @param mylimit is the number of triples to extract. It can be string or numeric
#' @param nerc is boolean TRUE/FALSE. If TRUE (the default), access triples 
#' from nerc vocab endpoint. If FALSE, triples at BODC enpoint are queried. 
#'
#' 

bodc_search_string <- function(nerc = TRUE, classes = TRUE){
  endpoint <- ifelse(nerc == TRUE, "http://vocab.nerc.ac.uk/sparql/sparql", "http://linked.bodc.ac.uk/sparql/")
  what <- ifelse(classes == TRUE, "classes", "properties")
  
  if(what == "classes"){
  myquery <- "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
  PREFIX owl: <http://www.w3.org/2002/07/owl#>
  SELECT *
  WHERE{
	?class a rdfs:Class
	?class a owl:Class
  }"
  }
  
  else{
  myquery <- "PREFIX rdf: <http://www.w3.org/2000/01/rdf-schema#>
  SELECT *
  WHERE{
	?class a rdf:Property
  }"
  }
  
  qd <- SPARQL(url = endpoint, query = myquery)
  qd$results
}

