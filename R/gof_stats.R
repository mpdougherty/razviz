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
  cal_stats <- unique(hydrograph[, c("Run_type", "Run_num",
                                     "River_Sta", "Event")])

  # Sort the table by "Run_type", "Run_num", "Event", "River_Sta"
  cal_stats <- dplyr::arrange(cal_stats,
                              Run_type, Run_num, Event, desc(River_Sta))

  # Create a column to represent "river mile events"
  cal_stats <- tibble::add_column(cal_stats,
                                  rm_event = 1:length(cal_stats$Run_type),
                                  .before = 1)

  # Add goodness-of-fit statistic fields to cal_stats
  # Water surface
  cal_stats <- tibble::add_column(cal_stats,
                                  WS_R2 = as.numeric(rep(NA,
                                          times = length(cal_stats$rm_event))))
  cal_stats <- tibble::add_column(cal_stats,
                                  WS_RMSE = as.numeric(rep(NA,
                                          times = length(cal_stats$rm_event))))
  cal_stats <- tibble::add_column(cal_stats,
                                  WS_MAE  = as.numeric(rep(NA,
                                          times = length(cal_stats$rm_event))))
  # Discharge
  cal_stats <- tibble::add_column(cal_stats,
                                  Q_R2 = as.numeric(rep(NA,
                                           times = length(cal_stats$rm_event))))
  cal_stats <- tibble::add_column(cal_stats,
                                  Q_RMSE = as.numeric(rep(NA,
                                           times = length(cal_stats$rm_event))))
  cal_stats <- tibble::add_column(cal_stats,
                                  Q_MAE  = as.numeric(rep(NA,
                                           times = length(cal_stats$rm_event))))

  # Iterate through the cal_stats table and calculate stats
  for (j in cal_stats$rm_event) {
    # Set the current rm_event
    rm_event <- cal_stats[cal_stats$rm_event == j, ]$rm_event

    # Call the goodness-of-fit stats function for the current event
    cal_stats <- rm_event_stats(hydrograph, rm_event, cal_stats)
  }
  return(cal_stats)
}
