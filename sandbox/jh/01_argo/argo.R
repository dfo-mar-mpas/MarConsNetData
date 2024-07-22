library(argoFloats)
library(sf)
library(oce)
library(ocedata)
library(arcpullr)
data(coastlineWorldFine)
ai <- getIndex("core")
bgc <- getIndex("bgc")
index <- subset(ai, rectangle=list(longitude=c(-70,-55), latitude=c(40,50)))
index2 <- subset(bgc, rectangle=list(longitude=c(-70,-55), latitude=c(40,50)))
index3 <- subset(index, deep=TRUE) # no deep argo

bioregion <- data_bioregion()
MPAs <- data_CPCAD_areas(bioregion,  zones = FALSE)
source("../MarConsNetApp/R/getLatLon.R")
s <- getLatLon(MPAs)
par(mar=c(3, 3, 1, 1))
# Current MPAs
mapPlot(coastlineWorldFine, latitudelim =c(40,50), longitudelim=c(-70,-55), col="tan",  projection="+proj=merc")
mapPoints(latitude = index[["latitude"]], longitude=index[["longitude"]], col="lightblue")
for (i in seq_along(s)) {
  ss <- s[[i]]
  mapPolygon(longitude=ss$lng, latitude=ss$lat, col=rgb(1, 0, 0, alpha = 0.5))
}

# Draft Areas
draftAreas <- data_draft_areas()
s <- getLatLon(draftAreas)
mapPlot(coastlineWorldFine, latitudelim =c(40,50), longitudelim=c(-70,-55), col="tan",  projection="+proj=merc")
mapPoints(latitude = index[["latitude"]], longitude=index[["longitude"]], col="lightblue")
mapPoints(latitude = index2[["latitude"]], longitude=index2[["longitude"]], col="green", pch=20)

for (i in seq_along(s)) {
  ss <- s[[i]]
  mapPolygon(longitude=ss$lng, latitude=ss$lat, col=rgb(1, 0, 0, alpha = 0.5))
}
legend("topright", c("Core", "BGC"), col=c("lightblue", "green"), pch=c(20,20))




