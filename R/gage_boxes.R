#' @title Create Gage Boxes
#'
#' @description Create a data frame of gage boxes used by the longitudinal
#' profile plot to symbolize the location of gages and the stage elevations.
#'
#' @param stage_interval_boxes numeric; The interval used for drawing tick
#'                             marks on gage boxes (units: feet).
#' @param box_width            numeric; The width of the gage box (units:
#'                             river miles)
#'
#' @return A data frame of dimensions used by the `razviz` longitudinal profile
#' plot to draw gage boxes.
#'
gage_boxes <- function(gage_locations, stage_interval_boxes, box_width) {
  # Create the data frame to hold gage stage boxes
  gage_boxes <- data.frame(gage_stage = character(),
                           river_mile = double(),
                           x = double(),
                           y = double())

  # Iterate through gages to create gage stage boxes
  for (i in gage_locations$name) {
    gage       <- gage_locations[gage_locations$name == i, ]
    name       <- gage$name
    river_mile <- gage$river_mile
    min_stage  <- gage$min_stage
    max_stage  <- gage$max_stage

    # Iterate through the min and max stages for each gage creating the boxes.
    for (j in seq(min_stage, max_stage, by = stage_interval_boxes)) {
      elevation  <- gage$elevation + j
      stage      <- j
      gage_stage <- paste(name, stage)

      # Calculate box coordinates for current stage.
      ## Box coordinate 1 starts in the lower left corner.
      gage_box_1 <- data.frame(gage_stage = gage_stage,
                               river_mile = river_mile,
                               x = river_mile + (box_width / 2),
                               y = elevation)
      gage_box_2 <- data.frame(gage_stage = gage_stage,
                               river_mile = river_mile,
                               x = river_mile + (box_width / 2),
                               y = elevation + 1)
      gage_box_3 <- data.frame(gage_stage = gage_stage,
                               river_mile = river_mile,
                               x = river_mile - (box_width / 2),
                               y = elevation + 1)
      gage_box_4 <- data.frame(gage_stage = gage_stage,
                               river_mile = river_mile,
                               x = river_mile - (box_width / 2),
                               y = elevation)
      gage_box_5 <- data.frame(gage_stage = gage_stage,
                               river_mile = river_mile,
                               x = river_mile + (box_width / 2),
                               y = elevation)

      # Append box coordinates for current stage to the gage_boxes data frame
      gage_boxes <- rbind(gage_boxes, gage_box_1, gage_box_2, gage_box_3,
                          gage_box_4, gage_box_5)
    }
  }
  return(gage_boxes)
}
