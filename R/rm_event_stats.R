#' @title River Mile Event Statistics
#'
#' @description Calculates goodness of fit statistics between modeled and
#' observed values for a single "river mile event". A "river mile event" refers
#' to a flood event for a specific cross section (at a specific river mile).
#'
#' @export
#' @param hydrograph    data frame; A hydrograph data frame.
#' @param rm_event      numeric; A "river mile event" created by the `gof_stats`
#'                      function.
#' @param cal_stats     data frame; A `cal_stats` data frame produced by the
#'                      `got_stats` function. This table is used to store the
#'                      calculated goodness of fit statistics.
#'
#' @return A `cal_stats` data frame produced by the `gof_stats` function
#' populated with goodness of fit statistics for the specified "river mile
#' event".
#'
#' @importFrom dplyr filter
#' @importFrom tidyr pivot_wider
#'
rm_event_stats <- function(hydrograph, rm_event, cal_stats) {
  # Get values from the cal_stats table for the current rm_event
  run_type  <- cal_stats[cal_stats$rm_event == rm_event, ]$Run_type
  run_num   <- cal_stats[cal_stats$rm_event == rm_event, ]$Run_num
  river_sta <- cal_stats[cal_stats$rm_event == rm_event, ]$River_Sta
  event     <- cal_stats[cal_stats$rm_event == rm_event, ]$Event

  # Subset the cal data frame for the rm_event
  c <- dplyr::filter(hydrograph, Run_type == run_type,
                                 Run_num == run_num,
                                 River_Sta == river_sta,
                                 Event == event)

  # Convert from long to wide
  c_wide <- tidyr::pivot_wider(c,
                               names_from = Type,
                               values_from = value,
                               values_fn = mean)
  # Remove missing values
  c_wide_na <- na.omit(c_wide)

  # Calculate water surface goodness of fit statistics
  if (all(c("WS_Elev", "Obs_WS") %in% colnames(c_wide_na))) {
    if(all(!is.na(c_wide_na$WS_Elev)) & all(!is.na(c_wide_na$Obs_WS))) {
      # Create linear model of modeled water surface elevation
      rm_event_WS_lm <- lm(c_wide_na$WS_Elev ~ c_wide_na$Obs_WS,
                           data = c_wide_na)

      # Set R Squared for modeled water surface elevation
      cal_stats[cal_stats$rm_event == rm_event, ]$WS_R2 <-
        summary(rm_event_WS_lm)$r.squared

      # Set RMSE for modeled water surface elevation
      cal_stats[cal_stats$rm_event == rm_event,]$WS_RMSE <-
        sqrt(mean((c_wide_na$WS_Elev - c_wide_na$Obs_WS)^2))

      # Set Mean Average Error (MAE) for modeled water surface elevation
      cal_stats[cal_stats$rm_event == rm_event,]$WS_MAE <-
        mean(abs(c_wide_na$WS_Elev - c_wide_na$Obs_WS))
    }
  }

  # Calculate discharge goodness of fit statistics
  if (all(c("Model_Q", "Obs_Q") %in% colnames(c_wide))) {
    if(all(!is.na(c_wide_na$Model_Q)) & all(!is.na(c_wide_na$Obs_Q))) {
      # Create linear model of modeled water surface elevation
      rm_event_Q_lm <- lm(c_wide_na$Model_Q ~ c_wide_na$Obs_Q,
                          data = c_wide_na)

      # Set R Squared for modeled Q
      cal_stats[cal_stats$rm_event == rm_event, ]$Q_R2 <-
        summary(rm_event_Q_lm)$r.squared

      # Set RMSE for modeled Q
      cal_stats[cal_stats$rm_event == rm_event,]$Q_RMSE <-
        sqrt(mean((c_wide_na$Model_Q - c_wide_na$Obs_Q)^2))

      # Set Mean Average Error (MAE) for modeled Q
      cal_stats[cal_stats$rm_event == rm_event,]$Q_MAE <-
        mean(abs(c_wide_na$Model_Q - c_wide_na$Obs_Q))
    }
  }

  return(cal_stats)
}
