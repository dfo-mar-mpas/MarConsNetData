# Get climate data

Get data from [PAVICS](NA) THREDDS
[catalog](https://pavics.ouranos.ca/thredds/catalog.html)

## Usage

``` r
data_PAVICS(
  OPENDAP_url = .pavics_default_url,
  first_date = "1950-01-01",
  end_date = "1951-01-1",
  variable = "tas",
  geom = data_planning_areas(),
  maskGeom = TRUE
)
```

## Arguments

- OPENDAP_url:

  character string for an OPENDAP url from the THREDDS
  [catalog](https://pavics.ouranos.ca/thredds/catalog.html). Defaults to
  a [RCM-CMIP6](NA) daily simulation

- first_date:

  character string for the first date to be included in the data subset.
  Defaults to "1950-01-01"

- end_date:

  character string for the last date to be included in the data subset.
  Defaults to "1950-01-01"

- variable:

  character string for the variable to query from the data. Defaults to
  "tas" for Near-Surface Air Temperature. See the OPENDAP url for more
  options

- geom:

  sf data.frame used to limit the spatial extent of the data subset (via
  bounding box). Defaults to the Scotian Shelf and Bay of Fundy planning
  area

- maskGeom:

  logical defaults to TRUE to turn values outside the `geom` to NA
  instead of returning all the values that are downloaded as is.

## Value

matrix

## Examples

``` r
if (FALSE) { # \dontrun{
require(MarConsNetData)
require(dplyr)
# get the Scotian Shelf polygon
ssbof <- data_planning_areas()

# get CMIP6 data dor Near-Surface Air Temperature (tas)
climate <- data_PAVICS(first_date = "1950-01-01",
                       end_date = "1950-03-1",
                       variable = "tas",
                       geom = ssbof,
                       maskGeom = TRUE)

# plot a single time point
climate |>
  slice("time",1) |>
  plot()

# calculate and plot monthly means
monthlyClimate <- aggregate(climate,
                            by = "1 month",
                            FUN = mean,
                            na.rm = TRUE)

plot(monthlyClimate)

} # }
```
