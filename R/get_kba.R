#' get_kba
#'
#' @param bioregion sf polygon to constrain query.
#' @param crs target coordinate reference system: object of class crs, or input string for st_crs. Default is that of the bioregion.
#'
#' @return
#' @export
#'
#' @examples
get_kba <- function(bioregion, crs=sf::st_crs(bioregion)){
  arcpullr::get_layer_by_poly("https://maps.birdlife.org/server/rest/services/Hosted/KBAs_View_for_Map_Search/FeatureServer/0",
                              geometry = sf::st_transform(sf::st_convex_hull(bioregion),3857)) |>
    sf::st_transform(crs) |>
    sf::st_filter(bioregion)
}
