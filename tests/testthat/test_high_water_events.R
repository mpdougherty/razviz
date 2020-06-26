context("high water event")
library(razviz)

# high_water
high_water_csv <- system.file("extdata/longitudinal_profiles",
                              "high_water_marks.csv",
                              package = "razviz")
high_water <- readr::read_csv(high_water_csv)
high_water_years <- c("2008", "2013", "2014")
high_water_events_df <- razviz::high_water_events(high_water, high_water_years)


test_that("high water event", {
  expect_true(is.data.frame(high_water_events_df))
})
