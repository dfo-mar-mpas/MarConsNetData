# Download the Maritimes Summer Research Vessel Survey data from open.canada.ca

Data is from the csv files on
https://open.canada.ca/data/en/dataset/8ddcaeea-b806-4958-a79f-ba9ab645f53b

## Usage

``` r
data_MarRV_survey_open(survey = "summer")
```

## Arguments

- survey:

  character string indicating the survey to be downloaded. Defaults to
  "summer", but can also accept "spring", "fall", "4VSW", and
  "summer_strata"

## Value

list of data.frames or sf data.frame

## Examples

``` r
summer <- data_MarRV_survey_open()

fall <- data_MarRV_survey_open(survey="fall")
```
