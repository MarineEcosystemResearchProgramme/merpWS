#' Access RDF triples at nerc or bodc sparql endpoints
#'
#' The function makes use of one of two sparql endpoints that can be used together 
#' to access BODC data. The first endpoint is the nerc vocab.
#' It contains the list of appropriate terms needed to query the bodc endpoint.  
#' the function returns a 3-column table with names s, p and o for subject, predicate and object
#' this is the typical "triple" format of RDFs, the building block of linked data
#'
#' @param mylimit is the number of triples to extract. 
#' It can be string or integer (the function lets you use numeric and converts it internally). 
#' Note that this operation can take a while if mylimit is high (>1e4). We recommend you do not try 
#' to visualize all triples at once
#' @param nerc is boolean TRUE/FALSE with default TRUE. 
#' If TRUE (the default), access triples from nerc vocab endpoint. 
#' If FALSE, triples at BODC enpoint are queried. 
#' @param named_graph is boolean TRUE/FALSE with default FALSE. 
#' Named graphs are sets of triples, rather than individual triples
#'
#' 

bodc_get_triples <- function(mylimit, nerc = FALSE, named_graph = FALSE){
  endpoint <- ifelse(nerc == TRUE, "http://vocab.nerc.ac.uk/sparql/sparql", "http://linked.bodc.ac.uk/sparql/")
  
  if(!is.integer(mylimit)) mylimit <- as.integer(mylimit)
  if(!is.character(mylimit)) mylimit <- as.character(mylimit)
  if(named_graph == FALSE) {
  myquery <- paste("SELECT ?s ?p ?o 
  WHERE{
	?s ?p ?o
  }
  limit ", mylimit, sep = "")}
  else {
    myquery <- paste("SELECT ?g ?s ?p ?o  
  WHERE{
	{?s ?p ?o}
	UNION
	{GRAPH ?g {?s ?p ?o} }
  }
  limit ", mylimit, sep = "")}
  
  qd <- SPARQL(url = endpoint, query = myquery)
  qd$results
}