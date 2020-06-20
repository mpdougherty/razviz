
<!-- README.md is generated from README.Rmd. Please edit that file -->

# razviz

An R package to produce visualizations for evaluating the performance of
[HEC-RAS](https://www.hec.usace.army.mil/software/hec-ras/) models.
<img src="man/figures/castle.png" align="right" />

## Package Status

[![Maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle)
[![Project Status: Active The project has reached a stable, usable state
and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![packageversion](https://img.shields.io/badge/Package%20version-0.0.1-orange.svg?style=flat-square)](commits/master)
[![Last-changedate](https://img.shields.io/badge/last%20change-2020--06--20-yellowgreen.svg)](/commits/master)
[![Licence](https://img.shields.io/badge/licence-CC0-blue.svg)](http://choosealicense.com/licenses/cc0-1.0/)

## Description

This package contains a set of standard graphing and summary table
functions to help streamline the review and evaluation of HEC-RAS model
results during calibration. The package currently contains functions for
producing reports containing the following visualizations:

  - **Hydrographs** - Compare modeled versus observed values for both
    water surface elevation and discharge by cross section and model
    scenario.
  - **Longitudinal Profile Graph** - Compare water surface elevation by
    river mile for multiple model scenarios. Graphs can also contain
    additional annotations (i.e., gage locations, levee elevations,
    bridge elevations, river features, and high water marks) helpful for
    evaluating model results.
  - **Goodness of Fit Statistics Tables** - A table of goodness of fit
    statistics (i.e., \(R^2\), RMSE, MAE) between modeled versus
    observed values by cross section and model scenario.

## Funding

Funding for the development and maintenance of `razviz` was provided by
the US Army Corps of Engineers (USACE). <!--add program names here -->

## Latest Updates

Check out the [NEWS](NEWS.md) for details on the latest updates.

## Author

  - Michael Dougherty, Geographer, U.S. Army Corps of Engineers

## Install

To install the `razviz` package, install from GitHub using the
`devtools` package:

``` r
library(devtools)
devtools::install_github(repo = "mpdougherty/razviz", build_vignettes = TRUE)
```
