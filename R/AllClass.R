# vim:textwidth=128:expandtab:shiftwidth=4:softtabstop=4

#' A Package for Locating and Transforming MPA Data
#'
#' The `MarConsNetData` package is to locate and transform
#' real data collected in a variety of different Marine Protected Areas (MPAs).
#'
#' @importFrom methods new
#' @name MarConsNetData-package
#' @docType _PACKAGE
NULL

#' A look up table for data
#'
#' This data frame includes ids associated with data of projects
#' in the Project Planning Tool that this package has the ability
#' to access. In addition to the ids, the table has titles
#' which can be used for either projects in the PPT or those
#' who do not have an associated id in the PPT. In addition,
#' there is a get_functions column identifying which sub function
#' is used to obtain this data. Lastly, the source column identifies
#' if the data is internal to Department of Fisheries and Oceans
#' Canada (DFO) or external.
#'
#' @examples
#' library(MarConsNetData)
#' data(dataTable)
#' head(dataTable,5)
#' @name dataTable
NULL
