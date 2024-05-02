#' Get Bio Region Information Data
#'
#' This function pulls information (length, area, shape, etc.) about
#' number of bio regions. For a list of available options visit
#' https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0
#'
#' @param bioregion name of the bio region to match from the `NAME_E` column from [Open Data](https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0). Default is `"Scotian Shelf"`
#'
#' @return sf data.frame
#' @importFrom arcpullr get_spatial_layer
#' @export
#'
#' @examples
#' \dontrun{
#' bioregion <- data_bioregion()
#' }

data_bioregion <- function(bioregion = "Scotian Shelf"){
  bioregion <- arcpullr::get_spatial_layer("https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0",
                                           where=paste0("NAME_E='",bioregion,"'"))
}
