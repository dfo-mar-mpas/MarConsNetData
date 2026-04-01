# Get Context from Canadian Protected and Conserved Areas

This function gets site and network level context for the Canadian
protected and conserved areas in the Scotian Shelf bio region.

## Usage

``` r
data_context(type = NULL, area = "St. Anns Bank Marine Protected Area")
```

## Arguments

- type:

  argument of either `site` or `network` indicating which objectives to
  obtain

- area:

  a name of an area of which to obtain the objectives from. Options
  include `st_Anns_Bank_MPA`, `musquash_MPA`, `laurentian_Channel_MPA`,
  `gully_MPA`, `gilbert_MPA`, `eastport_MPA`, `basin_MPA`,
  `bancsDesAmericains_MPA`, `WEBCA`

## Value

a "sf" "dataframe" object

## Examples

``` r
if (FALSE) { # \dontrun{
stAnnsBankContext <- data_context(type="site", area="st_Anns_Bank_MPA")
} # }
```
