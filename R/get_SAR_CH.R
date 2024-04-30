#' get_SAR_CH
#'
#' @param bioregion sf polygon to constrain query.
#'
#' @return
#' @export
#'
#' @examples
get_SAR_CH <- function(bioregion){
  arcpullr::get_layer_by_poly("https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/DFO_SARA_CriticalHabitat/MapServer/0",
                              geometry = sf::st_convex_hull(bioregion)) |>
    sf::st_filter(bioregion)
}
