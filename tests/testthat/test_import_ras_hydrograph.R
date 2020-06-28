context("import ras hydrograph")
library(razviz)
library(readr)

# RAS hydrograph export format
RAS_col_spec = readr::cols("ModelCrossSection" = col_character(),
                           "ModelRiver"        = col_character(),
                           "ModelReach"        = col_character(),
                           "Date"              = col_character(),
                           "Time"              = col_character(),
                           "W.S. Elev"         = col_double(),
                           "Obs WS"            = col_double(),
                           "Modeled Q"         = col_double(),
                           "Obs Q"             = col_double())

folder <- system.file("extdata/hydrographs/2008_calibration_9",
                      package = "razviz")
event <- "2008"
run_number <- 9
run_type <- "Calibration"

cal_2008 <- razviz::import_ras_hydrographs(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type,
                                           col_spec = RAS_col_spec)

test_that("import calibration", {
  expect_true(is.data.frame(cal_2008))
})
