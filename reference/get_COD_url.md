# Get Canadian Open Data (COD) resource URL by extension

Get Canadian Open Data (COD) resource URL by extension

## Usage

``` r
get_COD_url(uuid, ext)
```

## Arguments

- uuid:

  universally unique identifier of the dataset in the
  https://open.canada.ca/ portal (e.g.,
  "2d9cce9a-d634-4b49-879f-87c40c52acf2")

- ext:

  desired file extension (e.g., "csv", "json", "xlsx")

## Value

A character vector of URLs for resources matching the specified
extension.

## Examples

``` r
url <- get_COD_url("2d9cce9a-d634-4b49-879f-87c40c52acf2", "csv")
#> Searching for resources with extension 'csv' in on https://open.canada.ca/data/en/dataset/2d9cce9a-d634-4b49-879f-87c40c52acf2
datadict <- read.csv(url)
```
