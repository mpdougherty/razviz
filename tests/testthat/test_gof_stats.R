context(gof_stats)
library(razviz)

# Import hydrograph data
hydrograph_csv <- system.file("extdata/hydrographs", "LD10.csv",
                              package = "razviz")
hydrograph <- readr::read_csv(hydrograph_csv)

# Calculate goodness of fit statistics
hydrograph_stats <- gof_stats(hydrograph)


test_that("gof_stats", {
  expect_true(is.data.frame(hydrograph_stats))
})
