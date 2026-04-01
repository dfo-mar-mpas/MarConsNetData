# Get Eastern Canada Commercial Fishing data

This function gets the "All Species" dataset of species/gear type
commercial fisheries from 2012 to 2021 in the Eastern Canada Regions in
the specified bio region. For more information visit
https://open.canada.ca/data/dataset/502da2ef-bffa-4d9b-9e9c-a7425ff3c594

## Usage

``` r
data_commercial_fishing(region)
```

## Arguments

- region:

  sf data.frame of the bio region. You can use
  `MarConsNetData::data_planning_area()` to download the planning area
  of your choice.

## Value

a "sf" "dataframe" object

## Examples

``` r
if (FALSE) { # \dontrun{
planning <- data_planning_areas()
fishing <- data_commercial_fishing(planning)
} # }
```
