context("gage boxes")
library(razviz)

gage_csv <- system.file("extdata", "gage_locations.csv", package = "razviz")
gages <- readr::read_csv(gage_csv)

# Remove double backslashes introduced by R import
gages$name <- gsub("\\n", "\n", gages$name, fixed=TRUE)

stage_interval_boxes <- 1
box_width <- 0.1

gage_boxes <- gage_boxes(gages, stage_interval_boxes, box_width)

test_that("gage_boxes", {
  expect_true(is.data.frame(gage_boxes))
})
