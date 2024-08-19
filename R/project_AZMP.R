#' Get data for AZMP (579)
#'
#' This function gets the CTD data from the fall and spring
#' surveys as well as the fixed stations and ground fish CTD
#' data.
#'
#' @param type character vector of either fall or spring. If fall is given
#' the data from the fall program is returned. If spring is given the
#' CTD data from the spring program is returned. If summer or winter
#' is given, the CTD ground fish data is given from the respective
#' season.
#'
#' @importFrom XML read_html
#'
#' @return A list of NetCDF files downloaded in your destdir
#' @export

project_AZMP <- function(type="fall", destdir="~/data/AZMP/") {
  if (is.null(type)) {
    stop("Must provide a type argument of either fall, spring, summer, or fall")
  }

  if (!(type %in% c("fall", "spring", "summer", "winter"))) {
    stop("Must provide a type argument of either fall, spring, summer, or winter")
  }

  destdir <- paste0(destdir, type)
  dataTable <- NULL
  load(file.path(system.file(package="MarConsNetData"),"data", "dataTable.rda"))
  id <- dataTable$id[which(dataTable$get_function == sys.call()[[1]])]

  if (type %in% c("fall", "spring")) {
    url <- "https://cioosatlantic.ca/erddap/files/bio_atlantic_zone_monitoring_program_ctd/"
  } else {
    url <- "https://cioosatlantic.ca/erddap/files/bio_maritimes_region_ecosystem_survey_ctd/"
  }


  if (type == "fall") {
    u <- "Atlantic%20Zone%20Monitoring%20Program%20Fall/"
  } else if (type == "spring") {
    u <- "Atlantic%20Zone%20Monitoring%20Program%20Spring/"
  } else if (type == "summer") {
    u <- "Maritimes%20Region%20Ecosystem%20Survey%20Summer/"
  } else if (type == "winter") {
    u <- "Maritimes%20Region%20Ecosystem%20Survey%20Winter/"
  }

  url <- paste0(url, u)

  page <- read_html(url)

  dir_names <- page %>%
    html_nodes("a") %>%            # Select all the links
    html_attr("href") %>%          # Get the href attribute
    .[grepl("/$", .)]              # Filter to keep only directories (ending with /)

  # Remove the parent directory link (../) and keep only directories with 4-digit names
  dir_names <- dir_names[grepl("^\\d{4}/$", dir_names)]

  # Remove the trailing slash
  dir_names <- sub("/$", "", dir_names)

  for (dir in dir_names) {
    # Create a folder with the directory name in the destination directory
    dir_path <- file.path(destdir, dir)
    if (!dir.exists(dir_path)) {
      dir.create(dir_path, recursive = TRUE)
    }

    # Construct the URL for the specific directory
    dir_url <- paste0(url, dir, "/")

    # Read the HTML content of the directory
    dir_page <- read_html(dir_url)

    # Extract the ODF file names
    odf_files <- dir_page %>%
      html_nodes("a") %>%
      html_attr("href") %>%
      .[grepl("\\.nc$", .)]  # Adjust if the extension differs

    # Download each ODF file
    for (file in odf_files) {
      file_url <- paste0(dir_url, file)
      file_dest <- file.path(dir_path, file)

      # Download the file
      GET(file_url, write_disk(file_dest, overwrite = TRUE))
    }
  }

}
