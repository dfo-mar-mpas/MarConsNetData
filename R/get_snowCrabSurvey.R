#' Get data for the snow crab survey
#'
#' This function obtains the species counts identified with the snow crab survey
#'
#' @param taxize a Boolean indicating if the data frame names should
#' be categorized by subphylum. If `FALSE` the species names will be
#' given. Note that if the subphylum is "Vertabrae" the class will be
#' given instead
#' @param MPA the name of an MPA in Atlantic Canada. Options include
#' `BancDesAmericains`, `basinHead`, `eastport`, `gilbertBay`, `gully`,
#' `laurentianChannel`, `musquashEstuary`, or `stAnnsBank`. If `NULL`
#' all data plotted
#'
#' @importFrom readxl read_excel
#' @importFrom magrittr %>%
#' @importFrom tidyr pivot_wider
#' @importFrom dplyr summarise count group_by mutate mutate_all n
#' @importFrom taxize tax_name
#' @importFrom MarConsNetAnalysis taxize_data
#' @importFrom utils read.csv read.table
#'
#' @return dataframe
#' @examples
#' \dontrun{
#' data <- get_snowCrabSurvey(taxize=TRUE)
#' }

get_snowCrabSurvey <- function(taxize=FALSE, MPA=NULL) {
  load('../stannsbank_mpa/data/CrabSurvey/2023CrabSurveyDat.RData') #FIXME
  id <- 1093 # Note this is hard coded
  df <- sab[,c("LONGITUDE", "LATITUDE", "SPEC", "COMM", "year")]
  df <- df[-(which(is.na(df$SPEC))),]
  df$SPEC[which(df$SPEC == "")] <- 0
  df$LONGITUDE <- -(round(df$LONGITUDE,2))
  df$LATITUDE <- round(df$LATITUDE, 2)
  names(df) <- c("lon", "lat", "species", "common", "year")

  df$site <- paste(df$lon, df$lat, sep=",")
  DF <- df[c("site", "species")]

  DF$site <- trimws(DF$site)  # Remove leading and trailing whitespaces

  # Convert species column to factor
  DF$species <- as.factor(DF$species)

  # Count occurrences of each species at each site
  counts_df <- DF %>%
    group_by(site, species) %>%
    summarise(count = n()) %>%
    pivot_wider(names_from = species, values_from = count, values_fill = 0)

  # Rename columns
  colnames(counts_df)[-1] <- levels(DF$species)
  df <- counts_df[,-2] #removing "0"
  df$lon <- as.numeric(sapply(strsplit(as.character(df$site), ","), "[", 1))
  df$lat <- as.numeric(sapply(strsplit(as.character(df$site), ","), "[", 2))
  df <- df[,-1] #removing "0"
  df <- df[c(which(names(df) == "lat"), which(names(df) == "lon"), setdiff(1:ncol(df), c(which(names(df) == "lat"), which(names(df) == "lon"))))]

  if (!(is.null(taxize)) && taxize) {
    df <- MarConsNetAnalysis::taxize_data(df)
    df <- cbind(id = id, df)
  } else {
    # Not taxize

    if ("species" %in% names(df)) {
      df$species[which(df$species == "")] <- "NA"
      DF2<- df %>%
        mutate(lat_rounded = round(lat, 2), lon_rounded = round(lon, 2)) %>%
        group_by(lat_rounded, lon_rounded, species)%>%
        summarise(count = n())%>%
        pivot_wider(names_from = species, values_from = count, values_fill = 0)
      DF2 <- cbind(id = id, DF2)
      LIST[[II]] <- DF2
    } else {
      df <- cbind(id = id, df)
    }
  }
  return(df)
}
