#' Get Canadian Protected and Conserved Areas Database
#'
#' This function gets polygons of the the Canadian protected
#' and conserved areas in the specified bio region. For more
#' information visit
#' https://www.canada.ca/en/environment-climate-change/services/
#' national-wildlife-areas/protected-conserved-areas-database.html
#'
#' @param bioregion sf data.frame of the bio region. You can use `MarConsNetData::get_bioregion()` to download the bio region of your choice.
#' @param zones logical that indicates if zones should be returned (`TRUE`) or, as default, unioned (`FALSE`). If zones is `FALSE`, the sf data.frame is grouped by `NAME_E` and the geoms are unioned resulting in a complete loss of other columns.
#'
#' @importFrom arcpullr get_layer_by_poly
#' @importFrom sf st_convex_hull st_filter st_make_valid st_as_sf
#' @importFrom dplyr group_by reframe reframe
#' @export
#'
#' @examples
#' \dontrun{
#' bioregion <- data_bioregion()
#' MPAs <- data_CPCAD_areas(bioregion,  zones = FALSE)
#' }
#'
#' @return a "sf" "dataframe" object

data_CPCAD_areas <- function(bioregion, zones = FALSE){
  areas <- get_layer_by_poly("https://maps-cartes.ec.gc.ca/arcgis/rest/services/CWS_SCF/CPCAD/MapServer/0",
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
