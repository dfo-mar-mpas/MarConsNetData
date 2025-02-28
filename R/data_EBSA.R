#' Get Ecologically and Biologically Significant Area Data
#'
#' This function gets the ecologically and biologically significant
#' areas in the specified bio region. For more information see
#' https://open.canada.ca/data/en/dataset/d2d6057f-d7c4-45d9-9fd9
#' -0a58370577e0
#'
#' @param bioregion sf data.frame of the bio region. You can use `MarConsNetData::data_bioregion()` to download the bio region of your choice.
#'
#' @return a "sf" "dataframe" object
#' @export
#'
#' @examples
#' \dontrun{
#' bioregion <- data_bioregion()
#' ebsa <- data_EBSA(bioregion)
#' }
data_EBSA <- function(bioregion){
  arcpullr::get_layer_by_poly("https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/ecologically_and_biologically_significant_areas/MapServer/1",
                              geometry = sf::st_convex_hull(bioregion)) |>
    sf::st_filter(bioregion)
}
