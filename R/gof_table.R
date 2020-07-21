#' @title Goodness of Fit Table
#'
#' @description Creates a table goodness of fit statistics for the specified
#' calibration run.
#'
#' @export
#' @param gof_stats_df     data frame: A data frame of goodness of fit
#'                         statistics produced by the `gof_stats` function.
#' @param run_num          numeric; The model run number.
#' @param metric           character; The metric to display. One of either
#'                         "WSE" (water surface elevation), or "discharge".
#'
#' @return a `kable` table object.
#'
gof_table <- function(gof_stats_df, run_num, metric) {
  # Create a table with a unique set of records for "Run_type", "Run_num"
  cal_gof <- unique(cal[, c("Run_type", "Run_num")])

  # Get values from the cal_gof table for the current table
  run_type <- cal_gof[cal_gof$Run_num == run_num,]$Run_type

  # Set table characteristics
  digits <- c(2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3)
  align <- c("l", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r")
  col_names <- c("River Mile", "R2", "RMSE", "MAE",
                               "R2", "RMSE", "MAE",
                               "R2", "RMSE", "MAE",
                               "R2", "RMSE", "MAE")

  gof_table <- kable(gof_stats_df,
                   digits = digits,
                   align = align,
                   col.names = col_names,
                   caption = paste(run_type, run_num),
                   row.names = FALSE,
                   format = "latex") %>%
    kable_styling(full_width = F, position = "left", font_size = 10) %>%
    add_header_above(c(" " = 1, "2008" = 3, "2013" = 3, "2014" = 3, "2017" = 3))
  return(gof_table)
}
