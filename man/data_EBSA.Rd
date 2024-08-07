% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_EBSA.R
\name{data_EBSA}
\alias{data_EBSA}
\title{Get Ecologically and Biologically Significant Area Data}
\usage{
data_EBSA(bioregion)
}
\arguments{
\item{bioregion}{sf data.frame of the bio region. You can use \code{MarConsNetData::data_bioregion()} to download the bio region of your choice.}
}
\value{
a "sf" "dataframe" object
}
\description{
This function gets the ecologically and biologically significant
areas in the specified bio region. For more information see
https://open.canada.ca/data/en/dataset/d2d6057f-d7c4-45d9-9fd9
-0a58370577e0
}
\examples{
\dontrun{
bioregion <- data_bioregion()
ebsa <- data_EBSA(bioregion)
}
}
