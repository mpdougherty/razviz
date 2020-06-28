#' @title Combine Hydrographs
#'
#' @description Combines a list of hydrograph data frames and standardizes the
#' column names.
#'
#' @export
#' @param hydrograph_list   list; A list of hydrograph event data frames.
#'
#' @return A data frame of hydrograph data with standardized column names.
#'
#' @importFrom dplyr bind_rows rename select
#'
combine_hydrographs <- function(hydrograph_list) {
  # Append all model runs and events
  hg <- dplyr::bind_rows(hydrograph_list)

  # Determine if data exported from RAS or DSSVue
  ras_col_names <- c("ModelCrossSection", "ModelRiver", "ModelReach", "Gague",
                     "Date", "Time",
                     "W.S. Elev", "Obs WS", "Modeled Q", "Obs Q")
  dssvue_col_names <- c("")

  if(all(ras_col_names %in% colnames(hydrograph_list[[1]]))) {
    # Standardize RAS export column names
    hg <- dplyr::rename(hg, River_Sta = "ModelCrossSection",
                            River     = "ModelRiver",
                            Reach     = "ModelReach",
                            Gage      = "Gague",
                            WS_Elev   = "W.S. Elev",
                            Obs_WS    = "Obs WS",
                            Model_Q   = "Modeled Q",
                            Obs_Q     = "Obs Q")
  }
  if(all(dssvue_col_names %in% colnames(hydrograph_list[[1]]))) {
    # Standardize DSSVue export column names
  }

  # Assign factors
  hg$River_Sta <- factor(as.numeric(hg$River_Sta))
  hg$River     <- factor(hg$River)
  hg$Reach     <- factor(hg$Reach)
  hg$Gage      <- factor(hg$Gage)
  hg$Event     <- factor(hg$Event)
  hg$Run_type  <- factor(hg$Run_type)
  hg$Run_num   <- factor(hg$Run_num)

  # Remove unnecessary fields
  hg <- dplyr::select(hg, River_Sta, River, Reach, Gage,
                          WS_Elev, Obs_WS, Model_Q, Obs_Q,
                          date, Event, Run_type, Run_num)

  return(hg)
}
