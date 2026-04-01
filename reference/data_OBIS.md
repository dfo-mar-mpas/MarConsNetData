# Get Ocean Biodiversity Information System (OBIS) data

This function obtains OBIS data.

## Usage

``` r
data_OBIS(areas, geom_col = "geoms", name_col = "NAME_E")
```

## Arguments

- areas:

  sf data.frame of the bio region. You can use
  [`MarConsNetData::data_bioregion()`](https://dfo-mar-mpas.github.io/MarConsNetData/reference/data_bioregion.md)
  to download the bio region of your choice.

- geom_col:

  name of the geometry column

- name_col:

  name of a column to obtain in the obis data set

## Value

data.frame

## Examples

``` r
if (FALSE) { # \dontrun{
bioregion <- data_bioregion()
obis <- data_OBIS(bioregion)
} # }
```
