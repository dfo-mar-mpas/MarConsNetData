#' Get climate data
#'
#' Get data from [PAVICS]("https://pavics.ouranos.ca/index.html") THREDDS [catalog](https://pavics.ouranos.ca/thredds/catalog.html)
#'
#' @param OPENDAP_url character string for an OPENDAP url from the THREDDS [catalog](https://pavics.ouranos.ca/thredds/catalog.html). Defaults to "https://pavics.ouranos.ca/twitcher/ows/proxy/thredds/dodsC/datasets/simulations/RCM-CMIP6/CORDEX/NAM-12/day/NAM-12_NorESM2-MM_historical_r1i1p1f1_OURANOS_CRCM5_v1-r1_day_19500101-20141231.ncml"
#' @param first_date character string for the first date to be included in the data subset. Defaults to "1950-01-01"
#' @param end_date character string for the last date to be included in the data subset. Defaults to "1950-01-01"
#' @param geom sf data.frame used to limit the spatial extent of the data subset (via bounding box). Defaults to the Scotian Shelf and Bay of Fundy planning area
#' @param variable character string for the variable to query from the data. Defaults to "tas" for Near-Surface Air Temperature. See the OPENDAP url for more options
#' @param maskGeom logical defaults to TRUE to turn values outside the `geom` to NA instead of returning all the values that are downloaded as is.
#'
#' @return matrix
#' @export
#' @importFrom ncdf4 nc_open
#' @importFrom ncdf4 ncvar_get
#' @importFrom ncdf4 ncatt_get
#' @importFrom ncdf4 nc_close
#' @importFrom stars read_ncdf
#' @importFrom sf st_crs
#' @importFrom sf
#' @importFrom PCICt as.PCICt
#'
#' @examples
#' require(MarConsNetData)
#' ssbof <- data_planning_areas()
#' climate <- data_PAVICS
#' image(apply(climate,c(1,2),mean))
#'
data_PAVICS <- function(OPENDAP_url = "https://pavics.ouranos.ca/twitcher/ows/proxy/thredds/dodsC/datasets/simulations/RCM-CMIP6/CORDEX/NAM-12/day/NAM-12_NorESM2-MM_historical_r1i1p1f1_OURANOS_CRCM5_v1-r1_day_19500101-20141231.ncml",
                        first_date = "1950-01-01",
                        end_date = "1951-01-1",
                        variable = "tas",
                        geom = data_planning_areas(),
                        maskGeom = TRUE){

  # Open netCDF
  nc_data <- nc_open(OPENDAP_url)

  # Get time variable and conver dates
  time <- ncvar_get(nc_data, "time")

  if(grepl("days since ",nc_data$dim$time$units)){
    base_date <- as.Date(sub("days since ", "", nc_data$dim$time$units))
  } else {
    stop("This function is only designed to handle daily data.")
  }

  if("noleap" == nc_data$dim$time$calendar){
    startday <- (as.numeric(format(as.Date(first_date), "%Y")) * 365 +
                   as.numeric(format(as.Date(first_date), "%j")) - 1) -
      (as.numeric(format(base_date, "%Y")) * 365 +
         as.numeric(format(base_date, "%j")) - 1)

    endday <- (as.numeric(format(as.Date(end_date), "%Y")) * 365 +
                 as.numeric(format(as.Date(end_date), "%j")) - 1) -
      (as.numeric(format(base_date, "%Y")) * 365 +
         as.numeric(format(base_date, "%j")) - 1)
  } else if ("standard" == nc_data$dim$time$calendar) {
    startday <- as.numeric(as.Date(first_date) - base_date)

    endday <- as.numeric(as.Date(end_date) - base_date)
  }  else if ("proleptic_gregorian" == nc_data$dim$time$calendar) {
    startday <- as.numeric(difftime(as.PCICt(first_date, cal = "proleptic_gregorian"),
                                    as.PCICt(as.character(base_date), cal = "proleptic_gregorian"),
                                    "days"))

    endday <- as.numeric(difftime(as.PCICt(end_date, cal = "proleptic_gregorian"),
                                  as.PCICt(as.character(base_date), cal = "proleptic_gregorian"),
                                  "days"))
  } else {
    stop(paste0("This function is not designed to handle this calendar type:",nc_data$dim$time$calendar))
  }


  #  Get the indices of relevant times
  time_indices <- which(time >= startday & time <= endday+0.5)

  # Get latitude and longitude variables
  lat <- ncvar_get(nc_data, "lat")
  lon <- ncvar_get(nc_data, "lon")

  if(length(dim(lat))==1){

    # Extract the bounding box from 'geom'
    bbox <- st_bbox(st_transform(geom,4326))

    # Create logical matrices to filter points within the bounding box
    lat_within_bbox <- which(lat >= bbox["ymin"] & lat <= bbox["ymax"])
    lon_within_bbox <- which(lon >= bbox["xmin"] & lon <= bbox["xmax"])

    # Extract subset for a given variable
    ncsub <- cbind(start = c(min(lon_within_bbox),
                             min(lat_within_bbox),
                             min(time_indices)),
                   count = c(max(lon_within_bbox)-min(lon_within_bbox)+1,
                             max(lat_within_bbox)-min(lat_within_bbox)+1,
                             max(time_indices)-min(time_indices)+1))

     data_subset <- read_ncdf(OPENDAP_url,
                             var = variable,
                             ncsub = ncsub)
  } else {
    pointsgeom <- data.frame(
      lat = as.vector(lat),
      lon = as.vector(lon),
      row = rep(1:nrow(lat), times = ncol(lat)),
      col = rep(1:ncol(lat), each = nrow(lat))
    ) |>
      sf::st_as_sf(coords = c("lon", "lat"),
                   crs = 4326,
                   remove = FALSE) |>
      st_transform(st_crs(geom)) |>
      st_filter(geom)


    lat_lon_indices <- as.data.frame(pointsgeom[c("row","col")])



    # Extract subset for a given variable
    ncsub <- cbind(start = c(min(lat_lon_indices[,1]),
                             min(lon_within_bbox),
                             min(time_indices)),
                   count = c(max(lat_lon_indices[,1])-min(lat_lon_indices[,1])+1,
                             max(lat_lon_indices[,2])-min(lat_lon_indices[,2])+1,
                             max(time_indices)-min(time_indices)+1))

    data_subset <- read_ncdf(OPENDAP_url,
                             curvilinear = c("lat","lon"),
                             var = variable,
                             ncsub = ncsub)
  }




  st_crs(data_subset) <- 4326


  # Close the NetCDF connection
  nc_close(nc_data)
  if(maskGeom){
    data_subset[st_transform(geom,st_crs(data_subset))] |> st_transform(st_crs(geom))
  } else {
    data_subset |> st_transform(st_crs(geom))
  }

}
