# Find a layer URL in an ArcGIS REST service by (partial) layer name

Find a layer URL in an ArcGIS REST service by (partial) layer name

## Usage

``` r
get_esri_layer_url(service_url, pattern, ignore.case = TRUE)
```

## Arguments

- service_url:

  character string of the ArcGIS REST service URL (e.g.,
  "https://egisp.dfo-mpo.gc.ca/arcgis/rest/services/open_data_donnees_ouvertes/maritimes_summer_research_vessel_survey_en/MapServer")

- pattern:

  character string to match against layer names

- ignore.case:

  logical, whether to ignore case when matching layer names (default:
  TRUE)
