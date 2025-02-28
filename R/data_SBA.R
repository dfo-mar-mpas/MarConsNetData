#' Get Coral and Sponge Significant Benthic Areas in Eastern Canada (2016) Data
#'
#' This function gets the Coral and Sponge Significant Benthic Areas
#' in the specified region. For more information see
#' https://open.canada.ca/data/en/dataset/6af357a3-3be1-47d5-9d1f-e4f809c4c903
#'
#' @param region sf data.frame of the region. You can use `MarConsNetData::data_planning_areas()` to download the region of your choice.
#'
#' @return a "sf" "dataframe" object
#' @export
#'
#' @examples
#' \dontrun{
#' region <- data_planning_areas()
#' sba <- data_SBA(region)
#' }
data_SBA <- function(region){
  arcpullr::get_layer_by_poly("https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/sbas_coral_sponge_2016_en/MapServer/0",
                              geometry = sf::st_convex_hull(region)) |>
    st_make_valid() |>
    sf::st_filter(region)
}
