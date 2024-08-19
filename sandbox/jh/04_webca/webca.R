library(dataSPA)
om <- getData(type="om", cookie="hi", age=10000)
om <- om[which(om$status == "Approved"),]
projects <- unique(om$project_id[which(grepl("Lindsay Beazley", om$lead_staff, ignore.case=TRUE))])

titles <- NULL
for (i in seq_along(projects)) {
  titles[[i]] <- unique(om$project_title[which(om$project_id == projects[i])])
}

titles <- unlist(titles)

