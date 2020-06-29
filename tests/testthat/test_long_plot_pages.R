context("long plot pages")
library(razviz)

# hydro_model
path <- system.file("extdata/longitudinal_profiles",
                    package = "razviz")
pattern <- "Freq"
hydro_model <- razviz::combine_files(path = path, pattern = pattern)

# high_water
high_water_csv <- system.file("extdata/longitudinal_profiles",
                              "high_water_marks.csv",
                              package = "razviz")
high_water <- readr::read_csv(high_water_csv)
high_water_years <- c("2008", "2013", "2014")
high_water_events_df <- razviz::high_water_events(high_water, high_water_years)

# long_plot_pages
miles_per_plot <- 60
long_plot_pages_df <- razviz:: long_plot_pages(hydro_model,
                                               high_water_events_df,
                                               miles_per_plot)


test_that("long plot pages", {
  expect_true(is.data.frame(long_plot_pages_df))
})
