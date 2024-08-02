#' Extract species lists from DFO website
#'
#' @param status character string that determines which list is returned. Default is "At-Risk", but "Invasive","","Special Concern",and "all" are also valid options.
#'
#' @return a dataframe
#' @export
#'
#' @examples
#' # get Aquatic Invasive Species list
#' AIS <- data_DFO_sp_lists(status="Invasive")
#'
#' # get Species at Risk list
#' SARA <- data_DFO_sp_lists(status="At-Risk")
data_DFO_sp_lists <- function(status="At-Risk"){
  # get json table from the website
  json_data <- httr::GET("https://www.dfo-mpo.gc.ca/species-especes/includes/json/identify.json") |>
    httr::content(as = "text")

  # extract dataframe and unnest variables
  sp_lists <- as.data.frame(jsonlite::fromJSON(json_data)) |>
    tidyr::unnest(c(data.name,
                    data.profile.url,
                    data.avatar,
                    data.group,
                    data.region,
                    data.status),
                  names_sep = "_") |>
    tidyr::unnest(c(data.status_general,
                    data.status_sara,
                    data.status_cosewic),
                  names_sep = "_")

  if(status=="all"){
    return(sp_lists)
  } else if(status %in% c("At-Risk","Invasive","","Special Concern")){
    return(sp_lists[sp_lists$data.status_general_english==status,])
  } else {
    warning(paste(status,"is not a valid status argument for data_DFO_sp_lists(). Returning all lists"))
    return(sp_lists)
  }
}

