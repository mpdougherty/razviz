#' @title High Water Events
#'
#' @description Filter a data frame of high water marks for a specific list of
#' high water marks.
#'
#' @export
#' @param high_water     data frame; A data frame of high water marks. See the
#'                       package dataset for the required fields.
#' @param events         character vector; A character vector of high water
#'                       event years (i.e., c("1993", "2008")).
#'
#' @return A data frame of high_water_events filtered by the `event` years.
#'
#' @importFrom lubridate mdy year
#' @importFrom dplyr filter
#'

high_water_events <- function(high_water, events) {
  # Ensure that the peak_date field is formated correctly
  high_water$peak_date <- lubridate::mdy(high_water$peak_date)

  # Create `event` field as year of `peak_date` field
  high_water$event <- as.character(lubridate::year(high_water$peak_date))

  # Filter for the desired list of high water event years
  high_water <- dplyr::filter(high_water, event %in% events)

  # Set Event as an ordered factor
  high_water$event <- factor(high_water$event,
                             levels = events,
                             labels = events)

  return(high_water)
}
