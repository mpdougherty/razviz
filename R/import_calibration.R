#' @title Import Calibration
#'
#' @description Imports a folder of RAS model results exported using DSSVue
#' in `.csv` format
#'
#' @export
#' @param folder      character; Path to a folder of `.csv` files of RAS model
#'                    result exports
#' @param event       character; The name of the model event.
#' @param run_number  numeric; The model run number.
#' @param run_type    character; The type of model run. Label used to in plot
#'                    title.
#' @param col_spec    readr::cols object; A column specification used to define
#'                    the columns of the input model results. Optional.
#'
#' @return A data frame of RAS model results.
#'
#' @importFrom tibble add_column
#'
import_calibration <- function(folder, event, run_number,
                               run_type = "Calibration",
                               col_spec = NULL) {
  # Import a folder of RAS model .csv exports
  df <- razviz::combine_files(path = folder, col_spec = col_spec)

  # Convert text date and time into POSIXct date
  df <- razviz::add_date_field(df)

  # Add new columns
  df <- tibble::add_column(df,
                           Event = event,
                           Run_type = run_type,
                           Run_num = run_number)
  return(df)
}
