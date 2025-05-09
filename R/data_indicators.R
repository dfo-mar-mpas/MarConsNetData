#' Get Monitoring Indicators
#'
#' This function obtains a list of indicators from the monitoring framework for
#' St. Anns Bank Area of Interest paper and the Ecosystem Based Management paper.
#'
#' @param area Character string for the protected area
#'
#' @importFrom pdftools pdf_text
#' @export
#'
#' @examples
#' \dontrun{
#' indicators <- data_indicators()
#' }
#'
#' @return a "sf" "dataframe" object
#'
data_indicators <- function(area="st_anns_bank") {

  if (area == "st_anns_bank") {

  url <- "https://waves-vagues.dfo-mpo.gc.ca/library-bibliotheque/361257.pdf"
  pdf_text <- pdf_text(url)

  lines <- NULL
  for (i in seq_along(pdf_text)) {
    lines[[i]] <- strsplit(pdf_text[i], "\n")[[1]]
  }

  lines <- unlist(lines)

  minLine <- which(grepl("MONITORING INDICATORS", lines))
  maxLine <- which(grepl("RATIONALES FOR INDICATORS", lines))
  final <- lines[minLine:maxLine]
  indicators <- grep("^[0-9]+\\)", final, value = TRUE)
  indicators <- sub("^[0-9]+\\)\\s+", "", indicators) # keep everything after space. I.e remove 1)
  }
  df <- data.frame(indicators=indicators, area=rep(area, length(indicators)))
  return(df)
}
