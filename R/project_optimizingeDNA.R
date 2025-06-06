#' Get data for the optimizing eDNA survey (1491)
#'
#' This function obtains the species counts identified with the
#' optimizing eDNA survey.
#'
#' @param taxize a Boolean indicating if the data frame names should
#' be categorized by subphylum. If `FALSE` the species names will be
#' given. Note that if the subphylum is "Vertabrae" the class will be
#' given instead
#' @param MPA the name of an MPA in Atlantic Canada. Options include
#' `BancDesAmericains`, `basinHead`, `eastport`, `gilbertBay`, `gully`,
#' `laurentianChannel`, `musquashEstuary`, or `stAnnsBank`. If `NULL`
#' all data plotted
#' @export
#' @importFrom readxl read_excel
#' @importFrom magrittr %>%
#' @importFrom tidyr pivot_wider
#' @importFrom dplyr summarise count group_by mutate mutate_all n
#' @importFrom utils read.csv read.table

project_optimizingeDNA <- function(taxize=FALSE, MPA=NULL) {
  dataTable <- lat_rounded <- lon_rounded <- species <- NULL

  load(file.path(system.file(package="MarConsNetData"),"data", "dataTable.rda"))
  id <- dataTable$id[which(dataTable$get_function == sys.call()[[1]])]
  eDNA <- read_excel("C:/Users/HarbinJ/Documents/GitHub/SABapp/data/eDNA/eDNA_WaterSamples_2022.xlsx", sheet = 3) #FIXME
  sampleId <- eDNA$SampleID
  lon <- eDNA$Long
  lonMinutes <- eDNA$...12
  lat <- eDNA$Lat
  latMinutes <- eDNA$...14
  latitude <- lat + (latMinutes / 60)
  longitude <- lon + (lonMinutes/ 60)

  ASV <- read.table("C:/Users/HarbinJ/Documents/GitHub/SABapp/data/eDNA/COI_FilteredASVtable.txt",header = TRUE, sep = "\t") #FIXME
  names(ASV)[1] <- "Species" #FIXME

  if ("Other eukaryotes" %in% ASV$Species) {
    ASV <- ASV[-which(ASV$Species == "Other eukaryotes"),]
  }

  NAMES <- substr(names(ASV), 2, nchar(names(ASV))) # removing x
  NAMES <- NAMES[-which(NAMES == "pecies")]

  latlon <- NULL
  for (i in seq_along(NAMES)) {
    keep <- which(sampleId == NAMES[i])
    latlon[[i]] <- paste0(round(latitude[keep],2),",",round(longitude[keep],2))
  }

  names(ASV) <- c("Species", unlist(latlon))
  BU <- NULL
  nas <- unique(names(ASV))
  for (i in seq_along(nas)) {
    if (!(i == 1)) {
      k <- which(names(ASV) == nas[i])
      if (length(k) > 1) {
        BU[[i]] <- rowSums(ASV[, k])
      } else {
        BU[[i]] <- ASV[,k]
      }
    }
  }

  # Now each BU is a column of a unique lat/lon. Now bind them.
  bu <- BU[-1]
  df <- do.call(cbind, bu)
  df <- data.frame(Column1 = df)
  df <- cbind(Species = ASV$Species, df)
  names(df) <- unique(names(ASV))
  df <- df %>% mutate_all(~ ifelse(. != 0, 1, 0))
  df$Species <- ASV$Species

  DF <- as.data.frame(t(df[, -1]))
  names(DF) <- trimws(df$Species)

  lat <- as.numeric(sub(",.*", "", rownames(DF)))
  lon <- as.numeric(sub(".*,(.*)", "\\1", rownames(DF)))*-1
  df <- cbind(lat = lat, lon=lon, DF)
  rownames(df) <- NULL



  if (!(is.null(taxize)) && taxize) {
    df <- taxize_data(df)
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
      #LIST[[II]] <- DF2
    } else {
      df <- cbind(id = id, df)
    }
  }
  names(df)[which(names(df) == "lat")] <- "latitude"
  names(df)[which(names(df) == "lon")] <- "longitude"
  df$type <- "eDNA Sampling"
  return(df)

}
