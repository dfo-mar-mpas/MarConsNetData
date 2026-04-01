# Get Coral and Sponge Significant Benthic Areas in Eastern Canada (2016) Data

This function gets the Coral and Sponge Significant Benthic Areas in the
specified region. For more information see
https://open.canada.ca/data/en/dataset/6af357a3-3be1-47d5-9d1f-e4f809c4c903

## Usage

``` r
data_SBA(region)
```

## Arguments

- region:

  sf data.frame of the region. You can use
  [`MarConsNetData::data_planning_areas()`](https://dfo-mar-mpas.github.io/MarConsNetData/reference/data_planning_areas.md)
  to download the region of your choice.

## Value

a "sf" "dataframe" object

## Examples

``` r
if (FALSE) { # \dontrun{
region <- data_planning_areas()
sba <- data_SBA(region)
} # }
```
