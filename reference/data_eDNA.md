# Build a cleaned eDNA sampling dataset from the raw eDNA-for-MPAs directory

This function recursively scans the `../eDNA-for-MPAs/data/` directory
to locate all CSV files containing `"GOTeDNA"` in their file name or
path. Files are grouped by cruise mission, metadata and data files are
paired, naming inconsistencies are corrected, and a unified table of
sample-level information is produced.

## Usage

``` r
data_eDNA()
```

## Value

A data frame containing:

- ID:

  Sample identifier

- date:

  Sampling date (class `Date`)

- latitude:

  Sample latitude

- longitude:

  Sample longitude (corrected to negative values)

- species_richness:

  Count of unique species detected in the sample

- method:

  eDNA sampling method inferred from folder structure

- location:

  Sampling location identifier

- year:

  Extracted sampling year

## Details

The function performs several formatting corrections, including:

- resolving inconsistent `materialSampleID` naming (e.g., `X`, `_`, `-`)

- handling metadata files with different column name conventions

- resolving location name inconsistencies (e.g., `ESI`, `SAB`)

- extracting sample dates, coordinates, richness, and method type

- correcting positive longitudes by flipping sign

The final result is a single cleaned data frame with one row per sample.

The function assumes the following:

- The directory `../eDNA-for-MPAs/data/` exists and contains cruise
  folders.

- Metadata files contain either `materialSampleID`, `SampleID`, or
  `eDNA_Tube`.

- Species columns in data files may be named `Species`, `species`, or
  `V6`.

- Latitude/longitude may be stored as
  `decimalLatitude`/`decimalLongitude` or `Lat`/`Long`.

The function prints progress messages (`i`, `j`, `k`, `l`) and may enter
[`browser()`](https://rdrr.io/r/base/browser.html) in unexpected or
inconsistent cases.

## Examples

``` r
if (FALSE) { # \dontrun{
  df <- data_eDNA()

  # Quick map preview
  leaflet::leaflet(df) %>%
    leaflet::addTiles() %>%
    leaflet::addCircleMarkers(
      lat = ~latitude,
      lng = ~longitude,
      popup = paste("Lat:", df$latitude, "<br>Lon:", df$longitude)
    )
} # }
```
