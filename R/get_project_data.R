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
   df <- project_snowCrabSurvey(taxize=taxize)
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
} else if (id == "642" | title == "eDNAMetabarcoding") {
    df <- project_eDNAMetabarcoding(taxize=taxize)
  } else if (id == 1491 | title %in% c("optimizingeDNA")) {
    df <- project_optimizingeDNA(taxize=taxize)
  } else if (id == "579" | title == "AZMP") {
    #browser("This is a problem") # FIXME
    df <- project_AZMP(taxize=taxize)
  }
    LIST[[II]] <- df
    }
  names(LIST) <- ids
  return(LIST)
}
