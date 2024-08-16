#' Get Context from Canadian Protected and Conserved Areas
#'
#' This function gets site and network level context for the
#' Canadian protected and conserved areas in the Scotian Shelf bio region.
#'
#' @param type argument of either `site` or `network` indicating which objectives to obtain
#' @param area a name of an area of which to obtain the objectives from. Options include
#' `st_Anns_Bank_MPA`, `musquash_MPA`, `laurentian_Channel_MPA`, `gully_MPA`, `gilbert_MPA`, `eastport_MPA`,
#' `basin_MPA`, `bancsDesAmericains_MPA`, `WEBCA`
#' @importFrom rvest read_html
#' @importFrom httr GET content
#' @export
#'
#' @examples
#' \dontrun{
#' stAnnsBankContext <- data_context(type="site", area="st_Anns_Bank_MPA")
#' }
#'
#' @return a "sf" "dataframe" object
#'
data_context <- function(type=NULL, area="st_Anns_Bank_MPA") {
  if (is.null(type)) {
    stop("Must provide a type argument of either network or site")
  }

  if (!(type %in% c("network", "site"))) {
    stop("Must provide a type argument of either network or site")
  }

  if (!(area %in% c("st_Anns_Bank_MPA", "musquash_MPA", "laurentian_Channel_MPA", "gully_MPA", "gilbert_MPA", "eastport_MPA",
                    "basin_MPA", "bancsDesAmericains_MPA", "WEBCA"))) {
    stop("Area must be either `st_Anns_Bank_MPA`, `musquash_MPA`, `laurentian_Channel_MPA`, `gully_MPA`, `gilbert_MPA`, `eastport_MPA`,
                    `basin_MPA_MPA`, `bancsDesAmericains_MPA` or `WEBCA`")
  }

  if (type == "network") {
    urls <- "https://www.dfo-mpo.gc.ca/oceans/networks-reseaux/scotian-shelf-plateau-neo-ecossais-bay-baie-fundy/development-developpement-eng.html"
  } else if (type == "site") {
    if (area == "st_Anns_Bank_MPA") {
      u <- "stanns-sainteanne"
    } else if (area == "musquash_MPA") {
      u <- "musquash"
    } else if (area == "laurentian_Channel_MPA") {
      u <- "laurentian-laurentien"
    } else if (area == "gully_MPA") {
      u <- "gully"
    } else if (area == "gilbert_MPA") {
      u <- "gilbert"
    } else if (area == "eastport_MPA") {
      u <- "eastport"
    } else if (area == "basin_MPA") {
      u <- "basin-head"
    } else if (area == "bancsDesAmericains_MPA") {
      u <- "american-americains"
    }

    urls <- paste0("https://www.dfo-mpo.gc.ca/oceans/mpa-zpm/",u,"/index-eng.html")

    if (area == "WEBCA") {
      urls <- 'https://www.dfo-mpo.gc.ca/oceans/oecm-amcepz/refuges/westernemerald-emeraudewestern-eng.html'

    }
  } # End Site

  pages <- lapply(urls,read_html)
  response <- lapply(urls, GET)
  lines <- strsplit(content(response[[1]], as="text"), "\n")

  if (type == "site") {
    minLine <- which(grepl("Location", lines[[1]], ignore.case=TRUE))
    if (length(minLine) > 0) {
      minLine <- minLine[1]  # Use only the first occurrence
    }

    maxLine <- which(grepl("Conservation Objectives", lines[[1]], ignore.case=TRUE))
    if (length(maxLine) > 0) {
      maxLine <- maxLine[1] - 1  # Use only the first occurrence and subtract 1
    }

    if (area == "WEBCA") {
      maxLine <- which(grepl("0.18%", lines[[1]]))
    }

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
