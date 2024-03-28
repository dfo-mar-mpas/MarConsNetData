#' get_obis_data
#'
#' @param areas
#'
#' @return data.frame
#' @export
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' obis <- testPowerBI::getobisdata()
#' }

get_obis_data <- function(areas, geom_col = "geoms", name_col = "NAME_E"){
  obis_occ <- apply(areas,1,function(a){
    occ <- robis::occurrence(geometry = sf::st_as_text(sf::st_as_sfc(sf::st_bbox(a[[geom_col]])))) |>
      dplyr::mutate(CPCAP_NAME_E = a[[name_col]])
    return(occ)
  }) |>
    dplyr::bind_rows() |>
    sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
                 crs = 4326,
                 remove = FALSE) |>
    sf::st_filter(areas[[geom_col]]) |>
    as.data.frame() |>
    dplyr::select(-"geometry")

}

