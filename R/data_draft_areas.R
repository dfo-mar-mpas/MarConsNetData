#' Get draft conservation network sites
#'
#' This function pulls information (length, area, shape, etc.) about
#' draft conservation network sites for the Scotian Shelf-Bay of Fundy Bioregion. More information is available at:
#' https://open.canada.ca/data/en/dataset/bb048082-bc05-4588-b4f0-492b1f1b8737
#'
#' @param bioregion name of the bio region to match from the `NAME_E` column from [Open Data](https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0). Default is `"Scotian Shelf"`
#'
#' @return sf data.frame
#' @importFrom arcpullr get_spatial_layer
#' @export
#'
#' @examples
#' \dontrun{
#' draftareas <- data_draft_areas()
#' }

data_draft_areas <- function(bioregion = "Scotian Shelf"){
  if(bioregion=="Scotian Shelf"){
    bioregion <- arcpullr::get_spatial_layer("https://gist.dfo-mpo.gc.ca/arcgis/rest/services/Maritimes/Draft_Conservation_Network_Sites/MapServer/")
  } else {
    stop("This function does not support the selected bioregion")
  }
}
