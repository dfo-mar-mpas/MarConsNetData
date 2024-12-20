#' Get data for AZMP (579)
#'
#' This function uses the azmpdata package to get the location of relevant
#' sampling used
#' @param bd bloom_df likely from the targets file
#'
#' @return dataframe
#' @export

project_AZMP <- function(bd = bloom_df) {
  # df1

  df1 <- azmpdata::Discrete_Occupations_Sections
  df1$type <- "ctd"

  # df2

  df2 <- azmpdata::Zooplankton_Annual_Stations
  sdf <- azmpdata::Derived_Occupations_Stations
  df2$latitude <- 0
  df2$longitude <- 0
  for (i in seq_along(unique(df2$station))) {
    df2$latitude[which(df2$station == unique(df2$station)[i])] <- sdf$latitude[which(sdf$station == unique(df2$station)[i])][1]
    df2$longitude[which(df2$station == unique(df2$station)[i])] <- sdf$longitude[which(sdf$station == unique(df2$station)[i])][1]
  }
  df2$type <- "Zooplankton Catches "

  # df3
  df3 <- bd
  df3$type <- "RemoteSensing"

  # df4

  df4 <- azmpdata::Derived_Monthly_Stations
  df4$type <- "sea surface height"
  # Add latitude and longitude
  df4$latitude <- 0
  df4$longitude <- 0
  type <- NULL
  df4$latitude[which(df4$station == "Halifax")] <- 43.5475
  df4$longitude[which(df4$station == "Halifax")] <- 63.5714

  df4$latitude[which(df4$station == "Yarmouth")] <- 43.8377
  df4$longitude[which(df4$station == "Yarmouth")] <- 66.1150

  df4$latitude[which(df4$station == "North Sydney")] <- 46.2051
  df4$longitude[which(df4$station == "North Sydney")] <- 60.2563


  dfs <- list(df1,df2,df3,df4)
  locations <- list()
  for (i in seq_along(dfs)) {
    message(i)
    if (!("geom" %in% names(dfs[[i]]))) {
  latitude <- round(dfs[[i]]$latitude, 2)
  longitude <- round(dfs[[i]]$longitude, 2)
  lat_lon_pairs <- cbind(latitude, longitude)

  # Find unique rows (unique latitude-longitude pairs)
  loc <- as.data.frame(unique(lat_lon_pairs))
  loc$geom <- NA
    } else {
      loc <- data.frame(geom=dfs[[i]]$geom)
      loc$latitude <- 0
      loc$longitude <- 0
    }
  loc$type <- unique(dfs[[i]]$type)
  locations[[i]] <- loc
  }

  locations <- lapply(locations, function(x) x[sort(names(x))])
  locations <- bind_rows(locations)

  return(locations)

}
