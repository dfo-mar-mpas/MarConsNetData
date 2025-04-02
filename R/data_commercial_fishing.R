#' Get Eastern Canada Commercial Fishing data
#'
#' This function gets the "All Species" dataset of species/gear type commercial fisheries from 2012 to 2021 in the Eastern Canada Regions in the specified bio region. For more
#' information visit
#' https://open.canada.ca/data/dataset/502da2ef-bffa-4d9b-9e9c-a7425ff3c594
#'
#' @param region sf data.frame of the bio region. You can use `MarConsNetData::data_planning_area()` to download the planning area of your choice.
#'
#' @importFrom arcpullr get_layer_by_poly
#' @importFrom sf st_convex_hull st_filter st_make_valid st_as_sf
#' @importFrom dplyr group_by reframe
#' @export
#'
#' @examples
#' \dontrun{
#' planning <- data_planning_areas()
#' fishing <- data_commercial_fishing(planning)
#' }
#'
#' @return a "sf" "dataframe" object

data_commercial_fishing <- function(region){
  validregion <- sf::st_make_valid(region)

  get_layer_by_poly("https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/eastern_canadian_commercial_fishing/MapServer/1",
                              sf::st_convex_hull(validregion)) |>
    sf::st_filter(validregion) |>
    sf::st_make_valid()
}
