#' Get data for AZMP (579)
#'
#' This function gets the CTD data from the fall and spring
#' surveys as well as the fixed stations and ground fish CTD
#' data.
#'
#' @param season character vector of either fall or spring. If fall is given
#' the data from the fall program is returned. If spring is given the
#' CTD data from the spring program is returned. If summer or winter
#' is given, the CTD ground fish data is given from the respective
#' season.
#' @param destdir a directory indicating where to save the fetched data.
#' @param force A boolean indicating if a new version of this data should
#' be obtained or not
#'
#' @importFrom XML read_html
#' @importFrom rvest html_attr
#' @importFrom httr write_disk
#' @importFrom oce numberAsPOSIXct as.ctd
#' @importFrom ncdf4 nc_open ncvar_get
#'
#' @return A list of NetCDF files downloaded in your destdir
#' @export

project_AZMP <- function(season="fall", destdir="tmp", force=FALSE) {
  if (is.null(season)) {
    stop("Must provide a type argument of either fall, spring, summer, fall, or all")
  }

  if (!(all(season %in% c("fall", "spring", "summer", "winter", "all")))) {
    stop("Must provide a type argument of either fall, spring, summer, winter or all")
  }

  if (all(season== "all")) {
    TYPE <- c("fall", "summer", "spring", "winter")
  } else {
    TYPE <- season
  }


  if (!(file.exists("~/data/AZMP/CTDdf.rda")) | force) {
  if (destdir == "tmp") {
    destdir <- tempfile()
  }
  CTD <- vector("list", length(TYPE))
  names(CTD) <- TYPE

  for (i in seq_along(TYPE)) {
  type <- TYPE[i]
  destdir <- paste0(destdir, type)
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

  years <- page %>%
    html_nodes("a") %>%            # Select all the links
    html_attr("href") %>%          # Get the href attribute
    .[grepl("/$", .)]              # Filter to keep only directories (ending with /)



  # Remove the parent directory link (../) and keep only directories with 4-digit names
  years <- years[grepl("^\\d{4}/$", years)]

  # Remove the trailing slash
  years <- sub("/$", "", years)

  CTD[[i]] <- vector("list", length(years))
  names(CTD[[i]]) <- years
  for (y in seq_along(years)) {
    # Create a folder with the directory name in the destination directory
    y_path <- file.path(destdir, years[[y]])
    if (!dir.exists(y_path)) {
      dir.create(y_path, recursive = TRUE)
    }

    # Construct the URL for the specific directory
    y_url <- paste0(url, years[[y]], "/")

    # Read the HTML content of the directory
    y_page <- read_html(y_url)

    # Extract the ODF file names
    odf_files <- y_page %>%
      html_nodes("a") %>%
      html_attr("href") %>%
      .[grepl("\\.nc$", .)]  # Adjust if the extension differs

    CTD[[i]][[y]] <- vector("list", length(odf_files))
    names(CTD[[i]][[y]]) <- odf_files


    # Download each ODF file
    for (file in seq_along(odf_files)) {
      message("file = ", file)
      file_url <- paste0(y_url, odf_files[[file]])
      file_dest <- file.path(y_path, odf_files[[file]])

      # Download the file
      GET(file_url, write_disk(file_dest, overwrite = TRUE))
      nc <- try(nc_open(file_dest), silent=TRUE)
      if (!(inherits(nc, "try-error"))) {
        if ("PRESPR01" %in% names(nc$var)) {
          pressure <- ncvar_get(nc, "PRESPR01")
        } else {
          pressure <- 0
        }
      if ("TEMPPR01" %in% names(nc$var)) {
        temperature <- ncvar_get(nc, "TEMPPR01")
      } else {
      temperature <- ncvar_get(nc, "TEMPP901")
      }
      salinity <- ncvar_get(nc, "PSALST01")
      longitude <- ncvar_get(nc, "longitude")
      latitude <- ncvar_get(nc, "latitude")
      time <- numberAsPOSIXct(ncvar_get(nc, "time"))
      if (!(length(unique(pressure)) == 1)) {
      ctd <- as.ctd(pressure=pressure, temperature=temperature, salinity=salinity,
                    longitude=longitude, latitude=latitude, time=time)
      ctd@metadata$filename <- odf_files[file]
      } else {
        CTD[[i]][[y]][file] <- 0
      }

      CTD[[i]][[y]][file] <- ctd
      } else {
        CTD[[i]][[y]][file] <- 0
      }
    }
  }

} # End of all
  #browser()

  save(CTD, file=paste0("~/data/AZMP/CTD.rda"))
  longitude <- CTD
  latitude <- CTD
  for (a in seq_along(CTD)) {
    for (j in seq_along(CTD[[a]])) {
      for (k in seq_along(CTD[[a]][[j]])) {
        longitude[[a]][[j]][k] <- CTD[[a]][[j]][k][[1]][['longitude']]
        latitude[[a]][[j]][k] <- CTD[[a]][[j]][k][[1]][['latitude']]
      }
    }
  }

  df <- data.frame(latitude=unname(unlist(latitude)), longitude=unname(unlist(longitude)))
  save(df, file=paste0("~/data/AZMP/CTDdf.rda"))

  } else {
    load(paste0("~/data/AZMP/CTDdf.rda"))
  }
  return(df)

}
