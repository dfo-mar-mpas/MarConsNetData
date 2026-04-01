# Extract species lists from DFO website

Extract species lists from DFO website

## Usage

``` r
data_DFO_sp_lists(status = "At-Risk")
```

## Arguments

- status:

  character string that determines which list is returned. Default is
  "At-Risk", but "Invasive","","Special Concern",and "all" are also
  valid options.

## Value

a dataframe

## Examples

``` r
# get Aquatic Invasive Species list
AIS <- data_DFO_sp_lists(status="Invasive")
#> No encoding supplied: defaulting to UTF-8.

# get Species at Risk list
SARA <- data_DFO_sp_lists(status="At-Risk")
#> No encoding supplied: defaulting to UTF-8.
```
