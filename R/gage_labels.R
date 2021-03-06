#' @title Create Gage Labels
#'
#' @description Create a data frame of gage labels used by the longitudinal
#' profile plot to symbolize stage elevations.
#'
#' @export
#' @param gage_locations       data frame; A data frame of gage locations.
#' @param stage_interval_label numeric; The number of feet between gage stage
#'                             labels. Used to identify the location of gage
#'                             labels.
#'
#' @return A data frame of gage labels used by the `razviz` longitudinal profile
#' plot to label gage boxes.
#'
gage_labels <- function(gage_locations, stage_interval_label) {
  # Create the data frame to hold gage stage labels.
  gage_labels <- data.frame(name = character(),
                            river_mile = double(),
                            elevation = double(),
                            stage = double())

  # Iterate through gages to populate the gage stage labels.
  for (i in gage_locations$name) {
    gage       <- gage_locations[gage_locations$name == i, ]
    name       <- gage$name
    river_mile <- gage$river_mile

    # Identify min and max stage label, rounded to the nearest stage_gage_label.
    min_stage <- ceiling(gage$min_stage / stage_interval_label) * stage_interval_label
    max_stage <- floor(gage$max_stage / stage_interval_label) * stage_interval_label

    # Iterate through the min and max stages for each gage creating the labels.
    for (j in seq(min_stage, max_stage, by = stage_interval_label)) {
      elevation   <- gage$elevation + j
      stage       <- j
      gage_labels <- rbind(gage_labels,
                           data.frame(name = name,
                                      river_mile = river_mile,
                                      elevation = elevation,
                                      stage = stage))
    }
  }
  return(gage_labels)
}
