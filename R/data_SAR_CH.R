#' Get Species at Risk Critical Habitat Data
#'
#' This function gets the Critical Habitat for Aquatic Species at Risk
#' in the specified bio region. For more information see
#' https://open.canada.ca/data/en/dataset/db177a8c-5d7d-49eb-8290-31e6a45d786c
#'
#' @param bioregion sf data.frame of the bio region. You can use `MarConsNetData::get_bioregion()` to download the bio region of your choice.
#' @importFrom arcpullr get_layer_by_poly
#' @importFrom sf st_convex_hull st_filter
#' @return "sf" "data.frame" object
#' @export
#' @examples
#' \dontrun{
#' bioregion <- data_bioregion()
#' SARCH <- data_SAR_CH(bioregion)
#' }
data_SAR_CH <- function(bioregion){
  arcpullr::get_layer_by_poly("https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/dfo_sara_critical_habitat/MapServer/0",
                              geometry = sf::st_convex_hull(sf::st_transform(bioregion,3857))) |>
    sf::st_filter(bioregion)
}
