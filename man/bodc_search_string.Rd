% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bodc_search_string.R
\name{bodc_search_string}
\alias{bodc_search_string}
\title{Search matching strings in RDFs}
\usage{
bodc_search_string(nerc = TRUE, classes = TRUE)
}
\arguments{
\item{nerc}{is boolean TRUE/FALSE. If TRUE (the default), access triples 
from nerc vocab endpoint. If FALSE, triples at BODC enpoint are queried.}

\item{mylimit}{is the number of triples to extract. It can be string or numeric}
}
\description{
The function searches the bodc or nerc triplestores for a given search word.
It returns all matches whether they are present in the subject, predicate or object.
}

