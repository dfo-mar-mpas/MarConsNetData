#' Get Key Biological Areas (KBA) Data
#'
#' @param bioregion sf data.frame of the bio region. You can use `MarConsNetData::data_bioregion()` to download the bio region of your choice.
#' @param crs target coordinate reference system: object of class crs, or input string for st_crs. Default is that of the bioregion.
#' @importFrom arcpullr get_layer_by_poly
#' @importFrom sf st_transform st_filter
#' @return "sf" "data.frame" object
#' @export
#'
#' @examples
#' \dontrun{
#' bioregion <- data_bioregion()
#' kba <- data_KBA(bioregion)
#' }
data_KBA <- function(bioregion, crs=sf::st_crs(bioregion)){
  arcpullr::get_layer_by_poly("https://maps.birdlife.org/server/rest/services/Hosted/KBAs_View_for_Map_Search/FeatureServer/0",
                              geometry = sf::st_transform(sf::st_convex_hull(bioregion),3857)) |>
    sf::st_transform(crs) |>
    sf::st_filter(bioregion)
}
