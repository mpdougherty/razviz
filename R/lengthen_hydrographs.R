#' @title Lengthen Hydrographs
#'
#' @description Converts a data frame of RAS hydrograph export data from
#' wide to long format required for plotting.
#'
#' @export
#' @param hydrograph_df    data frame; A data frame of RAS hydrograph export
#'                         data.
#'
#' @return A data frame of RAS hydrograph export data in long format.
#'
#' @importFrom tidyr pivot_longer
#'
lengthen_hydrographs <- function(hydrograph_df) {
  long_hydrograph <- tidyr::pivot_longer(hydrograph_df,
                                         cols = c(WS_Elev, Obs_WS, Model_Q,
                                                  Obs_Q),
                                         names_to = "Type",
                                         values_to = "value")

  # Assign factors
  long_hydrograph$Type <- factor(long_hydrograph$Type,
                                 levels = c("WS_Elev","Model_Q","Obs_Q","Obs_WS"),
                                 labels = c("WS_Elev","Model_Q","Obs_Q","Obs_WS"))

  return(long_hydrograph)
}
