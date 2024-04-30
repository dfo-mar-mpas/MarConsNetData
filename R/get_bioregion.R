#' get_bioregion
#'
#' @param bioregion name of the bioregion to match from the `NAME_E` column from [Open Data](https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0). Default is `"Scotian Shelf"`
#'
#' @return sf data.frame
#' @importFrom arcpullr get_spatial_layer
#' @export
#'
#' @examples
#' bioregion <- get_bioregion()
get_bioregion <- function(bioregion = "Scotian Shelf"){
  bioregion <- arcpullr::get_spatial_layer("https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0",
                                           where=paste0("NAME_E='",bioregion,"'"))
}
