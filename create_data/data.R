id <- c(1093, 642, 1491)
df <- data.frame(matrix(ncol = length(c("id", "title", "get_function", "source")), nrow = length(id)))
colnames(df) <- c("id", "title", "get_function", "source")
df$title <- c("snowCrabSurvey", "eDNAMetabarcoding", "optimizingeDNA")
df$get_function <- c("get_snowCrabSurvey", "get_eDNAMetabarcoding", "get_optimizingeDNA")
df$source <- c("internal", "internal", "internal")
df$id <- id
dataTable <- df
save(dataTable, file="./data/dataTable.rda")
