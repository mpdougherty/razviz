#' @title Longitudinal Profile Report
#'
#' @description Create a Longitudinal Profile Report for the input RAS model.
#'
#' @export
#' @param hydro_model     data frame; A data frame of results from a RAS model.
#'                        See the package dataset for required fields.
#' @param long_plot_pgs   data frame; A data frame of longitudinal plot pages
#'                        produced by the `razviz::long_plot_pages` function.
#' @param gages           data frame. A data frame of gages. See package dataset
#'                        for required fields.
#' @param gage_labels_df  data frame; A data frame of gage labels produced by
#'                        the `razviz::gage_labels` function.
#' @param gage_boxes_df   data frame; A data frame of gage boxes produced by the
#'                        `razviz::gage_boxes` function.
#' @param high_water      data frame; A data frame of high water marks. See the
#'                        package dataset for required fields.
#' @param levees          data frame; A data frame of levee elevations. See the
#'                        package dataset for required fields.
#' @param features        data frame; A data frame of salient river features
#'                        (e.g., tributary confluences, cities, bridges, dams,
#'                        etc.). See package dataset for required fields.
#' @param bridges         data frame; A data frame of bridge opening elevations.
#'                        See package dataset for required fields.
#' @param graph_colors    character vector; A named character vector of colors
#'                        to use for each series.
#' @param legend_labels   character vector; A character vector of labels to be
#'                        used in the legend.
#' @param plot_labels     list; A list of plot labeling elements. Must contain
#'                        three named elements "title", "x_axis", and "y_axis".
#' @param output_dir      character; The path to the folder where the output
#'                        report will be written.
#'
#' @return A Longitudinal Profile Report in `pdf` document format.
#'
#' @importFrom grDevices pdf dev.off
#'
longitudinal_profile_report <- function(hydro_model, long_plot_pgs,
                                        gages, gage_labels_df, gage_boxes_df,
                                        high_water, levees,
                                        features, bridges,
                                        graph_colors, legend_labels, plot_labels,
                                        output_dir) {
  # Set the output document
  output_file <- file.path(output_dir, "Longitudinal_Profile_Report.pdf")
  grDevices::pdf(file = output_file, width = 16.5, height = 10.5)

  # Iterate through plot pages to produce longitudinal profile plots
  for (i in long_plot_pgs$plot) {
    # insert vertical white space so that the next figure is on a new page
    cat('\\newpage')
    # Set the current plot number
    plot_number <- long_plot_pgs[long_plot_pgs$plot == i, ]$plot
    # Create the longitudinal profile plot
    suppressWarnings(print(razviz::longitudinal_profile_plot(
                                            plot_number = plot_number,
                                            hydro_model = hydro_model,
                                            long_plot_pgs = long_plot_pgs,
                                            gages = gages,
                                            gage_labels_df = gage_labels_df,
                                            gage_boxes_df = gage_boxes_df,
                                            high_water = high_water,
                                            levees = levees,
                                            features = features,
                                            bridges = bridges,
                                            graph_colors = graph_colors,
                                            legend_labels = legend_labels,
                                            plot_labels = plot_labels)))
  }
  # Close the file and the graphics device
  grDevices::dev.off()
}
