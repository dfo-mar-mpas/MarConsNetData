#' Get Objectives from Canadian Protected and Conserved Areas
#'
#' This function gets site and network level objectives for the
#' Canadian protected and conserved areas in the Scotian Shelf bio region.
#'
#' @param type argument of either `site` or `network` indicating which objectives to obtain
#' @param area a name of an area of which to obtain the objectives from. Options include
#' `st_Anns_Bank_MPA`, `musquash_MPA`, `laurentian_Channel_MPA`, `gully_MPA`, `gilbert_MPA`, `eastport_MPA`,
#' `basin_MPA`, `bancsDesAmericains_MPA`
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
data_objectives <- function(type=NULL, area="st_Anns_Bank_MPA") {
  if (is.null(type)) {
    stop("Must provide a type argument of either network or site")
  }

  if (!(type %in% c("network", "site"))) {
    stop("Must provide a type argument of either network or site")
  }

  if (!(area %in% c("st_Anns_Bank_MPA", "musquash_MPA", "laurentian_Channel_MPA", "gully_MPA", "gilbert_MPA", "eastport_MPA",
                    "basin_MPA", "bancsDesAmericains_MPA"))) {
    stop("Area must be either `st_Anns_Bank_MPA`, `musquash_MPA`, `laurentian_Channel_MPA`, `gully_MPA`, `gilbert_MPA`, `eastport_MPA`,
                    `basin_MPA`, `bancsDesAmericains_MPA`")
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
  } # End Site

#The BIG 3

  pages <- lapply(urls,read_html)
  response <- lapply(urls, GET)
  lines <- strsplit(content(response[[1]], as="text"), "\n")

  if (type == "site") {
  minLine <- which(grepl("Conservation Objectives", lines[[1]]))+1
  maxLine <- which(grepl("Prohibitions", lines[[1]]))-1

  # Unique for bansDesAmericains
  if (area == "bancsDesAmericains_MPA") {
    minLine <- which(lines[[1]] == "    <p>The conservation objectives for the Banc-des-Américains Marine Protected are to:</p>\r")+2
    maxLine <- which(grepl("These objectives promote", lines[[1]]))-2
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
  final <- paste0("-", final, "\n")

  return(final)
}
