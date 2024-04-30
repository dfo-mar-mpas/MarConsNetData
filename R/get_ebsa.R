#' get_ebsa
#'
#' @param bioregion sf polygon to constrain query.
#'
#' @return
#' @export
#'
#' @examples
get_ebsa <- function(bioregion){
  arcpullr::get_layer_by_poly("https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Ecologically_and_Biologically_Significant_Areas/MapServer/0",
                              geometry = sf::st_convex_hull(bioregion)) |>
    sf::st_filter(bioregion)
}
