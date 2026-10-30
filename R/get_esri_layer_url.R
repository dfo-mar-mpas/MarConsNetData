
#' Find a layer URL in an ArcGIS REST service by (partial) layer name
#'
#' @param service_url character string of the ArcGIS REST service URL (e.g., "https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/maritimes_summer_research_vessel_survey_en/MapServer")
#' @param pattern character string to match against layer names
#' @param ignore.case logical, whether to ignore case when matching layer names (default: TRUE)
#'
#' @returns
#' @export
#'
#' @examples
#'
#' rest_url <- get_COD_url(uuid="14d55ea5-b17d-478c-b9ee-6a7c04439d2b","ESRI REST")
#' clusterlayers_url <- get_esri_layer_url(rest_url[1], "cluster")
#' clusters <- arcpullr::get_spatial_layer(clusterlayers_url)
get_esri_layer_url <- function(service_url, pattern, ignore.case = TRUE) {
  service_url <- sub("/+$", "", service_url)

  info <- httr2::request(service_url) |>
    httr2::req_url_query(f = "json") |>
    httr2::req_perform() |>
    httr2::resp_body_json(check_type = FALSE)  # ArcGIS often returns text/plain

  if (!is.null(info$error)) {
    stop("ArcGIS error: ", info$error$message)
  }
  if (length(info$layers) == 0) {
    stop("No layers found at ", service_url)
  }

  ids   <- vapply(info$layers, function(l) as.integer(l$id), integer(1))
  names <- vapply(info$layers, function(l) as.character(l$name), character(1))

  hit <- grepl(pattern, names, ignore.case = ignore.case)

  if (!any(hit)) {
    stop("No layer matching '", pattern, "'. Available layers:\n",
         paste0(ids, ": ", names, collapse = "\n"))
  }
  if (sum(hit) > 1) {
    warning("Multiple layers matched '", pattern, "': ",
            paste(names[hit], collapse = ", "), ". Using the first.")
  }

  paste0(service_url, "/", ids[hit][1])
}

