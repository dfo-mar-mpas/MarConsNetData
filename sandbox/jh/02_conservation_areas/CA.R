CA <- data_draft_areas()
CA <- as.data.frame(CA)

names <- c("fundian", "eastern shore islands", "Passamaquoddy", "Unama", "horse", "jordan basin", "central", "pems", "inner bay of fundy", "mary")

KEEP <- NULL
for (i in seq_along(names)) {
  if (any(grepl(names[i], CA$SiteName_E, ignore.case=TRUE))) {
    KEEP[[i]] <- which(grepl(names[i], CA$SiteName_E, ignore.case=TRUE))
    message("i = ", i," ", CA$SiteName_E[keep], "\n")
  } else {
    message("i = ",i, " NO MATCHES FOR ", names[i], "\n")
    KEEP[[i]] <- NULL
  }
}




names(KEEP) <- names

keep <- sort(unlist(unname(KEEP)))

CA <- CA[keep,]

col <- palette.colors(n=length(CA$SiteName_E))

map <- leaflet() %>%
  addTiles()

for (i in seq_along(CA$geoms)) {
sfc_multipolygon <- st_sfc(CA$geoms[i])
sf_object <- st_as_sf(sfc_multipolygon)
sf_object$name <- CA$SiteName_E[i]
map <- map %>%
  addPolygons(data = sf_object, color = unname(col[i]), weight = 1, opacity = 1.0, fillOpacity = 0.5, label=~name)
#addPolygons(data = sf_object, color = "blue", weight = 1, opacity = 1.0, fillOpacity = 0.5, label=~name)

}

map <- map %>%
  addLegend(position="bottomleft", colors = unname(col), labels = CA$SiteName_E, title = "Conservation Areas", opacity = 1, labFormat = labelFormat())


map
