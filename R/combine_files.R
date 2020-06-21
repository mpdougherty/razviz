#' @title Combine Model Results
#'
#' @description Combines a folder full of RAS model results in `.csv` format
#' into a single data frame.
#'
#' @export
#' @param path       character; Path to a folder of RAS model results.
#' @param pattern    character; A regular expression passed to the `dir`
#'                   function to select files in the specified folder. Optional.
#' @param col_types  readr::cols object; A column specification used to define
#'                   the columns of the input model results. Optional.
#'
#' @return A data frame containing all of the input RAS model results appended
#' together.
#'
#' @importFrom readr read_csv
#' @importFrom dplyr bind_rows
#'
combine_files <- function(path, pattern = NULL, col_types = NULL) {
  files <- dir(path, pattern = pattern, full.names = TRUE)
  tables <- lapply(X = files,
                   FUN = readr::read_csv,
                   col_types = col_types)
  df <- dplyr::bind_rows(tables)
  return(df)
}
