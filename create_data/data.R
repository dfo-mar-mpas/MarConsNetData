id <- c(1093, 642, 1491, 428, 579, 726, 1062)
df <- data.frame(matrix(ncol = length(c("id", "title", "get_function", "package", "source")), nrow = length(id)))
colnames(df) <- c("id", "title", "get_function","package", "source")
df$title <- c("snowCrabSurvey", "eDNAMetabarcoding", "optimizingeDNA", "argoProgram", "AZMP", "rvSurvey", "whaleSightings")
df$get_function <- c("project_snowCrabSurvey", "project_eDNAMetabarcoding", "project_optimizingeDNA", "getIndex", "project_AZMP", "TARGET::rv_rounded_location", "project_whale_sighting")
df$package <- c("MarConsNetData", "MarConsNetData","MarConsNetData","argoFloats", "MarConsNetData", "Mar.datawrangling", "MarConsNetData")
df$source <- c("internal", "internal", "internal","internal", "internal", "internal", "internal")
df$id <- id
dataTable <- df
save(dataTable, file="./data/dataTable.rda")



