#' Get Objectives from Canadian Protected and Conserved Areas
#'
#' This function gets site and network level objectives for the
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
#' stAnnsBankObjectives <- data_objectives(type="site", area="st_Anns_Bank_MPA")
#' }
#'
#' @return a "sf" "dataframe" object
#'
data_objectives <- function(type=NULL, area="St. Anns Bank Marine Protected Area") {
  if (is.null(type)) {
    stop("Must provide a type argument of either network or site")
  }

  if (!(type %in% c("network", "site"))) {
    stop("Must provide a type argument of either network or site")
  }

  if (type == "network") {
    urls <- "https://www.dfo-mpo.gc.ca/oceans/networks-reseaux/scotian-shelf-plateau-neo-ecossais-bay-baie-fundy/development-developpement-eng.html"
  } else if (type == "site") {
    if (area == "Western/Emerald Banks Conservation Area (Restricted Fisheries Zone)") {
      urls <- 'https://www.dfo-mpo.gc.ca/oceans/oecm-amcepz/refuges/westernemerald-emeraudewestern-eng.html'
    } else {
      if (area == "St. Anns Bank Marine Protected Area") {
        u <- "stanns-sainteanne"
      } else if (area == "Musquash Estuary, Private Land Component" ) {
        u <- "musquash"
      } else if (area == "Laurentian Channel Marine Protected Area") {
        u <- "laurentian-laurentien"
      } else if (area == "Gully Marine Protected Area") {
        u <- "gully"
      } else {
        return(NULL)
      }
      # else if (area == "bancsDesAmericains_MPA") {
      #   u <- "american-americains"
      # }

      urls <- paste0("https://www.dfo-mpo.gc.ca/oceans/mpa-zpm/",u,"/index-eng.html")
    }

  } # End Site

  pages <- lapply(urls,read_html)
  response <- lapply(urls, GET)
  lines <- strsplit(content(response[[1]], as="text"), "\n")

  if (type == "site") {
    minLine <- which(grepl("Conservation Objectives", lines[[1]]))+1
    maxLine <- which(grepl("Prohibitions", lines[[1]]))-1

    # Unique for bansDesAmericains
    # if (area == "bancsDesAmericains_MPA") {
    #   minLine <- which(lines[[1]] == "    <p>The conservation objectives for the Banc-des-Am\u00e9ricains Marine Protected are to:</p>\r")+2
    #   maxLine <- which(grepl("These objectives promote", lines[[1]]))-2
    # } else

    if (area == "Western/Emerald Banks Conservation Area (Restricted Fisheries Zone)" ) {
      minLine <- which(grepl("support", lines[[1]], ignore.case=TRUE))[1]
      maxLine <- which(grepl("support", lines[[1]], ignore.case=TRUE))[2]
    }

    final <- lines[[1]][minLine:maxLine]
    if (any(final == "        </ul>\r" )) {
      final <- final[-which(final == "        </ul>\r")]
    }
    if (any(final == "        <ul>\r")) {
      final <- final[-which(final == "        <ul>\r")]
    }

    if (any(final == "          <ul>\r")) {
      final <- final[-which(final == "          <ul>\r")]
    }

    if (any(final == "          </ul>\r")) {
      final <- final[-which(final == "          </ul>\r")]
    }

    final <- sub("^(.*)<[^<]*$", "\\1", final) # Remove everything after the last <
    final <- sub("^[^>]*>", "", final) # remove everything before first >

    if (any(final == "          ")) {
      final <- final[-which(final == "          ")]
    }

    if (any(final == "            ")) {
      final <- final[-which(final == "            ")]
    }

    if (any(final == "    ")) {
      final <- final[-which(final == "    ")]
    }
  } else if (type == "network") {
    minLine <- which(grepl("The objectives for the conservation", lines[[1]],ignore.case = TRUE))+2
    maxLine <- which(grepl("Selecting conservation priorities", lines[[1]], ignore.case = TRUE))-2
    final <- lines[[1]][minLine:maxLine]

    final <- sub("^(.*)<[^<]*$", "\\1", final) # Remove everything after the last <
    final <- sub("^[^>]*>", "", final) # remove everything before first >
  }


  if (area == "Western/Emerald Banks Conservation Area (Restricted Fisheries Zone)") {
    if (length(final) == 2) {
      source(file.path(Sys.getenv("OneDriveCommercial"),"MarConsNetTargets","data", "site_objectives", "webca.R"))
      final <- c(final, CO3)
    }
  }

  final <- paste0("-", final, "\n")


  return(final)
}
