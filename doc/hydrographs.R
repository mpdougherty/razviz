## ----options, include = FALSE-------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>")

## ----setup, message=FALSE-----------------------------------------------------
library(tidyverse)
library(devtools)

## ----install, eval=FALSE------------------------------------------------------
#  devtools::install_github(repo = "mpdougherty/razviz", build_vignettes = TRUE)

## ----load_razviz--------------------------------------------------------------
library(razviz)

## ----cal_2008-----------------------------------------------------------------
# Set event parameters
folder <- system.file("extdata/hydrographs/2008_calibration_9",
                      package = "razviz")
event <- "2008"
run_number <- 9
run_type <- "Calibration"
# Import event model results
cal_2008 <- razviz::import_ras_hydrographs(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

## ----cal_2013-----------------------------------------------------------------
# Set event parameters
folder <- system.file("extdata/hydrographs/2013_calibration_9",
                      package = "razviz")
event <- "2013"
run_number <- 9
run_type <- "Calibration"
# Import event model results
cal_2013 <- razviz::import_ras_hydrographs(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

## ----cal_2014-----------------------------------------------------------------
# Set event parameters
folder <- system.file("extdata/hydrographs/2014_calibration_9",
                      package = "razviz")
event <- "2014"
run_number <- 9
run_type <- "Calibration"
# Import event model results
cal_2014 <- razviz::import_ras_hydrographs(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

## ----cal_2017-----------------------------------------------------------------
# Set event parameters
folder <- system.file("extdata/hydrographs/2017_calibration_9",
                      package = "razviz")
event <- "2017"
run_number <- 9
run_type <- "Calibration"
# Import event model results
cal_2017 <- razviz::import_ras_hydrographs(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

## ----combine_events-----------------------------------------------------------
# Combine hydrograph events 
hydrograph_list <- list(cal_2008, cal_2013, cal_2014, cal_2017)
cal_wide <- razviz::combine_hydrographs(hydrograph_list)

# Convert to long format suitable for plotting
cal <- razviz::lengthen_hydrographs(cal_wide)

# Rename factors for prettier plot labeling
cal$River <- forcats::fct_recode(cal$River, 
                                 "Mississippi" = "MISSISSIPPI")
cal$Reach <- forcats::fct_recode(cal$Reach, 
                                 "Big Muddy to Ohio"      = "BIG MUDDY_OHIO", 
                                 "Fox to Bear"            = "FOXTOBEAR",
                                 "Illinois to Mizzou"     = "ILLINOIS_MIZZOU",
                                 "Iowa to Des Moines"     = "IOWATODESM",
                                 "Kaskaskia to Big Muddy" = "KASKY_BIGMUDDY",
                                 "Meramec to Kaskaskia"   = "MERAMEC_KASKY",
                                 "Missouri to Meramec"    = "MISSOURI_MERAMEC",
                                 "North to Salt"          = "NORTHTOSALT",
                                 "Salt to Cuivre"         = "SALT_CUIVRE",
                                 "Wyaconda to Fabius"     = "WYACONDATOFABIUS")


## ----plot_pages---------------------------------------------------------------
cal_plots <- razviz::hydrograph_plot_pages(cal)

## ----temp_dir-----------------------------------------------------------------
output_dir <- "C:/temp"
if (!dir.exists(output_dir)) {dir.create(output_dir)}

## ----hydrograph_report, message=FALSE-----------------------------------------
razviz::hydrograph_report(cal, cal_plots, output_dir)

