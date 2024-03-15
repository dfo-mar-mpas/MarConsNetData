#' getobisdata
#'
#' @param bioregion name of the bioregion to match from the `NAME_E` column of: https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' obis <- testPowerBI::getobisdata()
#' }

getobisdata <- function(bioregion = "Scotian Shelf"){
  bioregion <- arcpullr::get_spatial_layer("https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0",
                                           where=paste0("NAME_E='",bioregion,"'"))

  areas <-  arcpullr::get_layer_by_poly("https://maps-cartes.ec.gc.ca/arcgis/rest/services/CWS_SCF/CPCAD/MapServer/0",
                              sf::st_convex_hull(bioregion),
                              where="BIOME='M'") |>
    sf::st_filter(bioregion) |>
    sf::st_make_valid()

  grouped_areas <- areas |>
    dplyr::group_by(NAME_E) |>
    dplyr::reframe(geoms=sf::st_union(geoms)) |>
    sf::st_as_sf() |>
    sf::st_make_valid()


  obis_occ <- lapply(grouped_areas$NAME_E,function(name){
    print(name)
    occ <- robis::occurrence(geometry = sf::st_as_text(sf::st_as_sfc(sf::st_bbox(grouped_areas[grouped_areas$NAME_E==name,])))) |>
      dplyr::mutate(CPCAP_NAME_E = grouped_areas$NAME_E[grouped_areas$NAME_E==name])
    return(occ)
  }) |>
    dplyr::bind_rows() |>
    sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
                 crs = 4326,
                 remove = FALSE) |>
    sf::st_filter(grouped_areas$geoms) |>
    as.data.frame() |>
    dplyr::select(-geometry)

}

