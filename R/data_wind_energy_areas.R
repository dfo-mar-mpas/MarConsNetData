#' data_wind_energy_areas
#' Download and read the Wind Energy Areas (WEA) dataset from the Canada-Nova Scotia Offshore Energy Regulator [(CNSOER)](https://cnsoer.ca/renewable-energy/lands-management/governments-designated-offshore-wind-energy-areas).
#'
#' @returns An sf object containing the Wind Energy Areas (WEA) dataset.
#'
#' @export
#' @examples
#' \dontrun{
#' wea <- data_wind_energy_areas()
#' }
#' @importFrom sf st_read
data_wind_energy_areas <- function() {
  tmpdir <- tempdir()
  dir.create(tmpdir, showWarnings = FALSE)
  on.exit(unlink(tmpdir, recursive = TRUE))

  download.file(
    "https://cnsopbdigitaldata.ca/geoviewer/dmc/public/Designated-WEA.zip",
    destfile = file.path(tmpdir, "Designated-WEA.zip")
  )

  unzip(file.path(tmpdir, "Designated-WEA.zip"), exdir = tmpdir)
  files <- unzip(
    file.path(tmpdir, "Designated-WEA.zip"),
    exdir = tmpdir,
    list = TRUE
  )

  st_read(file.path(tmpdir, files$Name[grepl("\\.shp$", files$Name)]))
}
