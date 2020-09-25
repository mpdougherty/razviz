#' @title Import csv files
#'
#' @description Imports a folder of `.csv` files manually exported
#' from the RAS GUI. See example data for formatting.
#'
#' @export
#' @param folder      character; Path to a folder of `.csv` files of RAS model
#'                    hydrograph `.csv` files.
#' @param event       character; The name of the model event.
#' @param run_number  numeric; The model run number. Used to label plot title.
#' @param run_type    character; The type of model run. Label used to in plot
#'                    title.
#' @param col_spec    readr::cols object; A column specification used to define
#'                    the columns of the input model results. Optional. Defaults
#'                    to the current RAS column names.
#'
#' @return A data frame of RAS model results.
#'
#' @importFrom readr cols col_character col_double
#' @importFrom tibble add_column
#'
import_csv_manualrasoutput <- function(folder, event, run_number,
                                   run_type = "Calibration",
                                   col_spec = NULL) {
  # Set default col_spec if not specified
  if (is.null(col_spec)) {
    col_spec = readr::cols("ModelCrossSection" = col_character(),
                           "ModelRiver"        = col_character(),
                           "ModelReach"        = col_character(),
                           "Gague"             = col_character(),
                           "Date"              = col_character(),
                           "Time"              = col_character(),
                           "W.S. Elev"         = col_double(),
                           "Obs WS"            = col_double(),
                           "Modeled Q"         = col_double(),
                           "Obs Q"             = col_double())
  }

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
