# Get draft conservation network sites

This function pulls information (length, area, shape, etc.) about draft
conservation network sites for the Scotian Shelf-Bay of Fundy Bioregion.
More information is available at:
https://open.canada.ca/data/en/dataset/bb048082-bc05-4588-b4f0-492b1f1b8737

## Usage

``` r
data_draft_areas(bioregion = "Scotian Shelf")
```

## Arguments

- bioregion:

  name of the bio region to match from the `NAME_E` column from [Open
  Data](https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Federal_Marine_Bioregions/MapServer/0).
  Default is `"Scotian Shelf"`

## Value

sf data.frame

## Examples

``` r
if (FALSE) { # \dontrun{
draftareas <- data_draft_areas()
} # }
```
