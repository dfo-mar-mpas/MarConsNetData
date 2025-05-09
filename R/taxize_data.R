#' Group species into taxonomic groups
#'
#' This function groups species into taxonomic groups. It is used in the `taxize=TRUE`
#' argument of the `get_project_data` function.
#'
#' @param df data frame to be taxized
#' @importFrom worrms wm_records_name
#' @importFrom worrms wm_classification
#' @export

taxize_data <- function(df=NULL) {
  lat <- lon <- lat_rounded <- lon_rounded <- subphylum <- NULL
  if ("species" %in% names(df)) {
    SPECIES <- unique(df$species)
  } else {
    SPECIES <- names(df)[-(1:2)]
  }

  sKey <- data.frame(species=SPECIES,
                     group=0)
  for (i in seq_along(SPECIES)) {
    s <- SPECIES[i]
    records <- try(worrms::wm_records_name(s),silent = TRUE)
    if (!inherits(records,"try-error")) {
      tN <- try(wm_classification(records$AphiaID[1]))
    } else {
      tN <- try(log("a"))
    }

    # tN <- tax_name(s, get = 'subphylum', db = 'itis',ask=FALSE)$subphylum
    if (!inherits(tN,"try-error")) {
      if (!(tN$scientificname[tN$rank=="Subphylum"] == "Vertebrata")) {
        sKey$group[i] <- tN$scientificname[tN$rank=="Subphylum"]
      } else {
        sKey$group[i] <- tN$scientificname[tN$rank=="Class"]
      }
    } else {
      sKey$group[i] <- "NA"
    }
  }

  sKey$group[which(is.na(sKey$group))] <- "NA"

  if ("species" %in% names(df)) {
    df$subphylum <- 0
    for (i in seq_along(sKey$species)) {
      keep <- which(df$species == sKey$species[i])
      df$subphylum[keep] <- sKey$group[i]
    }
    df <- df[, c("lat", "lon", "subphylum","species")]

    DF<- df %>%
      mutate(lat_rounded = round(lat, 2), lon_rounded = round(lon, 2)) %>%
      group_by(lat_rounded, lon_rounded, subphylum) %>%
      summarise(count = n()) %>%
      pivot_wider(names_from = subphylum, values_from = count, values_fill = 0)
    names(DF)[1:2] <- c("lat", "lon")
  } else {
    names(df) <- c("lat", "lon",sKey$group)
    BU <- NULL
    nas <- unique(names(df))
    for (i in seq_along(nas)) {
      if (!(i %in% c(1,2))) {
        k <- which(names(df) == nas[i])
        #message(paste("For ", i, " the unique name is with length = ", length(unique(names(ASV)[which(names(ASV) == nas[i])]))))
        if (length(k) > 1) {
          BU[[i]] <- rowSums(df[, k])
        } else {
          BU[[i]] <- unlist(unname(df[, k]))
        }
      }
    }

    bu <- BU[-c(1,2)]
    DF <- do.call(cbind, bu)
    DF <- data.frame(Column1 = DF)
    DF <- cbind(lat=df$lat, lon=df$lon, DF)
    names(DF) <- nas

  }

  return(DF)
}
