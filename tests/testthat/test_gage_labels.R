context("gage_labels")
library(razviz)

# gages
gage_csv <- system.file("extdata", "gage_locations.csv", package = "razviz")
gages <- readr::read_csv(gage_csv)

## Remove double backslashes introduced by R import
gages$name <- gsub("\\n", "\n", gages$name, fixed=TRUE)

# gage_labels
stage_interval_label <- 5
gage_labels <- razviz::gage_labels(gages, stage_interval_label)


test_that("gage_labels", {
  expect_true(is.data.frame(gage_labels))
})
