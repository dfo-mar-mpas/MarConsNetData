# Get Key Biological Areas (KBA) Data

Get Key Biological Areas (KBA) Data

## Usage

``` r
data_KBA(bioregion, crs = sf::st_crs(bioregion))
```

## Arguments

- bioregion:

  sf data.frame of the bio region. You can use
  [`MarConsNetData::data_bioregion()`](https://dfo-mar-mpas.github.io/MarConsNetData/reference/data_bioregion.md)
  to download the bio region of your choice.

- crs:

  target coordinate reference system: object of class crs, or input
  string for st_crs. Default is that of the bioregion.

## Value

"sf" "data.frame" object

## Examples

``` r
if (FALSE) { # \dontrun{
bioregion <- data_bioregion()
kba <- data_KBA(bioregion)
} # }
```
