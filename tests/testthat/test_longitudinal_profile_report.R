context("longitudinal profile report")
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

# high_water
high_water_csv <- system.file("extdata/longitudinal_profiles",
                              "high_water_marks.csv",
                              package = "razviz")
high_water <- readr::read_csv(high_water_csv)
high_water_years <- c("2008", "2013", "2014")
high_water_events_df <- razviz::high_water_events(high_water, high_water_years)
## Set Event as an ordered factor
high_water_events_df$event <- factor(high_water_events_df$event,
                                     levels = high_water_years,
                                     labels = high_water_years)

# long_plot_pages
miles_per_plot <- 60
long_plot_pgs <- razviz::long_plot_pages(hydro_model,
                                         high_water_events_df,
                                         miles_per_plot)

# gages
gage_csv <- system.file("extdata/longitudinal_profiles",
                        "gage_locations.csv", package = "razviz")
gages <- readr::read_csv(gage_csv)

## Remove double backslashes introduced by R import
gages$name <- gsub("\\n", "\n", gages$name, fixed=TRUE)

# gage_labels
stage_interval_label <- 5
gage_labels_df <- razviz::gage_labels(gages, stage_interval_label)

# gage_boxes
stage_interval_boxes <- 1
box_width <- 0.1
gage_boxes_df <- razviz::gage_boxes(gages, stage_interval_boxes, box_width)

# levees
levees_csv <- system.file("extdata/longitudinal_profiles",
                          "levees_authorized_existing.csv",
                          package = "razviz")
levees <- readr::read_csv(levees_csv)

# features
features_csv <- system.file("extdata/longitudinal_profiles",
                            "river_features.csv",
                            package = "razviz")
features <- readr::read_csv(features_csv)

# bridges
bridges_csv <- system.file("extdata/longitudinal_profiles",
                           "bridge_elevations.csv",
                           package = "razviz")
bridges <- readr::read_csv(bridges_csv)

# graph_colors https://wesandersonpalettes.tumblr.com, names from colors().
graph_colors <- c("2 Year"      = "darkslategray4",
                  "100 Year"    = "cadetblue3",
                  "500 Year"    = "coral3",
                  "100000 Year" = "burlywood3",
                  "2008"        = "red",
                  "2013"        = "red",
                  "2014"        = "red",
                  "LEFT"        = "palevioletred2",
                  "RIGHT"       = "palevioletred4")

# legend_labels
legend_labels <- c("2 Year", "100 Year", "500 Year", "100000 Year",
                   "2008", "2013", "2014",
                   "Left Bank", "Right Bank")

# title
plot_labels <- list("title" = "Upper Mississippi River Hydraulic Model - Guttenburg to Clarksville",
                    "x_axis" = "Miles Above the Ohio River",
                    "y_axis" = "Elevation (NAVD88 feet)")

# output_dir
output_dir <- "C:/temp"
if (!dir.exists(output_dir)) {dir.create(output_dir)}

filename <- "Longitudinal_Profile_Report.pdf"

# longitudinal_profile_report
razviz::longitudinal_profile_report(hydro_model = hydro_model_1,
                                    long_plot_pgs = long_plot_pgs,
                                    gages = gages,
                                    gage_labels_df = gage_labels_df,
                                    gage_boxes_df = gage_boxes_df,
                                    high_water = high_water_events_df,
                                    levees = levees,
                                    features = features,
                                    bridges = bridges,
                                    graph_colors = graph_colors,
                                    legend_labels = legend_labels,
                                    plot_labels = plot_labels,
                                    output_dir = output_dir,
                                    filename = filename)


test_that("longitudinal profile report", {
  expect_true(file.exists(file.path(output_dir,
                                    "Longitudinal_Profile_Report.pdf")))
})
