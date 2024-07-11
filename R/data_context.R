#' Get Context from Canadian Protected and Conserved Areas
#'
#' This function gets site and network level context for the
#' Canadian protected and conserved areas in the Scotian Shelf bio region.
#'
#' @param type argument of either `site` or `network` indicating which objectives to obtain
#' @param area a name of an area of which to obtain the objectives from. Options include
#' `stAnnsBank`, `musquash`, `laurentianChannel`, `gully`, `gilbert`, `eastport`,
#' `basinHead`, `bancsDesAmericains`
#' @importFrom rvest read_html
#' @importFrom httr GET content
#' @export
#'
#' @examples
#' \dontrun{
#' stAnnsBankContext <- data_context(type="site", area="stAnnsBank")
#' }
#'
#' @return a "sf" "dataframe" object
#'
data_context <- function(type=NULL, area="stAnnsBank") {
  if (is.null(type)) {
    stop("Must provide a type argument of either network or site")
  }

  if (!(type %in% c("network", "site"))) {
    stop("Must provide a type argument of either network or site")
  }

  if (!(area %in% c("stAnnsBank", "musquash", "laurentianChannel", "gully", "gilbert", "eastport",
                    "basinHead", "bancsDesAmericains"))) {
    stop("Area must be either `stAnnsBank`, `musquash`, `laurentianChannel`, `gully`, `gilbert`, `eastport`,
                    `basinHead`, `bancsDesAmericains`")
  }

  if (type == "network") {
    urls <- "https://www.dfo-mpo.gc.ca/oceans/networks-reseaux/scotian-shelf-plateau-neo-ecossais-bay-baie-fundy/development-developpement-eng.html"
  } else if (type == "site") {
    if (area == "stAnnsBank") {
      u <- "stanns-sainteanne"
    } else if (area == "musquash") {
      u <- "musquash"
    } else if (area == "laurentianChannel") {
      u <- "laurentian-laurentien"
    } else if (area == "gully") {
      u <- "gully"
    } else if (area == "gilbert") {
      u <- "gilbert"
    } else if (area == "eastport") {
      u <- "eastport"
    } else if (area == "basinHead") {
      u <- "basin-head"
    } else if (area == "bancsDesAmericains") {
      u <- "american-americains"
    }

    urls <- paste0("https://www.dfo-mpo.gc.ca/oceans/mpa-zpm/",u,"/index-eng.html")
  } # End Site

  #The BIG 3

  pages <- lapply(urls,read_html)
  response <- lapply(urls, GET)
  lines <- strsplit(content(response[[1]], as="text"), "\n")

  if (type == "site") {
    minLine <- which(grepl("Location", lines[[1]], ignore.case=TRUE))
    maxLine <- which(grepl("Conservation Objectives", lines[[1]], ignore.case=TRUE))[1]-1

  final <- lines[[1]][minLine:maxLine]



    final <- sub("^(.*)<[^<]*$", "\\1", final) # Remove everything after the last <
    final <- sub("^[^>]*>", "", final) # remove everything before first >


  } else if (type == "network") {
    minLine <- which(grepl("Creating the network plan", lines[[1]],ignore.case = TRUE))+1
    maxLine <- which(grepl("Setting conservation objectives", lines[[1]], ignore.case = TRUE))-1

    final <- lines[[1]][minLine:maxLine]

    final <- sub("^(.*)<[^<]*$", "\\1", final) # Remove everything after the last <
    final <- sub("^[^>]*>", "", final) # remove everything before first >
  }

    if (any(final == "        ")) {
       final <- final[-which(final == "        ")]
  }

  #final <- sapply(final, function(x) paste0("- ", x, "\n"))

  return(final)
}
