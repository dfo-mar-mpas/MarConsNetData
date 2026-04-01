# Get Species at Risk Critical Habitat Data

This function gets the Critical Habitat for Aquatic Species at Risk in
the specified bio region. For more information see
https://open.canada.ca/data/en/dataset/db177a8c-5d7d-49eb-8290-31e6a45d786c

## Usage

``` r
data_SAR_CH(bioregion)
```

## Arguments

- bioregion:

  sf data.frame of the bio region. You can use
  `MarConsNetData::get_bioregion()` to download the bio region of your
  choice.

## Value

"sf" "data.frame" object

## Examples

``` r
if (FALSE) { # \dontrun{
bioregion <- data_bioregion()
SARCH <- data_SAR_CH(bioregion)
} # }
```
