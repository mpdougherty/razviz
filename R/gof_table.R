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
#'                         "WSE" (water surface elevation), or "Q" (discharge).
#' @param output_format    character; The output format of the report. One
#'                         of "html_document", "word_document",
#'                         "pdf_document".
#'
#' @return a `kable` table object.
#'
gof_table <- function(gof_stats_df, run_num, metric, output_format) {
  # Set output format for kable
  if (output_format == "html_document") {
    options(knitr.table.format = "html")
    format <- "html"
  }
  if (output_format == "pdf_document") {
    options(knitr.table.format = "latex")
    format <- "latex"
  }
  if (output_format == "word_document") {
    options(knitr.table.format = "pandoc")
    format <- "pandoc"
  }

  # Create a table with a unique set of records for "Run_type", "Run_num"
  cal_gof <- unique(gof_stats_df[, c("Run_type", "Run_num")])

  # Get values from the cal_gof table for the current table
  run_type <- cal_gof[cal_gof$Run_num == run_num,]$Run_type

  # Build a table for the given metric
  metric_stats_WS <- gof_stats_df[,c(1:8)]
  metric_stats_Q <-  gof_stats_df[,c(1:5,9:11)]
  if(metric == "WSE"){
    metric_stats <- metric_stats_WS
  }else{
    metric_stats <- metric_stats_Q
    }


    # select the fields for the specified metric #

  # Set table characteristics
  digits <- c(2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3)
  align <- c("l", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r", "r")

  # Build column names
  #### these need to adjust to the number of events ####
  col_names <- c("River Mile", "R2", "RMSE", "MAE",
                               "R2", "RMSE", "MAE",
                               "R2", "RMSE", "MAE",
                               "R2", "RMSE", "MAE")

  # Create table column headers
  ## Create Event names
  event_names <- as.character(unique(metric_stats$Event))

  # Set the number of metrics per Event
  metrics_per_event <- rep(3, length(event_names))

  # Set column headers
  column_headers <- c(1, metrics_per_event)

  # Set header names
  column_names <- c("" , event_names)
  header <- setNames(column_headers, column_names)

  long_statistics <- tidyr::pivot_longer(metric_stats,
    cols = c(WS_R2, WS_RMSE, WS_MAE),
    names_to = "Type",
    values_to = "value")


  gof_table <- knitr::kable(x = long_statistics,
                            digits = digits,
                            align = align,
                            col.names = col_names,
                            caption = paste(run_type, run_num),
                            row.names = FALSE,
                            format = output_format)

  gof_table <- kableExtra::kable_styling(gof_table,
                                         full_width = F,
                                         position = "left",
                                         font_size = 10)

  gof_table <- kableExtra::add_header_above(gof_table,
                                            header = header)
  return(gof_table)
}
