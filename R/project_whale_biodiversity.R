#' Obtain Whale Sighting data
#'
#' @return a data frame containing number of whale sightings per year for WEBCA
#' @export
project_whale_biodiversity <- function() {

files <- list.files(file.path(Sys.getenv("OneDriveCommercial"),"MarConsNetTargets","data", "whale"), full.names = TRUE)

f2 <- read.csv(files[2])
year <- strsplit(f2$ws_date, "-")
year <- unlist(lapply(year, function(x) x[1]))
f2$year <- year
f2$type <- "Whale sighting"

return(f2)
}
