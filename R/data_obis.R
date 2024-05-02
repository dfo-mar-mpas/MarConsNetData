#' Get Ocean Biodiversity Information System (OBIS) data
#'
#' This function obtains OBIS data.
#'
#' @param areas sf data.frame of the bio region. You can use `MarConsNetData::get_bioregion()` to download the bio region of your choice.
#' @param geom_col name of the geometry column
#' @param name_col name of a column to obtain in the obis data set
#' @return data.frame
#' @export
#' @importFrom rlang .data
#' @importFrom robis occurrence
#' @importFrom dplyr mutate bind_rows select
#' @importFrom sf st_as_sf st_filter
#' @examples
#' \dontrun{
#' bioregion <- data_bioregion()
#' obis <- data_obis(bioregion)
#' }

data_obis <- function(areas, geom_col = "geoms", name_col = "NAME_E"){
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

