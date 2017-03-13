#' List unique classes or properties in the triplestore
#'
#' The function searches the triplestore for classes and properties.
#' The classes and properties in RDF datasets can be declared but that
#' is not always the case  
#'
#' @param nerc : boolean parameter. whether the endpoint queried is nerc vocabulary server (TRUE) or bodc (FALSE)
#' @param instances : boolean parameter. whether all unique instances of each class should be returned
#' we recommand you first check the number of instances in each class, this could take a long time!
#'
#' 
bodc_classes <- function(nerc = TRUE, instances = FALSE){
  endpoint <- ifelse(nerc == TRUE, "http://vocab.nerc.ac.uk/sparql/sparql", "http://linked.bodc.ac.uk/sparql/")
  
  # what properties are used?
  myquery <- "SELECT DISTINCT ?graph ?properties 
  WHERE{
  {?s ?properties ?o .}
  UNION
  {GRAPH ?graph {?s ?properties ?o}}
  }
  ORDER BY ?properties"
  qres_properties <- SPARQL(url = endpoint, query = myquery)
  
  # what classes are used?
  myquery <- "SELECT DISTINCT ?class
  WHERE{
  ?instance a ?class .
  }
  ORDER BY ?class"
  
  qres_classes <- SPARQL(url = endpoint, query = myquery)
  
  runquery <- function(myclass){
  	myquery <- paste("SELECT DISTINCT ?instances
  WHERE{?instances a ", myclass, " .
  }
  ORDER BY ?instances", sep = "")  
  SPARQL(url = endpoint, query = myquery)$results
  }

  # get all instances for each of the classes?
  if(instances){
  	nbclasses <- length(qres_classes$results)
  	instances <- sapply(c(1:nbclasses), function(i){
  		runquery(qres_classes$results[i])
  	})		
  }
  list(properties = qres_properties$results, classes = qres_classes$results, instances = instances)
}

