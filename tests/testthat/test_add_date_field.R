context("add date field")
library(razviz)
library(readr)

ras_csv <- system.file("extdata/hydrographs/2008_calibration_9",
                       "CS_43.702_MISSISSIPPI_BIG MUDDY_OHIO_GAUGE_THEBES.csv",
                       package = "razviz")

# DSSVue export
col_spec = readr::cols("ModelCrossSection" = col_character(),
                       "ModelRiver"        = col_character(),
                       "ModelReach"        = col_character(),
                       "Date"              = col_character(),
                       "Time"              = col_character(),
                       "W.S. Elev"         = col_double(),
                       "Obs WS"            = col_double(),
                       "Modeled Q"         = col_double(),
                       "Obs Q"             = col_double())

ras_export <- readr::read_csv(ras_csv, col_types = col_spec)

df <- razviz::add_date_field(ras_export)


test_that("add date field", {
  expect_true(is.data.frame(df))
})
