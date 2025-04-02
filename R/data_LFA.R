#' Get Lobster Fishing Areas
#'
#' This function pulls information (length, area, shape, etc.) about
#' Lobster Fishing Areas for the Scotian Shelf-Bay of Fundy Bioregion. More information is available at:
#' https://ouvert.canada.ca/data/dataset/b8550fde-fbfe-4556-a592-1ae972834b65
#'
#' @param bioregion name of the bio region to match from the `NAME_E` column from [Open Data](https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0). Default is `"Scotian Shelf"`
#' @param layer integer of the layer from Open Data to query. Defaults to 14 for the current (as of 2022) boundaries. See the
#' [REST server](https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/historical_lobster_fishing_districts_maritimes_region/MapServer/) for additional options
#' @return sf data.frame
#' @importFrom arcpullr get_spatial_layer
#' @export
#'
#' @examples
#' \dontrun{
#' LFA <- data_LFA()
#' }

data_LFA <- function(bioregion = "Scotian Shelf", layer = 14){
  if(bioregion=="Scotian Shelf"){
    bioregion <- arcpullr::get_spatial_layer(
      paste0("https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/historical_lobster_fishing_districts_maritimes_region/MapServer/",layer))
  } else {
    stop("This function does not support the selected bioregion")
  }
}
