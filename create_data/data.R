id <- c(1093, 642, 1491, 428)
df <- data.frame(matrix(ncol = length(c("id", "title", "get_function", "package", "source")), nrow = length(id)))
colnames(df) <- c("id", "title", "get_function","package", "source")
df$title <- c("snowCrabSurvey", "eDNAMetabarcoding", "optimizingeDNA", "argoProgram")
df$get_function <- c("project_snowCrabSurvey", "project_eDNAMetabarcoding", "project_optimizingeDNA", "getIndex")
df$package <- c("MarConsNetData", "MarConsNetData","MarConsNetData","argoFloats")
df$source <- c("internal", "internal", "internal","internal")
df$id <- id
dataTable <- df
save(dataTable, file="./data/dataTable.rda")
