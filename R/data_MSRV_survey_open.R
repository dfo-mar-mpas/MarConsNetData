#' Download the Maritimes Summer Research Vessel Survey data from open.canada.ca
#'
#' Data is from the csv files on https://open.canada.ca/data/en/dataset/8ddcaeea-b806-4958-a79f-ba9ab645f53b
#'
#' @param survey character string indicating the survey to be downloaded. Defaults to "summer", but can also accept "spring", "fall", and "4VSW"
#'
#' @return list of data.frames
#' @export
#'
#' @examples
#' summer <- data_MarRV_survey_open()
#'
#' fall <- data_MarRV_survey_open(survey="fall")
#'
data_MarRV_survey_open <- function(survey="summer"){
  tmp <- tempfile()
  tmpdir <- tempfile()
  dir.create(tmpdir)

  if(survey=="summer"){
    download.file("https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/1366e1f1-e2c8-4905-89ae-e10f1be0a164/attachments/SUMMER_csv.zip",tmp)
  }else  if(survey=="4VSW"){
    download.file("https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/a851ce30-e216-4d7d-a29c-05631eef140e/attachments/4VSW_csv.zip",tmp)
  }else  if(survey=="fall"){
    download.file("https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/5f82b379-c1e5-4a02-b825-f34fc645a529/attachments/FALL_csv.zip",tmp)
  }else  if(survey=="spring"){
    download.file("https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/fecf045a-95a2-4b69-8a40-818649a62716/attachments/SPRING_csv.zip",tmp)
  }else{
    warning("Other surveys are not yet functional")
  }
  unzip(tmp,exdir = tmpdir)
  files <- list.files(tmpdir,pattern = ".csv",full.names = TRUE)
  files <- files[!grepl("GSDET",files)]
  all <- lapply(files,read.csv)
  names(all) <- gsub(".csv","",basename(files))
  return(all)
}




