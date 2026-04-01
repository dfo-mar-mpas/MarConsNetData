# Get Bio Region Information Data

This function pulls information (length, area, shape, etc.) about number
of bio regions. For a list of available options visit
https://open.canada.ca/data/en/dataset/23eb8b56-dac8-4efc-be7c-b8fa11ba62e9

## Usage

``` r
data_bioregion(bioregion = "Scotian Shelf")
```

## Arguments

- bioregion:

  name of the bio region to match from the `NAME_E` column from [Open
  Data](https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/federal_marine_bioregions_bioregions_marines_federales/MapServer/0)
  or one of the Ocean Basins to return multiple bioregions (i.e.
  "Atlantic", "Arctic", or "Pacific) or "All" to return all available
  bioregions. Default is `"Scotian Shelf"`

## Value

sf data.frame

## Examples

``` r
if (FALSE) { # \dontrun{
bioregion <- data_bioregion()
} # }
```
