context("longitudinal profile plot")
library(razviz)

# hydro_model
path <- system.file("extdata", package = "razviz")
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

# plot_num
plot_number <- 1

# high_water
high_water_csv <- system.file("extdata", "high_water_marks.csv",
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
long_plot_pages_df <- razviz::long_plot_pages(hydro_model,
                                              high_water_events_df,
                                              miles_per_plot)

# gages
gage_csv <- system.file("extdata", "gage_locations.csv", package = "razviz")
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
levees_csv <- system.file("extdata", "levees_authorized_existing.csv",
                          package = "razviz")
levees <- readr::read_csv(levees_csv)

# features
features_csv <- system.file("extdata", "river_features.csv",
                            package = "razviz")
features <- readr::read_csv(features_csv)

# bridges
bridges_csv <- system.file("extdata", "bridge_elevations.csv",
                           package = "razviz")
bridges <- readr::read_csv(bridges_csv)

# graph_colors https://wesandersonpalettes.tumblr.com, names from colors().
cols <- c("2 Year"      = "darkslategray4",
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
title <- "Upper Mississippi River Hydraulic Model - A to B"

# longitudinal_profile_plot
plot <- razviz::longitudinal_profile_plot(hydro_model = hydro_model_1,
                                          plot_num = plot_number,
                                          long_plot_pages = long_plot_pages_df,
                                          gages = gages,
                                          gage_labels = gage_labels_df,
                                          gage_boxes = gage_boxes_df,
                                          high_water = high_water_events_df,
                                          levees = levees,
                                          features = features,
                                          bridges = bridges,
                                          graph_colors = cols,
                                          legend_labels = legend_labels,
                                          title = title)
print(plot)

