% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_cefas_dataset_fields.R
\name{get_cefas_dataset_fields}
\alias{get_cefas_dataset_fields}
\title{List fields for a given CEFAS API data source}
\usage{
get_cefas_dataset_fields(recordset_id)
}
\arguments{
\item{recordset_id}{is an ID number for the recordset the fields are to be
extracted for.}
}
\value{
a fields data.frame containg the name of all fields, an Id reference for each field,
the type of information it contains, the exact column name and information about
minimum/maximum values
}
\description{
The function returns the fields for the csv files that can be accessed
via the CEFAS API.
}
\details{
\code{get_cefas_dataset_fields} takes one argument recordset_id. It returns
all fields for the corresponding csv file, if it does exist. The list of csv
files and their corresponding recordset ids can be found be running the
function get_cefas_datasets and extracting the to_download object.
}
\examples{
mydata <- get_cefas_datasets()
mydownloadable <- mydata$to_download
get_cefas_dataset_fields(mydownloadable$Id[1])


}

