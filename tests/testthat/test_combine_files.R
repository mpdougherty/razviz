context("combine files")
library(razviz)
library(readr)

path <- system.file("extdata", package = "razviz")
pattern <- "Freq"

hydro_model <- combine_files(path = path, pattern = pattern)

test_that("combine files", {
  expect_true(is.data.frame(hydro_model))
})
