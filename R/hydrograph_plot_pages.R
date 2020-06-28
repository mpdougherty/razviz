#' @title Hydrograph Plot Pages
#'
#' @description Creates a data frame used to determine the number of hydrograph
#' plot pages needed for .
#'
#' @export
#' @param hydrograph_df    data frame; A data frame produced by the
#'                         `razviz::lengthen_hydrographs` function.
#'
#' @return A data frame defining the hydrograph plot pages needed for the input
#' hydrographs data frame.
#'
#' @importFrom dplyr arrange
#' @importFrom tibble add_column
#'
hydrograph_plot_pages <- function(hydrograph_df) {
  # Identify unique set of records for "Run_type", "Run_num", "River_Sta"
  plots <- unique(hydrograph_df[, c("Run_type", "Run_num", "River_Sta")])

  # Sort the cal_plots table
  plots <- dplyr::arrange(plots, Run_type, Run_num, desc(River_Sta))

  # Create a column to represent plot numbers
  plots <- add_column(plots, plot = 1:length(plots$Run_type), .before = 1)

  return(plots)
}
