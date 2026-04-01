# Get Objectives from Canadian Protected and Conserved Areas

This function gets site and network level objectives for the Canadian
protected and conserved areas in the Scotian Shelf bio region.

## Usage

``` r
data_objectives(
  type = NULL,
  area = "St. Anns Bank Marine Protected Area",
  prohibiton = FALSE
)
```

## Arguments

- type:

  argument of either `site` or `network` indicating which objectives to
  obtain

- area:

  a name of an area of which to obtain the objectives from.

- prohibiton:

  a boolean indicating if you want the prohibition included

## Value

a "sf" "dataframe" object

## Examples

``` r
if (FALSE) { # \dontrun{
stAnnsBankObjectives <- data_objectives(type="site", area="st_Anns_Bank_MPA")
} # }
```
