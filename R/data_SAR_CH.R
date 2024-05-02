#' Get Species at Risk Critical Habitat Data
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
  arcpullr::get_layer_by_poly("https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/DFO_SARA_CriticalHabitat/MapServer/0",
                              geometry = sf::st_convex_hull(sf::st_transform(bioregion,3857))) |>
    sf::st_filter(bioregion)
}
