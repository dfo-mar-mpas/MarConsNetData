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
#> Warning: URL 'https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/1366e1f1-e2c8-4905-89ae-e10f1be0a164/attachments/SUMMER_csv.zip': status was 'SSL peer certificate or SSH remote key was not OK'
#> Error in download.file("https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/1366e1f1-e2c8-4905-89ae-e10f1be0a164/attachments/SUMMER_csv.zip",     tmp): cannot open URL 'https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/1366e1f1-e2c8-4905-89ae-e10f1be0a164/attachments/SUMMER_csv.zip'

fall <- data_MarRV_survey_open(survey="fall")
#> Warning: URL 'https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/5f82b379-c1e5-4a02-b825-f34fc645a529/attachments/FALL_csv.zip': status was 'SSL peer certificate or SSH remote key was not OK'
#> Error in download.file("https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/5f82b379-c1e5-4a02-b825-f34fc645a529/attachments/FALL_csv.zip",     tmp): cannot open URL 'https://api-proxy.edh.azure.cloud.dfo-mpo.gc.ca/catalogue/records/5f82b379-c1e5-4a02-b825-f34fc645a529/attachments/FALL_csv.zip'
```
