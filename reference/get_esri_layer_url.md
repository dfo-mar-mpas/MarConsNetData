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

## Examples

``` r

rest_url <- get_COD_url(uuid="14d55ea5-b17d-478c-b9ee-6a7c04439d2b","ESRI REST")
#> Searching for resources with extension 'ESRI REST' in on https://open.canada.ca/data/en/dataset/14d55ea5-b17d-478c-b9ee-6a7c04439d2b
#> Warning: Multiple resources matched 'ESRI REST'; returning all matches.
clusterlayers_url <- get_esri_layer_url(rest_url[1], "cluster")
#> Warning: Multiple layers matched 'cluster': BioClassification Clusters / Groupes de bio-classification, BioClassification Uncertain Clusters / Groupes de bio-classification incertains. Using the first.
clusters <- arcpullr::get_spatial_layer(clusterlayers_url)
```
