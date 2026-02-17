#' Get Bio Region Information Data
#'
#' This function pulls information (length, area, shape, etc.) about
#' number of bio regions. For a list of available options visit
#' https://open.canada.ca/data/en/dataset/23eb8b56-dac8-4efc-be7c-b8fa11ba62e9
#'
#' @param bioregion name of the bio region to match from the `NAME_E` column from [Open Data](https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/federal_marine_bioregions_bioregions_marines_federales/MapServer/0) or one of the Ocean Basins to return multiple bioregions (i.e. "Atlantic", "Arctic", or "Pacific) or "All" to return all available bioregions. Default is `"Scotian Shelf"`
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
  if("Atlantic" %in% bioregion) {
    bioregion <- unique(c(bioregion[bioregion!="Atlantic"],
                          "Scotian Shelf",
                          "Newfoundland-Labrador Shelves",
                          "Gulf of Saint Lawrence",
                          "Saint-Pierre et Miquelon"))
  }

  if("Arctic" %in% bioregion) {
    bioregion <- unique(c(bioregion[bioregion!="Arctic"],
                          "Arctic Basin",
                          "Eastern Arctic",
                          "Arctic Archipelago",
                          "Hudson Bay Complex",
                          "Western Arctic"))
  }

  if("Pacific" %in% bioregion) {
    bioregion <- unique(c(bioregion[bioregion!="Pacific"],
                          "Offshore Pacific",
                          "Northern Shelf",
                          "Southern Shelf",
                          "Strait of Georgia"))
  }

  if(length(bioregion)>1) {
    w <- paste0(paste0("(NAME_E='",bioregion,"')"),collapse = "OR")
  } else if(bioregion=="All"){
    w <- "1=1"
  } else {
    w <- paste0("NAME_E='",bioregion,"'")
  }


  bioregion <- get_spatial_layer("https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/federal_marine_bioregions_bioregions_marines_federales/MapServer/0",
                                           where=w)
}
