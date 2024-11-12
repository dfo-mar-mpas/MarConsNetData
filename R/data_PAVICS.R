#' Get climate data
#'
#' Get data from [PAVICS]("https://pavics.ouranos.ca/index.html") THREDDS [catalog](https://pavics.ouranos.ca/thredds/catalog.html)
#'
#' @param OPENDAP_url character string for an OPENDAP url from the THREDDS [catalog](https://pavics.ouranos.ca/thredds/catalog.html). Defaults to "https://pavics.ouranos.ca/twitcher/ows/proxy/thredds/dodsC/datasets/simulations/RCM-CMIP6/CORDEX/NAM-12/day/NAM-12_NorESM2-MM_historical_r1i1p1f1_OURANOS_CRCM5_v1-r1_day_19500101-20141231.ncml"
#' @param first_date character string for the first date to be included in the data subset. Defaults to "1950-01-01"
#' @param end_date character string for the last date to be included in the data subset. Defaults to "1950-01-01"
#' @param geom sf data.frame used to limit the spatial extent of the data subset (via bounding box). Defaults to the Scotian Shelf and Bay of Fundy planning area
#' @param variable character string for the variable to query from the data. Defaults to "tas" for Near-Surface Air Temperature. See the OPENDAP url for more options
#'
#' @return matrix
#' @export
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
                        geom = data_planning_areas()){

  # Open netCDF
  nc_data <- nc_open(OPENDAP_url)

  # Get time variable and conver dates
  time <- ncvar_get(nc_data, "time")

  base_date <- as.Date(sub("days since ", "", nc_data$dim$time$units))

  startday <- (as.numeric(format(as.Date(first_date), "%Y")) * 365 +
                  as.numeric(format(as.Date(first_date), "%j")) - 1) -
    (as.numeric(format(base_date, "%Y")) * 365 +
       as.numeric(format(base_date, "%j")) - 1)

  endday <- (as.numeric(format(as.Date(end_date), "%Y")) * 365 +
                as.numeric(format(as.Date(end_date), "%j")) - 1) -
    (as.numeric(format(base_date, "%Y")) * 365 +
       as.numeric(format(base_date, "%j")) - 1)

  #  Get the indices of relevant times
  time_indices <- which(time >= startday & time <= endday+0.5)

  # Get latitude and longitude variables
  lat <- ncvar_get(nc_data, "lat")
  lon <- ncvar_get(nc_data, "lon")

  # Extract the bounding box from 'geom'
  bbox <- st_bbox(geom)

  # Create logical matrices to filter points within the bounding box
  lat_within_bbox <- lat >= bbox["ymin"] & lat <= bbox["ymax"]
  lon_within_bbox <- lon >= bbox["xmin"] & lon <= bbox["xmax"]

  # Get the indices of points within the bounding box
  lat_lon_indices <- which(lat_within_bbox & lon_within_bbox, arr.ind = TRUE)



  # Extract subset for a given variable
  data_subset <- ncvar_get(nc_data, variable,
                           start = c(min(lat_lon_indices[,1]),
                                     min(lat_lon_indices[,2]),
                                     min(time_indices)),
                           count = c(max(lat_lon_indices[,1])-min(lat_lon_indices[,1]),
                                     max(lat_lon_indices[,2])-min(lat_lon_indices[,2]),
                                     max(time_indices)-min(time_indices)+1))

  # Close the NetCDF connection
  nc_close(nc_data)
  data_subset
}
