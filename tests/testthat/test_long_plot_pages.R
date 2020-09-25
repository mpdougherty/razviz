context("long plot pages")
library(razviz)

# hydro_model
path <- system.file("extdata/longitudinal_profiles",
                    package = "razviz")
pattern <- "Freq"

hydro_model <- razviz::combine_files(path = path, pattern = pattern)

## Create `Event` field for labeling
hydro_model$Event <- hydro_model$Freq

## Filter the Events
model_events <- c("2 Year", "100 Year", "500 Year", "100000 Year")
hydro_model_1 <- dplyr::filter(hydro_model, Event %in% model_events)

## Set Event as an ordered factor
hydro_model_1$Event <- factor(hydro_model_1$Event,
  levels = model_events,
  labels = model_events)

#set the variable to plot
hydro_model_1$hydro_parameter <- hydro_model_1$WS_Elev



# high_water
high_water_csv <- system.file("extdata/longitudinal_profiles",
                              "high_water_marks.csv",
                              package = "razviz")
high_water <- readr::read_csv(high_water_csv)
high_water_years <- c("2008", "2013", "2014")
high_water_events_df <- razviz::high_water_events(high_water, high_water_years)

# long_plot_pages
miles_per_plot <- 60
long_plot_pages_df <- razviz:: long_plot_pages(hydro_model = hydro_model_1,
                                               high_water = high_water_events_df,
                                               miles_per_plot = miles_per_plot)

#long_plot_pages without high water df
long_plot_pages_df2 <- razviz:: long_plot_pages(hydro_model= hydro_model_1,  miles_per_plot = miles_per_plot)


test_that("long plot pages", {
  expect_true(is.data.frame(long_plot_pages_df))
  expect_true(is.data.frame(long_plot_pages_df2))
})
