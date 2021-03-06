% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pml_trait_explorer.R
\name{pml_trait_explorer}
\alias{pml_trait_explorer}
\title{Query the PML trait explorer tool}
\usage{
pml_trait_explorer(aphia_id = NULL, stat = "mean")
}
\arguments{
\item{aphia_id}{is the WoRMS identifier for the species of interest.
This can be a single value or multiple values separated by commas.}

\item{stat}{is the trait statistic to return. Options are 'mean'
for the expected value, 'sd' for the standard error, 'distmean' for the
location parameter of the probability distribution and 'distsd' for the
scale parameter of the probability distribution.}
}
\value{
a data.frame with a row for each aphia id and in columns
the available estimated traits.
}
\description{
The function returns estimated trait data for marine species
as calculated by the PML trait explorer.
}
\details{
\code{pml_trait_explorer} takes aphia ids and
returns JSON data of estimated trait values
for the species considered.
}
\examples{
aphia_id <- c(107552,107381)
pml_trait_explorer(aphia_id = aphia_id, stat = "mean")
}

