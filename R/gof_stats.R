#' @title Goodness of Fit Statistics
#'
#' @description Computes a goodness of fit statistics data frame between the
#' modeled and observed data in the input hydrograph data frame.
#'
#' @export
#' @param hydrograph      data frame; A hydrograph data frame in long format.
#'
#' @return A data frame of goodness of fit statistics for the between the
#' modeled and observed data in the input hydrograph data frame.
#'
#' @importFrom dplyr arrange
#' @importFrom tibble add_column
#'


gof_stats <- function(hydrograph) {

  # Create table with unique records Run_type, Run_num, River_Sta, and Event
  calibration_stats <- as.data.frame(unique(hydrograph[, c("Run_type", "Run_num",
                                     "River_Sta", "Event")]))

  # Sort the table by "Run_type", "Run_num", "Event", "River_Sta"
  calibration_stats <- dplyr::arrange(calibration_stats,
                              Run_type, Run_num, Event, desc(River_Sta))

  # Create a column to represent "river mile events"
  calibration_stats <- tibble::add_column(calibration_stats,
                                  rm_event = 1:length(calibration_stats$Run_type),
                                  .before = 1)

  # Add goodness-of-fit statistic fields to calibration_stats
  # Water surface
  calibration_stats <- tibble::add_column(calibration_stats,
                                  WS_R2 = as.numeric(rep(NA,
                                          times = length(calibration_stats$rm_event))))
  calibration_stats <- tibble::add_column(calibration_stats,
                                  WS_RMSE = as.numeric(rep(NA,
                                          times = length(calibration_stats$rm_event))))
  calibration_stats <- tibble::add_column(calibration_stats,
                                  WS_MAE  = as.numeric(rep(NA,
                                          times = length(calibration_stats$rm_event))))
  # Discharge
  calibration_stats <- tibble::add_column(calibration_stats,
                                  Q_R2 = as.numeric(rep(NA,
                                           times = length(calibration_stats$rm_event))))
  calibration_stats <- tibble::add_column(calibration_stats,
                                  Q_RMSE = as.numeric(rep(NA,
                                           times = length(calibration_stats$rm_event))))
  calibration_stats <- tibble::add_column(calibration_stats,
                                  Q_MAE  = as.numeric(rep(NA,
                                           times = length(calibration_stats$rm_event))))


  # Iterate through the calibration_stats table and calculate stats
  for (j in calibration_stats$rm_event) {
    # Set the current rm_event
    rm_event <- calibration_stats[calibration_stats$rm_event == j, ]$rm_event

    # Call the goodness-of-fit stats function for the current event
    calc_statistics <- razviz::rm_event_stats(hydrograph=hydrograph,
                                              rm_event=rm_event,
                                              cal_stats = calibration_stats)

  }
  return(calc_statistics)
}
