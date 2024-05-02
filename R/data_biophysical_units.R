#' Get Biophysical Units Data
#'
#' This function obtains information (lenght, area, etc.) of smaller regions
#' in the Scotian shelf that are classified using the "Greenlaw classification"
#' system. For more information visit Open Data at
#' https://open.canada.ca/data/en/dataset/abbfe250-8202-4822-8bd1-aaaf393bbfd5
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
  arcpullr::get_spatial_layer("https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Offshore_Ecological_Human_Use_MPA_Scotian_Shelf_En/MapServer/124")
}
