context("rm_event_stats")
library(razviz)

# Import hydrograph data
hydrograph_csv <- system.file("extdata/hydrographs", "hydrograph_data.csv",
                              package = "razviz")
hydrograph_whole <- readr::read_csv(hydrograph_csv)

# Filter for Mississippi River
hydrograph <- dplyr::filter(hydrograph_whole, River == "Mississippi")

# Create table with unique records Run_type, Run_num, River_Sta, and Event
cal_stats <- unique(hydrograph[, c("Run_type", "Run_num",
                                   "River_Sta", "Event")])

# Sort the table by "Run_type", "Run_num", "Event", "River_Sta"
cal_stats <- dplyr::arrange(cal_stats,
                            Run_type, Run_num, Event, desc(River_Sta))

# Create a column to represent "river mile events"
cal_stats <- tibble::add_column(cal_stats,
                                rm_event = 1:length(cal_stats$Run_type),
                                .before = 1)

# Add goodness-of-fit statistic fields to cal_stats
# Water surface
cal_stats <- tibble::add_column(cal_stats,
                                WS_R2 = as.numeric(rep(NA,
                                           times = length(cal_stats$rm_event))))
cal_stats <- tibble::add_column(cal_stats,
                                WS_RMSE = as.numeric(rep(NA,
                                           times = length(cal_stats$rm_event))))
cal_stats <- tibble::add_column(cal_stats,
                                WS_MAE  = as.numeric(rep(NA,
                                           times = length(cal_stats$rm_event))))
# Discharge
cal_stats <- tibble::add_column(cal_stats,
                                Q_R2 = as.numeric(rep(NA,
                                           times = length(cal_stats$rm_event))))
cal_stats <- tibble::add_column(cal_stats,
                                Q_RMSE = as.numeric(rep(NA,
                                           times = length(cal_stats$rm_event))))
cal_stats <- tibble::add_column(cal_stats,
                                Q_MAE  = as.numeric(rep(NA,
                                           times = length(cal_stats$rm_event))))
# Set the test event
rm_event <- 2

# Calculate the stats
calibration_stats <- rm_event_stats(hydrograph, rm_event, cal_stats)


test_that("rm_event_stats", {
  expect_true(is.data.frame(calibration_stats))
})
