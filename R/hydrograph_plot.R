#' @title Hydrograph Plot
#'
#' @description Create a hydrograph plot.
#'
#' @export
#' @param plot_number      numeric; The plot number to graph.
#' @param hydrograph_df    data frame; A data frame produced by the
#'                         `razviz::lengthen_hydrographs` function.
#' @param hg_plot_pages    data frame; A data frame produced by the
#'                         `razviz::hydrograph_plot_pages` function.
#'
#' @return A ggplot object.
#'
#' @importFrom dplyr filter
#' @importFrom ggplot2 ggplot aes geom_line facet_grid theme_bw theme labs
#' scale_color_manual element_blank element_text scale_x_datetime unit
#' scale_linetype_manual
#' @importFrom grid textGrob gpar
#' @importFrom gridExtra grid.arrange
#'
hydrograph_plot <- function(plot_number, hydrograph_df, hg_plot_pages) {
  # Get values from the hg_plot_pages data frame for the current plot
  plot_df   <- dplyr::filter(hg_plot_pages, plot == plot_number)
  plot      <- plot_df$plot
  run_type  <- as.character(plot_df$Run_type)
  run_num   <- as.numeric(as.character(plot_df$Run_num))
  river_sta <- as.numeric(as.character(plot_df$River_Sta))

  # Filter for water observed and modeled surface records
  hg_df_plot <- dplyr::filter(hydrograph_df, River_Sta == river_sta,
                                             Run_type == run_type,
                                             Run_num == run_num)
  ws <- dplyr::filter(hg_df_plot, Type == "Obs_WS" | Type == "WS_Elev")

  # Filter for observed and modeled discharge records
  q  <- dplyr::filter(hg_df_plot, Type == "Obs_Q" | Type == "Model_Q")

  # Define colors https://wesandersonpalettes.tumblr.com; names from colors().
  WS_cols          <- c("WS_Elev" = "darkslategray4", "Obs_WS" = "coral3")
  Discharge_cols   <- c("Model_Q" = "darkslategray4", "Obs_Q"  = "coral3")

  # Define labels
  WS_labels        <- c("WS_Elev" = "Modeled", "Obs_WS" = "Observed")
  Discharge_labels <- c("Model_Q" = "Modeled", "Obs_Q"  = "Observed")

  # Define line types
  WS_line        <- c(WS_Elev = "solid", Obs_WS = "dashed")
  Discharge_line <- c(Model_Q = "solid", Obs_Q = "dashed")

  # Water surface elevation hydrograph
  ws_plot <- ggplot(data = ws,
                    aes(x = date, y = value, color = Type),
                    na.rm = TRUE) +
    geom_line(aes(linetype = Type) , size = 1) +
    scale_linetype_manual(values = WS_line, labels = WS_labels ) +
    facet_grid(. ~ Event, scales = "free") +
    theme_bw() +
    scale_color_manual(values = WS_cols, labels = WS_labels) +
    theme(legend.position = "bottom",
          legend.title = element_blank(),
          axis.title.x = element_blank(),
          axis.text.x  = element_text(angle = 50, hjust = 1)) +
    scale_x_datetime(date_labels = "%e %b",
                     date_breaks = "7 days",
                     date_minor_breaks = "1 day") +
    labs(y = "Elevation (NAVD88 feet)")

  # Discharge hydrograph
  q_plot <- ggplot(data = q,
                   aes(x = date, y = value/1000, color = Type),
                   na.rm = TRUE) +
    geom_line(aes(linetype = Type), size = 1) +
    scale_linetype_manual(values = Discharge_line, labels = Discharge_labels) +
    facet_grid(. ~ Event, scales = "free") +
    theme_bw() +
    scale_color_manual(values = Discharge_cols, labels = Discharge_labels) +
    theme(legend.position = "bottom",
          legend.title = element_blank(),
          axis.title.x = element_blank(),
          axis.text.x  = element_text(angle = 50, hjust = 1)) +
    scale_x_datetime(date_labels = "%e %b",
                     date_breaks = "7 days",
                     date_minor_breaks = "1 day") +
    labs(y = "Discharge (1000 cubic feet per second)")

  # Create title for plot group
  title <- textGrob(label = paste(ws$River, " River, ", ws$Reach,
                                  " Reach, River Mile ", ws$River_Sta,
                                  "\n", ws$Run_type, " #", ws$Run_num,
                                  sep = ""),
                    x = unit(0, "lines"), y = unit(0, "lines"),
                    hjust = 0, vjust = 0,
                    gp = gpar(fontsize = 12))

  # Create a grid to arrange the plots
  hg_plot <- grid.arrange(ws_plot, q_plot,
                          nrow = 2, ncol = 1,
                          widths = unit(7, "in"),
                          heights = unit(c(5, 5), "in"),
                          top = title,
                          clip = FALSE)
  return(hg_plot)
}
