# Get Ecologically and Biologically Significant Area Data

This function gets the ecologically and biologically significant areas
in the specified bio region. For more information see
https://open.canada.ca/data/en/dataset/d2d6057f-d7c4-45d9-9fd9
-0a58370577e0

## Usage

``` r
data_EBSA(bioregion)
```

## Arguments

- bioregion:

  sf data.frame of the bio region. You can use
  [`MarConsNetData::data_bioregion()`](https://dfo-mar-mpas.github.io/MarConsNetData/reference/data_bioregion.md)
  to download the bio region of your choice.

## Value

a "sf" "dataframe" object

## Examples

``` r
if (FALSE) { # \dontrun{
bioregion <- data_bioregion()
ebsa <- data_EBSA(bioregion)
} # }
```
