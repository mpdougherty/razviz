#' @title Longitudinal Plot Pages
#'
#' @description Creates a data frame used to define the characteristics of
#' each longitudinal profile plot for a given set of RAS model results. This
#' function determines the number of graphs needed to display a longitudinal
#' profile for a given RAS model. These page characteristics are used by the
#' `longitudinal_profile_plot` function to build each graph.
#'
#' @export
#' @param hydro_model      data frame; A data frame of RAS model output.
#' @param high_water       data frame; A data frame of high water marks. See
#'                         package dataset `high_water_marks.csv` for format.
#' @param miles_per_plot   numeric; The number of river miles per longitudinal
#' profile plot.
#'
#' @return A data frame of plot dimensions for a given set of RAS model results.
#'
#' @importFrom tibble tibble
#'
long_plot_pages <- function(hydro_model, high_water, miles_per_plot) {
  # Min and Max functions to return zero if vector contains all NAs
  max0 <- function (x) ifelse(!all(is.na(x)), max(x, na.rm = TRUE), 0)
  min0 <- function (x) ifelse(!all(is.na(x)), min(x, na.rm = TRUE), 0)

  # Determine the number of plots needed
  num_plots <- ceiling((max(hydro_model$River_Sta) -
                        min(hydro_model$River_Sta)) /
                       miles_per_plot)

  # Create an empty plot_pages data frame to define page characteristics
  plot_pages <- tibble::tibble(plot       = 1:num_plots,
                               start_mile = as.numeric(rep(NA, num_plots)),
                               end_mile   = as.numeric(rep(NA, num_plots)),
                               max_y      = rep(0, num_plots),
                               mid_y      = rep(0, num_plots),
                               min_y      = rep(0, num_plots),
                               y_range    = rep(0, num_plots),
                               plot_max_y = rep(0, num_plots),
                               plot_min_y = rep(0, num_plots),
                               plot_dif_y = rep(0, num_plots))

  # Initialize beginning and ending river miles of the first plot
  plot_pages[1, ]$start_mile <- max(hydro_model$River_Sta)
  plot_pages[1, ]$end_mile   <- max(hydro_model$River_Sta) - miles_per_plot

  # Iterate through the remaining pages setting their start and end river miles
  if(num_plots > 1){
      for (j in 2:num_plots) {
      plot_pages[j, ]$start_mile <- plot_pages[j-1, ]$end_mile
      plot_pages[j, ]$end_mile   <- plot_pages[j, ]$start_mile - miles_per_plot
    }
   }

  # Determine the min and max y-axis values for each data series
  for (k in 1:num_plots) {
    # Set start and end mile for the current plot
    start_mile <- plot_pages[plot_pages$plot == k, ]$start_mile
    end_mile   <- plot_pages[plot_pages$plot == k, ]$end_mile

    # Subset relevant data frames for the current plot
    hm <-  hydro_model[hydro_model$River_Sta <= start_mile &
                       hydro_model$River_Sta >= end_mile, ]
    hw <-  high_water[high_water$river_mile <= start_mile &
                      high_water$river_mile >= end_mile, ]

    # Set plot_pages$max_y
    aa <- c(max0(hm$hydro_parameter), max0(hw$elevation_NAVD88))
    plot_pages[plot_pages$plot == k, ]$max_y <- max0(aa[aa > 0])

    # Set plot_pages$min_y
    bb <- c( min0(hm$hydro_parameter), min0(hw$elevation_NAVD88) )
    plot_pages[plot_pages$plot == k, ]$min_y <- min0(bb[bb > 0])

    # Calculate y range
    plot_pages[plot_pages$plot == k, ]$y_range <- plot_pages[plot_pages$plot == k, ]$max_y -
                                                  plot_pages[plot_pages$plot == k, ]$min_y

    # Calculate mid y
    plot_pages[plot_pages$plot == k,]$mid_y <- plot_pages[plot_pages$plot == k, ]$max_y -
                                               (plot_pages[plot_pages$plot == k, ]$y_range / 2)
  }

  # Determine the max y range for all of the plots
  plot_y_range <- ceiling(max(plot_pages$y_range))

  # Set plot_max_y, plot_min_y, and plot_dif_y
  for (l in 1:num_plots) {
    plot_pages[l, ]$plot_max_y <- ceiling(plot_pages[l,]$mid_y +
                                          (plot_y_range / 2))
    plot_pages[l, ]$plot_min_y <- floor(plot_pages[l,]$mid_y -
                                        (plot_y_range / 2))
    plot_pages[l, ]$plot_dif_y <- plot_pages[l,]$plot_max_y -
                                  plot_pages[l,]$plot_min_y
  }
  return(plot_pages)
}
