context(gof_stats)
library(razviz)

# Import hydrograph data
hydrograph_csv <- system.file("extdata/hydrographs", "LD10.csv",
                              package = "razviz")
hydrograph <- readr::read_csv(hydrograph_csv)

# Calculate goodness of fit statistics
hydrograph_stats <- gof_stats(hydrograph)

# Import hydrograph data
hydrograph_csv <- system.file("extdata/hydrographs", "hydrograph_data.csv",
                              package = "razviz")
hydrograph2 <- readr::read_csv(hydrograph_csv)

# Filter for Mississippi River
mr <- dplyr::filter(hydrograph2, River == "Mississippi")

# Calculate goodness of fit statistics
hydrograph_stats2 <- gof_stats(mr)

hydrograph <- mr


test_that("gof_stats", {
  expect_true(is.data.frame(hydrograph_stats))
})
