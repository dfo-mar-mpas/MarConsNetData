#' Get Biophysical Units Data
#'
#' This function obtains information (lenght, area, etc.) of smaller regions
#' in the Scotian shelf that are classified using the "Greenlaw classification"
#' system. For more information visit Open Data at
#' https://open.canada.ca/data/en/dataset/2d9cce9a-d634-4b49-879f-87c40c52acf2
#'
#' @importFrom arcpullr get_spatial_layer
#' @return sf dataframe
#' @export
#'
#' @examples
#' \dontrun{
#' biophys <- data_biophysical_units()
#' }
data_biophysical_units <- function(){
  arcpullr::get_spatial_layer("https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/offshore_ecological_human_use_mpa_scotian_shelf_en/MapServer/124")
}
