% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_bioregion.R
\name{get_bioregion}
\alias{get_bioregion}
\title{get_bioregion}
\usage{
get_bioregion(bioregion = "Scotian Shelf")
}
\arguments{
\item{bioregion}{name of the bioregion to match from the `NAME_E` column from [Open Data](https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0). Default is `"Scotian Shelf"`}
}
\value{
sf data.frame
}
\description{
get_bioregion
}
\examples{
bioregion <- get_bioregion()
}
