## ----options, include = FALSE-------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>")

## ----setup--------------------------------------------------------------------
library(tidyverse)
library(devtools)

## ----install, eval=FALSE------------------------------------------------------
#  devtools::install_github(repo = "mpdougherty/razviz", build_vignettes = TRUE)

## ----load_razviz--------------------------------------------------------------
library(razviz)

## ----dssvue_columns-----------------------------------------------------------
# RAs export column specification
RAS_col_spec = readr::cols("ModelCrossSection" = col_character(),
                           "ModelRiver"        = col_character(),
                           "ModelReach"        = col_character(),
                           "Gague"             = col_character(),
                           "Date"              = col_character(),
                           "Time"              = col_character(),
                           "W.S. Elev"         = col_double(),
                           "Obs WS"            = col_double(),
                           "Modeled Q"         = col_double(),
                           "Obs Q"             = col_double())

## ----cal_2008-----------------------------------------------------------------
# Set event parameters
folder <- system.file("extdata/hydrographs/2008_calibration_9",
                      package = "razviz")
event <- "2008"
run_number <- 9
run_type <- "Calibration"
# Import event model results
cal_2008 <- razviz::import_calibration(folder = folder,
                                       event = event,
                                       run_number = run_number,
                                       run_type = run_type,
                                       col_spec = RAS_col_spec)

## ----cal_2013-----------------------------------------------------------------
# Set event parameters
folder <- system.file("extdata/hydrographs/2013_calibration_9",
                      package = "razviz")
event <- "2013"
run_number <- 9
run_type <- "Calibration"
# Import event model results
cal_2013 <- razviz::import_calibration(folder = folder,
                                       event = event,
                                       run_number = run_number,
                                       run_type = run_type,
                                       col_spec = RAS_col_spec)

## ----cal_2014-----------------------------------------------------------------
# Set event parameters
folder <- system.file("extdata/hydrographs/2014_calibration_9",
                      package = "razviz")
event <- "2014"
run_number <- 9
run_type <- "Calibration"
# Import event model results
cal_2014 <- razviz::import_calibration(folder = folder,
                                       event = event,
                                       run_number = run_number,
                                       run_type = run_type,
                                       col_spec = RAS_col_spec)

## ----cal_2017-----------------------------------------------------------------
# Set event parameters
folder <- system.file("extdata/hydrographs/2017_calibration_9",
                      package = "razviz")
event <- "2017"
run_number <- 9
run_type <- "Calibration"
# Import event model results
cal_2017 <- razviz::import_calibration(folder = folder,
                                       event = event,
                                       run_number = run_number,
                                       run_type = run_type,
                                       col_spec = RAS_col_spec)

## ----combine_events-----------------------------------------------------------
# Append all model runs and events
cal <- dplyr::bind_rows(cal_2008, cal_2013, cal_2014, cal_2017)

# Fix RAS export column names
cal <- dplyr::rename(cal, River_Sta = "ModelCrossSection", 
                          River     = "ModelRiver",
                          Reach     = "ModelReach",
                          Gage      = "Gague",
                          WS_Elev   = "W.S. Elev", 
                          Obs_WS    = "Obs WS",
                          Model_Q   = "Modeled Q", 
                          Obs_Q     = "Obs Q")

# Assign factors
cal$River_Sta <- factor(as.numeric(cal$River_Sta))
cal$River     <- factor(cal$River)
cal$Reach     <- factor(cal$Reach)
cal$Gage      <- factor(cal$Gage)
cal$Event     <- factor(cal$Event)
cal$Run_type  <- factor(cal$Run_type)
cal$Run_num   <- factor(cal$Run_num)
# Recode variables
cal$River <- forcats::fct_recode(cal$River, "Mississippi" = "MISSISSIPPI")
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
                        "Wyaconda to Fabius"     = "WYACONDATOFABIUS",
                        "Cuivre to Illinois"     = "CUIVRE_ILLINOIS",
                        "Lock & Dam 22 to Salt"  = "LD 22_SALT")

