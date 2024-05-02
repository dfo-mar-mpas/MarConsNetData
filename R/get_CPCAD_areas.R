#' Title
#'
#' @param bioregion sf data.frame of the bioregion. You can use `MarConsNetData::get_bioregion()` to download the bioregion of your choice.
#' @param zones logical that indicates if zones should be returned (`TRUE`) or, as default, unioned (`FALSE`). If zones is `FALSE`, the sf data.frame is grouped by `NAME_E` and the geoms are unioned resulting in a complete loss of other columns.
#'
#' @importFrom arcpullr get_layer_by_poly
#' @importFrom sf st_convex_hull st_filter st_make_valid st_as_sf
#' @importFrom dplyr group_by reframe reframe
#' @export
#'
#' @examples
#' bioregion <- get_bioregion()
#' MPAs <- get_CPCAD_areas(bioregions,  zones = FALSE)
#'
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
