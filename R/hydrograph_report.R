#' @title Hydrograph Report
#'
#' @description Create a Hydrograph Report for the input RAS model.
#'
#' @export
#' @param hydrograph_df    data frame; A data frame produced by the
#'                         `razviz::lengthen_hydrographs` function.
#' @param hg_plot_pages    data frame; A data frame produced by the
#'                         `razviz::hydrograph_plot_pages` function.
#' @param output_dir       character; The path to the folder where the output
#'                         report will be written.
#'
#' @return Creates a Hydrograph Report in the output directory.
#'
#' @importFrom grDevices pdf dev.off
#' @importFrom grid grid.draw
#'
hydrograph_report <- function(hydrograph_df, hg_plot_pages, output_dir) {
  # Set the output document
  output_file <- file.path(output_dir, "Hydrograph_Plot_Report.pdf")
  grDevices::pdf(file = output_file, width = 8.5, height = 11)

  # Iterate through plots table to draw hydrograph plots
  for (i in hg_plot_pages$plot) {
    # Insert vertical white space so that the next figure is on a new page
    cat('\\newpage')

    # Set the current plot number
    plot_number <- hg_plot_pages[hg_plot_pages$plot == i, ]$plot

    # Create the longitudinal profile plots
    suppressWarnings(grid::grid.draw(razviz::hydrograph_plot(plot_number,
                                                             hydrograph_df,
                                                             hg_plot_pages)))
  }
  # Close the file and the graphics device
  grDevices::dev.off()
}
