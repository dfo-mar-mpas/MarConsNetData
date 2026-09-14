#' Get Canadian Open Data (COD) resource URL by extension
#'
#' @param uuid universally unique identifier of the dataset in the https://open.canada.ca/ portal (e.g., "2d9cce9a-d634-4b49-879f-87c40c52acf2")
#' @param ext desired file extension (e.g., "csv", "json", "xlsx")
#'
#' @returns A character vector of URLs for resources matching the specified extension.
#'
#' @export
#'
#' @examples
#' url <- get_COD_url("2d9cce9a-d634-4b49-879f-87c40c52acf2", "csv")
#' datadict <- read.csv(url)
get_COD_url <- function(uuid, ext) {
  message(paste0("Searching for resources with extension '", ext, "' in on https://open.canada.ca/data/en/dataset/", uuid))
  api_url <- sprintf("https://open.canada.ca/data/api/action/package_show?id=%s",
                     uuid)

  resp <- httr2::request(api_url) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  if (!isTRUE(resp$success)) {
    stop("CKAN API call failed for dataset ", uuid)
  }

  resources <- resp$result$resources
  urls <- vapply(resources, function(r) {
    if (is.null(r$url)) NA_character_ else r$url
  }, character(1))

  ext_pattern <- paste0("\\.", sub("^\\.", "", ext), "$")
  idx <- grep(ext_pattern, urls, ignore.case = TRUE)

  if (length(idx) == 0) {
    stop("No resource with extension '", ext, "' found. Available URLs:\n",
         paste(urls, collapse = "\n"))
  }
  if (length(idx) > 1) {
    warning("Multiple resources matched extension '", ext, "'; returning all matches.")
  }

  urls[idx]
}



