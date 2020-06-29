context("hydrograph plot")
library(razviz)

# Event 2008, Calibration #9
folder <- system.file("extdata/hydrographs/2008_calibration_9",
                      package = "razviz")
event <- "2008"
run_number <- 9
run_type <- "Calibration"
cal_2008 <- razviz::import_ras_hydrographs(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

# Event 2013, Calibration #9
folder <- system.file("extdata/hydrographs/2013_calibration_9",
                      package = "razviz")
event <- "2013"
run_number <- 9
run_type <- "Calibration"
cal_2013 <- razviz::import_ras_hydrographs(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

# Event 2014, Calibration #9
folder <- system.file("extdata/hydrographs/2014_calibration_9",
                      package = "razviz")
event <- "2014"
run_number <- 9
run_type <- "Calibration"
cal_2014 <- razviz::import_ras_hydrographs(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

# Event 2017, Calibration #9
folder <- system.file("extdata/hydrographs/2017_calibration_9",
                      package = "razviz")
event <- "2017"
run_number <- 9
run_type <- "Calibration"
cal_2017 <- razviz::import_ras_hydrographs(folder = folder,
                                           event = event,
                                           run_number = run_number,
                                           run_type = run_type)

# Combine hydrograph events
hydrograph_list <- list(cal_2008, cal_2013, cal_2014, cal_2017)
cal_wide <- razviz::combine_hydrographs(hydrograph_list)

# Convert to long format suitable for plotting
hydrograph_df <- razviz::lengthen_hydrographs(cal_wide)

# Rename factors for prettier plot labeling
hydrograph_df$River <- forcats::fct_recode(hydrograph_df$River,
                                 "Mississippi" = "MISSISSIPPI")
hydrograph_df$Reach <- forcats::fct_recode(hydrograph_df$Reach,
                                 "Big Muddy to Ohio"      = "BIG MUDDY_OHIO",
                                 "Fox to Bear"            = "FOXTOBEAR",
                                 "Illinois to Mizzou"     = "ILLINOIS_MIZZOU",
                                 "Iowa to Des Moines"     = "IOWATODESM",
                                 "Kaskaskia to Big Muddy" = "KASKY_BIGMUDDY",
                                 "Meramec to Kaskaskia"   = "MERAMEC_KASKY",
                                 "Missouri to Meramec"    = "MISSOURI_MERAMEC",
                                 "North to Salt"          = "NORTHTOSALT",
                                 "Salt to Cuivre"         = "SALT_CUIVRE",
                                 "Wyaconda to Fabius"     = "WYACONDATOFABIUS")

# Create hydrograph plot pages
hg_plot_pages <- razviz::hydrograph_plot_pages(hydrograph_df)

# Create hydrograph plot
plot_number <- 3
hg_plot <- suppressWarnings(razviz::hydrograph_plot(plot_number = plot_number,
                                                hydrograph_df = hydrograph_df,
                                                hg_plot_pages = hg_plot_pages))


test_that("hydrograph plot", {
  expect_true("grob" %in% class(hg_plot))
  expect_true(length(hg_plot$grobs) == 3)                 # 2 plots and a title
})
