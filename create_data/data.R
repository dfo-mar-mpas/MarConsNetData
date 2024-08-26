id <- c(1093, 642, 1491, 579)
df <- data.frame(matrix(ncol = length(c("id", "title", "get_function", "source")), nrow = length(id)))
colnames(df) <- c("id", "title", "get_function", "source")
df$title <- c("snowCrabSurvey", "eDNAMetabarcoding", "optimizingeDNA", "AZMP")
df$get_function <- c("project_snowCrabSurvey", "project_eDNAMetabarcoding", "project_optimizingeDNA", "project_AZMP")
df$source <- c("internal", "internal", "internal","internal")
df$id <- id
dataTable <- df
save(dataTable, file="./data/dataTable.rda")
