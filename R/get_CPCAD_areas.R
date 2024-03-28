#' Title
#'
#' @param bioregion sf data.frame of the bioregion. You can use `MarConsNetData::get_bioregion()` to download the bioregion of your choice.
#' @param zones logical that indicates if zones should be returned (`TRUE`) or, as default, unioned (`FALSE`). If zones is `FALSE`, the sf data.frame is grouped by `NAME_E` and the geoms are unioned resulting in a complete loss of other columns.
#'
#' @return
#' @export
#'
#' @examples
get_CPCAD_areas <- function(bioregion, zones = FALSE){
  areas <- arcpullr::get_layer_by_poly("https://maps-cartes.ec.gc.ca/arcgis/rest/services/CWS_SCF/CPCAD/MapServer/0",
                              sf::st_convex_hull(bioregion),
                              where="BIOME='M'") |>
    sf::st_filter(bioregion) |>
    sf::st_make_valid()

  if(zones){
    return(areas)
  } else {
    return(areas |>
      dplyr::group_by(.data$NAME_E) |>
      dplyr::reframe(geoms=sf::st_union(.data$geoms)) |>
      sf::st_as_sf() |>
      sf::st_make_valid())
  }
}
