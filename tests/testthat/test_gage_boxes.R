context("gage boxes")
library(razviz)

# gages
gage_csv <- system.file("extdata/longitudinal_profiles",
                        "gage_locations.csv",
                        package = "razviz")
gages <- readr::read_csv(gage_csv)

## Remove double backslashes introduced by R import
gages$name <- gsub("\\n", "\n", gages$name, fixed=TRUE)

# gage_boxes
stage_interval_boxes <- 1
box_width <- 0.1
gage_boxes <- razviz::gage_boxes(gages, stage_interval_boxes, box_width)


test_that("gage_boxes", {
  expect_true(is.data.frame(gage_boxes))
})
