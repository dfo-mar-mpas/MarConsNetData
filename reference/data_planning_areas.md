# Get Marine Spatial Planning Areas Data

This function pulls information (length, area, shape, etc.) about
[Eastern Canada Marine Spatial Planning
Areas](https://open.canada.ca/data/en/dataset/f089a3f3-45e9-47de-b1c4-170e9950d8e7).

## Usage

``` r
data_planning_areas(PA = "Scotian Shelf and Bay of Fundy")
```

## Arguments

- PA:

  name of the planning area to match from the `NAME_E` column from [Open
  Data ESRI
  REST](https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/Eastern_Canada_Marine_Spatial_Planning_Areas/MapServer/0).
  Default is `"Scotian Shelf and Bay of Fundy"`

## Value

sf data.frame

## Examples

``` r
if (FALSE) { # \dontrun{
planning_area <- data_planning_areas()
} # }
```
