#' Get Geomorphic Unit Data
#'
#' This function gets the geomorphic unit information of the Scotian Shelf.
#' This is based on the Greenlaw classification system.
#'
#' @return sf dataframe object
#' @importFrom arcpullr get_spatial_layer
#' @export
#'
#' @examples
#' \dontrun{
#' geomorph <- data_geomorphic_units()
#' }
data_geomorphic_units <- function(){
  arcpullr::get_spatial_layer("https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Offshore_Ecological_Human_Use_MPA_Scotian_Shelf_En/MapServer/125")
}
