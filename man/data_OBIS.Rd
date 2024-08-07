% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_OBIS.R
\name{data_OBIS}
\alias{data_OBIS}
\title{Get Ocean Biodiversity Information System (OBIS) data}
\usage{
data_OBIS(areas, geom_col = "geoms", name_col = "NAME_E")
}
\arguments{
\item{areas}{sf data.frame of the bio region. You can use \code{MarConsNetData::data_bioregion()} to download the bio region of your choice.}

\item{geom_col}{name of the geometry column}

\item{name_col}{name of a column to obtain in the obis data set}
}
\value{
data.frame
}
\description{
This function obtains OBIS data.
}
\examples{
\dontrun{
bioregion <- data_bioregion()
obis <- data_OBIS(bioregion)
}
}
