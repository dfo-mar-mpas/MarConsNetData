#' Get data for the Marine Protected Area App
#'
#' This function obtains information required for the
#' analysis of the Marine Protect Areas (MPAs).
#'
#' @param ids a single or vector of ids of project(s) associated with the Project Planning Tool (PPT)
#' @param titles a character indicating the name of a project. See the table in the vignette for more details.
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
#' @importFrom utils read.csv read.table
#'
#' @return dataframe
#' @examples
#' \dontrun{
#' data <- get_project_data(id=1093, taxize=FALSE)
#' }
#' @author Jaimie Harbin and Remi Daigle
#' @export

get_project_data <- function(ids=NULL, titles=NULL, taxize=FALSE, MPA=NULL) {
  lat_rounded <- lon_rounded <- n <- sab <- site <- subphylum <- NULL
  if (is.null(ids) && is.null(titles)) {
    stop("Must provide aand ids argument")
  }

  if (!(is.null(MPA))) {
  if (!(MPA %in% c('BancDesAmericains', 'basinHead', 'eastport', 'gilbertBay', 'gully',
                   'laurentianChannel', 'musquashEstuary', 'stAnnsBank'))) {
    stop("Must provide a MPA argument of either: 'BancDesAmericains', 'basinHead', 'eastport', 'gilbertBay', 'gully','laurentianChannel', 'musquashEstuary', or 'stAnnsBank'")
  }
  }
  LIST <- NULL
  if (is.null(ids)) {
    NAMES <- titles
  } else {
    NAMES <- ids
  }
  for (II in seq_along(NAMES)) {
    if (is.null(ids)) {
      title <- NAMES[II]
      id <- "test"
    } else {
      id <- NAMES[II]
      title <- "test"
    }
 if (id == 1093 | title == "snowCrabSurvey") {
    load('../stannsbank_mpa/data/CrabSurvey/2023CrabSurveyDat.RData') #FIXME
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
  } else if (title == "diet") {
    # Map
    diet <- read_excel("../SABapp/data/diet/diet.xlsx") #FIXME
    dates <- unique(diet$SDATE)
    species <- diet$PREYSPECCD
    codes <- read.csv("../SABapp/data/diet/GROUNDFISH_GSSPECIES_ANDES_20230901.csv") #FIXME
    df <- diet[, c("SLATDD", "SLONGDD", "PREYSPECCD")]
    df$species <- 0
    for (i in seq_along(df$PREYSPECCD)) {
      if (length(which(codes$SPECCD_ID == df$PREYSPECCD[i])) > 0) {
        df$species[i] <- codes$SPEC[which(codes$SPECCD_ID == df$PREYSPECCD[i])]
      } else {
        df$species[i] <- "NA"
      }
    }
    names(df)[1:2] <- c("lat", "lon")
  } else if (id %in% c("642", "1491") | title %in% c("eDNAMetabarcoding", "optimizingeDNA")) {
    eDNA <- read_excel("../SABapp/data/eDNA/eDNA_WaterSamples_2022.xlsx", sheet = 3) #FIXME
    sampleId <- eDNA$SampleID
    lon <- eDNA$Long
    lonMinutes <- eDNA$...12
    lat <- eDNA$Lat
    latMinutes <- eDNA$...14
    latitude <- lat + (latMinutes / 60)
    longitude <- lon + (lonMinutes/ 60)

    # Read the file using read.table
    if (id == "642" | title == "eDNAMetabarcoding") {
    ASV <- read.table("../SABapp/data/eDNA/16S_FilteredASVtable.txt",header = TRUE, sep = "\t") #FIXME
#HERE
    } else if (id == 1491 | title %in% c("optimizingeDNA")) {
    ASV <- read.table("../SABapp/data/eDNA/COI_FilteredASVtable.txt",header = TRUE, sep = "\t") #FIXME
    names(ASV)[1] <- "Species" #FIXME
    }
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
  }

if (!(is.null(taxize)) && taxize) {
  # if ("species" %in% names(df)) {
  # SPECIES <- unique(df$species)
  # } else {
  #   SPECIES <- names(df)[-(1:2)]
  # }
  # sKey <- data.frame(species=SPECIES,
  #                    group=0)
  # for (i in seq_along(SPECIES)) {
  #   s <- SPECIES[i]
  #   tN <- tax_name(s, get = 'subphylum', db = 'itis',ask=FALSE)$subphylum
  #   if (!(is.na(tN))) {
  #     if (!(tN == "Vertebrata")) {
  #       sKey$group[i] <- tN
  #     } else {
  #       tN <- tax_name(s, get = 'class', db = 'itis',ask=FALSE)$class
  #       sKey$group[i] <- tN
  #     }
  #   } else {
  #     sKey$group[i] <- "NA"
  #   }
  # }
  # sKey$group[which(is.na(sKey$group))] <- "NA"
  #
  # if ("species" %in% names(df)) {
  # df$subphylum <- 0
  # for (i in seq_along(sKey$species)) {
  #   keep <- which(df$species == sKey$species[i])
  #   df$subphylum[keep] <- sKey$group[i]
  # }
  # df <- df[, c("lat", "lon", "subphylum","species")]
  #
  # DF<- df %>%
  #   mutate(lat_rounded = round(lat, 2), lon_rounded = round(lon, 2)) %>%
  #   group_by(lat_rounded, lon_rounded, subphylum) %>%
  #   summarise(count = n()) %>%
  #   pivot_wider(names_from = subphylum, values_from = count, values_fill = 0)
  # names(DF)[1:2] <- c("lat", "lon")
  # } else {
  #   names(df) <- c("lat", "lon",sKey$group)
  #   BU <- NULL
  #   nas <- unique(names(df))
  #   for (i in seq_along(nas)) {
  #     if (!(i %in% c(1,2))) {
  #       k <- which(names(df) == nas[i])
  #       #message(paste("For ", i, " the unique name is with length = ", length(unique(names(ASV)[which(names(ASV) == nas[i])]))))
  #       if (length(k) > 1) {
  #         BU[[i]] <- rowSums(df[, k])
  #       } else {
  #         BU[[i]] <- unlist(unname(df[, k]))
  #       }
  #     }
  #   }
  #
  #   bu <- BU[-c(1,2)]
  #   DF <- do.call(cbind, bu)
  #   DF <- data.frame(Column1 = DF)
  #   DF <- cbind(lat=df$lat, lon=df$lon, DF)
  #   names(DF) <- nas
  #
  #   DF <- cbind(id = id, DF)
  # }
  # LIST[[II]] <- DF
} else {
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
    LIST[[II]] <- df
  }
}
  }
  names(LIST) <- ids
  return(LIST)

}
