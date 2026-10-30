#' Return the Maritimes RV Strata (summer survey) layer as an sf object
#'
#' @returns an sf object of the Maritimes RV Strata (summer survey) layer
#' @export
#'
#' @examples
#' \dontrun{
#' strata <- data_rv_strata()
#' }
data_rv_strata <- function() {
  service <- get_COD_url("1366e1f1-e2c8-4905-89ae-e10f1be0a164",
                         "ESRI REST", silent = TRUE)[1]
  url <- get_esri_layer_url(service, "strata")
  arcpullr::get_spatial_layer(url = url)
}
