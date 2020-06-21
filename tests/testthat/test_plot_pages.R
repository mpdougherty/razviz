context("plot pages")
library(razviz)

path <- system.file("extdata", package = "razviz")
pattern <- "Freq"

hydro_model <- combine_files(path = path, pattern = pattern)

high_water_csv <- system.file("extdata", "high_water_marks.csv",
                              package = "razviz")
high_water <- readr::read_csv(high_water_csv)

miles_per_plot <- 60

plot_pages_df <- plot_pages(hydro_model, high_water, miles_per_plot)

test_that("plot pages", {
  expect_true(is.data.frame(plot_pages_df))
})
