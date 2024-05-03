
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MarConsNetData

<!-- badges: start -->

[![R-CMD-check](https://github.com/dfo-mar-mpas/MarConsNetData/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dfo-mar-mpas/MarConsNetData/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of MarConsNetData is to facilitate the acquisition of data for
the Maritimes Conservation Network

## Installation

You can install the development version of MarConsNetData from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("dfo-mar-mpas/MarConsNetData")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(MarConsNetData)

bioregion <- data_bioregion()
#> Warning in CPL_crs_from_input(x): GDAL Message 1: +init=epsg:XXXX syntax is
#> deprecated. It might return a CRS with a non-EPSG compliant axis order.
```
