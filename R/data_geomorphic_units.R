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
  arcpullr::get_spatial_layer("https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/offshore_ecological_human_use_mpa_scotian_shelf_en/MapServer/125")
}
