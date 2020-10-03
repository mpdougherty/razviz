context("lengthen hydrographs")
library(razviz)

# Event 2008, Calibration #9
folder <- system.file("extdata/hydrographs/2008_calibration_9",
                      package = "razviz")
event <- "2008"
run_number <- 9
run_type <- "Calibration"
cal_2008 <- razviz::import_csv_manualrasoutput(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

# Event 2013, Calibration #9
folder <- system.file("extdata/hydrographs/2013_calibration_9",
                      package = "razviz")
event <- "2013"
run_number <- 9
run_type <- "Calibration"
cal_2013 <- razviz::import_csv_manualrasoutput(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

# Event 2014, Calibration #9
folder <- system.file("extdata/hydrographs/2014_calibration_9",
                      package = "razviz")
event <- "2014"
run_number <- 9
run_type <- "Calibration"
cal_2014 <- razviz::import_csv_manualrasoutput(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

# Event 2017, Calibration #9
folder <- system.file("extdata/hydrographs/2017_calibration_9",
                      package = "razviz")
event <- "2017"
run_number <- 9
run_type <- "Calibration"
cal_2017 <- razviz::import_csv_manualrasoutput(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

# Combine hydrograph events
hydrograph_list <- list(cal_2008, cal_2013, cal_2014, cal_2017)
cal_wide <- razviz::combine_hydrographs(hydrograph_list)

# Convert to long format suitable for plotting
cal <- razviz::lengthen_hydrographs(cal_wide)

hydrograph_variables <- c("WS_Elev", "Model_Q","Obs_WS", "Obs_Q")


test_that("lengthen hydrographs", {
  expect_true(is.data.frame(cal))
  expect_true(length(unique(cal$Type)) == length(hydrograph_variables))
})

