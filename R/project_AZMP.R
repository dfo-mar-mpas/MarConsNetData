#' Get data for AZMP (579)
#'
#' This function uses the azmpdata package to get the location of relevant
#' sampling used
#'
#' @return dataframe
#' @importFrom dplyr distinct
#' @export

project_AZMP <- function() {
  # Data Frame 1

  df1 <- azmpdata::Discrete_Occupations_Sections
  df1$type <- "AZMP"

  # Data Frame 2

  df2 <- azmpdata::Zooplankton_Annual_Stations
  sdf <- azmpdata::Derived_Occupations_Stations
  df2$latitude <- 0
  df2$longitude <- 0
  for (i in seq_along(unique(df2$station))) {
    df2$latitude[which(df2$station == unique(df2$station)[i])] <- sdf$latitude[which(sdf$station == unique(df2$station)[i])][1]
    df2$longitude[which(df2$station == unique(df2$station)[i])] <- sdf$longitude[which(sdf$station == unique(df2$station)[i])][1]
  }
  df2$type <- "Zooplankton AZMP"

  # Data Frame 3

  script_lines <- readLines("https://raw.githubusercontent.com/BIO-RSG/PhytoFit/refs/heads/master/tools/tools_01a_define_polygons.R")

  k1 <- which(grepl("poly\\$atlantic = list", script_lines))
  k2 <- which(grepl("-61.1957, -61.1957, -59.54983, -59.54983, -61.1957", script_lines))
  script <- script_lines[k1:k2]
  poly <- list()
  eval(parse(text=script))

  DF <- list()
  DF[[1]] <- poly$atlantic$AZMP$CS_V02
  DF[[2]] <- poly$atlantic$AZMP$ESS_V02
  DF[[3]] <- poly$atlantic$AZMP$CSS_V02
  DF[[4]] <- poly$atlantic$AZMP$WSS_V02
  DF[[5]] <- poly$atlantic$AZMP$GB_V02
  DF[[6]] <- poly$atlantic$AZMP$LS_V02

  dfNames <- c("CS_remote_sensing", "ESS_remote_sensing", "CSS_remote_sensing", "WSS_remote_sensing",
  "GB_remote_sensing", "LS_remote_sensing")
  names(DF) <- dfNames


  df <- azmpdata::RemoteSensing_Annual_Broadscale
  df$geom <- 0

  for (i in seq_along(dfNames)) {
    #message(i)
  coords <- matrix(c(DF[[i]]$lon, DF[[i]]$lat), ncol = 2, byrow = FALSE)
  coords <- rbind(coords, coords[1,])
  polygon_sf <- st_sfc(st_polygon(list(coords)))
  df$geom[which(df$area == dfNames[i])] <- polygon_sf
  }

  df3 <- df
  df3$type <- "Remote Sensing"
  df3 <- df3 %>%
    distinct(area, .keep_all = TRUE)

  # Data Frame 4

  df4 <- azmpdata::Derived_Monthly_Stations
  df4$type <- "derived (AZMP)"
  # Add latitude and longitude
  df4$latitude <- 0
  df4$longitude <- 0
  type <- NULL
  df4$latitude[which(df4$station == "Halifax")] <- 43.5475
  df4$longitude[which(df4$station == "Halifax")] <- -63.5714

  df4$latitude[which(df4$station == "Yarmouth")] <- 43.8377
  df4$longitude[which(df4$station == "Yarmouth")] <- -66.1150

  df4$latitude[which(df4$station == "North Sydney")] <- 46.2051
  df4$longitude[which(df4$station == "North Sydney")] <- -60.2563


  dfs <- list(df1,df2,df3,df4)
  locations <- list()
  for (i in seq_along(dfs)) {
    #message(i)
    if (!("geom" %in% names(dfs[[i]]))) {
  latitude <- round(dfs[[i]]$latitude, 2)
  longitude <- round(dfs[[i]]$longitude, 2)
  lat_lon_pairs <- cbind(latitude, longitude)

  # Find unique rows (unique latitude-longitude pairs)
  loc <- as.data.frame(unique(lat_lon_pairs))
    } else {
      #browser()
      loc <- data.frame(latitude=rep(0, length(df3[,c("geom")])), longitude=0)
      loc <- st_sf(loc, geometry = st_sfc(df3[,c("geom")]))

    }
  loc$type <- unique(dfs[[i]]$type)
  locations[[i]] <- loc
  }



  # TEST
  empty_geometry <- st_sfc(list(
    st_polygon(list())
  ))

  for (i in seq_along(locations)) {
    if (!("sf" %in% class(locations[[i]]))) {
      rownames(locations[[i]]) <- NULL
    locations[[i]] <- suppressWarnings(st_sf(locations[[i]], geometry = empty_geometry))
    }
  }
  # END TEST

  locations <- lapply(locations, function(x) x[sort(names(x))])

  locations <- bind_rows(locations)

  locations$latitude[which(locations$latitude == 0)] <- NA
  locations$longitude[which(locations$longitude == 0)] <- NA


  return(locations)

}
