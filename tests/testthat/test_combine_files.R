context("combine files")
library(razviz)

# hydro_model
path <- system.file("extdata",
                    package = "razviz")
pattern <- "Freq"
hydro_model <- razviz::combine_files(path = path, pattern = pattern)


test_that("combine files", {
  expect_true(is.data.frame(hydro_model))
})
