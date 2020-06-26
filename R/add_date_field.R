#' @title Add Date Field
#'
#' @description Calculates a new POSIXct `date` field built from the character
#' `Date` and `Time` fields exported from HEC-DSSVue.
#'
#' @export
#' @param df         data frame; A data frame of RAS results exported from
#'                   HEC-DSSVue.
#'
#' @return The input data frame with a new POSIXct `date` field.
#'
#' @importFrom stringr str_replace
#' @importFrom lubridate parse_date_time
#'
add_date_field <- function(df) {
  # Concatenate Date and Time fields into a single character field
  df <- tibble::add_column(df,
                           date_string = paste(df$Date, df$Time))

  # Replace date times with time = 24:00 hour (invalid) to time = 23:59 hour
  df$date_string <- stringr::str_replace(df$date_string,
                                         pattern = ".(24:00)$",
                                         replacement = " 23:59")

  # Guess the date time formats
  check_orders <- c("%d %b %Y %H:%M", "%d-%b-%Y %H:%M")
  guesses <- lubridate::guess_formats(df$date_string, orders = check_orders)
  orders <- unique(guesses)

  # Parse date time character string of the form "30 April 2008 06:00"
  df$date <- lubridate::parse_date_time(x = df$date_string,
                                        orders = orders)
  return(df)
}
