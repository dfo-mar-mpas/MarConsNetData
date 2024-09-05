#' Get Marine Spatial Planning Areas Data
#'
#' This function pulls information (length, area, shape, etc.) about
#' [Eastern Canada Marine Spatial Planning Areas](https://open.canada.ca/data/en/dataset/f089a3f3-45e9-47de-b1c4-170e9950d8e7).
#'
#' @param PA name of the planning area to match from the `NAME_E` column from [Open Data ESRI REST](https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Eastern_Canada_Marine_Spatial_Planning_Areas/MapServer/0). Default is `"Scotian Shelf and Bay of Fundy"`
#'
#' @return sf data.frame
#' @importFrom arcpullr get_spatial_layer
#' @export
#'
#' @examples
#' \dontrun{
#' planning_area <- data_planning_areas()
#' }

data_planning_areas <- function(PA = "Scotian Shelf and Bay of Fundy"){
  bioregion <- get_spatial_layer("https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Eastern_Canada_Marine_Spatial_Planning_Areas/MapServer/0",
                                           where=paste0("NAME_E='",PA,"'"))
}
