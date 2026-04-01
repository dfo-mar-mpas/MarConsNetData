# Get Canadian Protected and Conserved Areas Database

This function gets polygons of the the Canadian protected and conserved
areas in the specified bio region. For more information visit
https://www.canada.ca/en/environment-climate-change/services/
national-wildlife-areas/protected-conserved-areas-database.html

## Usage

``` r
data_CPCAD_areas(bioregion, zones = FALSE)
```

## Arguments

- bioregion:

  sf data.frame of the bio region. You can use
  `MarConsNetData::get_bioregion()` to download the bio region of your
  choice.

- zones:

  logical that indicates if zones should be returned (`TRUE`) or, as
  default, unioned (`FALSE`). If zones is `FALSE`, the sf data.frame is
  grouped by `NAME_E` and the geoms are unioned resulting in a complete
  loss of other columns.

## Value

a "sf" "dataframe" object

## Examples

``` r
if (FALSE) { # \dontrun{
bioregion <- data_bioregion()
MPAs <- data_CPCAD_areas(bioregion,  zones = FALSE)
} # }
```
