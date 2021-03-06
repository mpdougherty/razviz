#' @title Longitudinal Profile Plot
#'
#' @description Creates a longitudinal profile graph for the hydraulic
#' parameter named 'hydro_parameter'.
#'
#' @export
#' @param plot_number    numeric; The plot number to graph.
#' @param hydro_model    data frame; A data frame of results from a RAS model.
#'                       See the package dataset for required fields.
#' @param long_plot_pgs  data frame; A data frame of longitudinal plot pages
#'                       produced by the `razviz::long_plot_pages` function.
#' @param graph_colors   character vector; A named character vector of colors to
#'                       use for each series.
#' @param legend_labels  character vector; A character vector of labels to be
#'                       used in the legend.
#' @param plot_labels    list; A list of plot labeling elements. Must contain
#'                       three named elements "title", "x_axis", and "y_axis".
#' @param gages          data frame. Optional data frame of gages. See package
#'                       dataset for required fields.
#' @param gage_labels    data frame; Optional data frame of gage labels produced
#'                       by the `razviz::gage_labels` function.
#' @param gage_boxes     data frame; Optional data frame of gage boxes produced
#'                       by the `razviz::gage_boxes` function.
#' @param high_water     data frame; Optional data frame of high water marks.
#'                       See the package dataset for required fields.
#' @param levees         See the data frame; Optional data frame of levee elevations.
#'                       package dataset for required fields.
#' @param levee_smooth   logical; Draw a smoothed levee line? (Default FALSE)
#' @param features       data frame; Optional data frame of salient river features
#'                       (e.g., tributary confluences, cities, bridges, dams,
#'                       etc.). See package dataset for required fields.
#' @param bridges        data frame; Optional data frame of bridge opening elevations.
#'                       See package dataset for required fields.

#' @return A `ggplot2` object depicting the river longitudinal profile graph.
#'
#' @importFrom dplyr summarize group_by filter
#' @importFrom ggplot2 ggplot aes geom_line scale_color_manual theme_bw
#' coord_cartesian scale_x_reverse scale_y_continuous theme element_rect alpha
#' element_blank element_line labs geom_point geom_line geom_smooth unit
#' geom_path geom_text geom_errorbar
#' @importFrom scales squish
#' @importFrom ggrepel geom_label_repel geom_text_repel
#'
longitudinal_profile_plot <- function(plot_number, hydro_model, long_plot_pgs, levee_smooth = FALSE, graph_colors,
                                      legend_labels,plot_labels, ..., levees, gages, gage_labels_df, gage_boxes_df,
                                        high_water, features, bridges) {

  # Get values from the long_plot_pgs data frame for the current plot
  start_mile <- long_plot_pgs[long_plot_pgs$plot == plot_number,]$start_mile
  end_mile   <- long_plot_pgs[long_plot_pgs$plot == plot_number,]$end_mile
  plot_max_y <- long_plot_pgs[long_plot_pgs$plot == plot_number,]$plot_max_y
  plot_min_y <- long_plot_pgs[long_plot_pgs$plot == plot_number,]$plot_min_y

  # Subset data frames for the current plot
  hm <- hydro_model[hydro_model$River_Sta <= start_mile &
                    hydro_model$River_Sta >= end_mile,]


  # Create the basic plot with only water surface profile or parameter of interest
  p <- ggplot2::ggplot(data = hm,
                       aes(x = River_Sta, y = hydro_parameter, color = Event)) +
    geom_line(size = 2) +
    scale_color_manual(values = graph_colors, labels = legend_labels) +
    theme_bw() +
    coord_cartesian(ylim = c(plot_min_y, plot_max_y)) +
    scale_x_reverse(minor_breaks = seq(from = ceiling(start_mile),
                                       to = floor(end_mile), by = -1),
                    expand = c(0.01,0)) +
    scale_y_continuous(minor_breaks = seq(from = plot_min_y,
                                          to = plot_max_y, by = 1),
                       expand = c(0.01,0),
                       oob = scales::squish) +
    theme(legend.position = c(.99, .99),
          legend.justification = c("right", "top"),
          legend.background = element_rect(fill = alpha('white', 0.6)),
          legend.title = element_blank(),
          panel.grid.major = element_line(colour = "grey10", size = 0.1),
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "in")) +
    labs(title = plot_labels$title,
         x = plot_labels$x_axis,
         y = plot_labels$y_axis)


#Draw raw levee lines, existing elevation

  if(missing(levees)) {
    levee_line_raw <- NULL
    levee_line_labels <- NULL
  }else{ #if levee data is provided
    l  <- levees[levees$river_mile <= start_mile &
        levees$river_mile >= end_mile,]

    #Create levee labels for the current plot
        levee_labels <- dplyr::summarize(dplyr::group_by(l, levee, descending_bank),
                                     river_mile = mean(river_mile),
                                     elevation_NAVD88 = mean(elevation_NAVD88))

    #create a grob for ggplot
        levee_line_raw<- geom_line(inherit.aes = FALSE,
      data = l,
      aes(x = river_mile, y = elevation_NAVD88, group = levee,
        color = descending_bank),
      show.legend = FALSE, size = 0.2, alpha = 0.5)

    levee_line_labels <- geom_label_repel(inherit.aes = FALSE,
                                          data = levee_labels,
                                          aes(x = river_mile, y = elevation_NAVD88, label = levee,
                                          color = descending_bank),
                                          show.legend = FALSE, size = 2, force = 1,
                                          label.size = 0.1, segment.size = 0,
                                          box.padding = unit(0.1, "lines"),
                                          fill = alpha("white", 0.6))

    #Draw smooth levee lines, existing elevation
      if(levee_smooth == "TRUE"){
                levee_smooth_line <- geom_smooth(inherit.aes = FALSE,
                                      data = l,
                                      aes(x = river_mile,
                                      y = elevation_NAVD88, group = levee,
                                      color = descending_bank),
                                      method = "gam",
                                      formula = y ~ s(x, bs = "cs"),
                                      se = FALSE, size = 0.4)
      }else{
              leveee_smooth_line <- NA
            }
  }


if(missing(gages) & missing(gage_labels_df) & missing(gage_boxes_df)){
  gage_label_text <- NULL
  gage_box_shape <- NULL
  gage_stage_label <- NULL

}else{
  if(missing(gages) & !missing(gage_boxes_df)) {
      stop("Missing gage data, cannot make gage labels and boxes without gage data")
  }else{
    if(missing(gages) & !missing(gage_labels_df)) {
      stop("Missing gage data, cannot make gage labels and boxes without gage data")
    }else{
      if(!missing(gages) & missing(gage_labels_df)) {
        stop("Missing gage_labels_df, using gage_labels function to create gage_labels_df and add a parameter")
      }else{
        if(!missing(gages) & missing(gage_boxes_df)) {
          stop("Missing gage_boxes_df, use razviz::gage_boxes function to create gage_boxes_df and add a parameter")
        }else{

      #filter gage data
     g  <- gages[gages$river_mile <= start_mile &
                 gages$river_mile >= end_mile,]

    #Label gages
    gage_label_text <- geom_text_repel(inherit.aes = FALSE,
                        data = g,
                        aes(x = river_mile, y = (elevation + min_stage) + 2, label = name),
                        nudge_x = -0.4, angle = 90, size = 3, fontface = "bold",
                        force = 0.1, segment.size = 0)

    #filter gage box data
    gb <- gage_boxes_df[gage_boxes_df$river_mile <= start_mile &
                        gage_boxes_df$river_mile >= end_mile,]

    # Draw the gage boxes
    gage_box_shape <- geom_path(inherit.aes = FALSE,
                                data = gb,
                                aes(x = x, y = y, group = gage_stage),
                                size = 0.1)

    #Filter gage label data to make stage labels
    gl <- gage_labels_df[gage_labels_df$river_mile <= start_mile &
                          gage_labels_df$river_mile >= end_mile,]

     # Label gage stages
    gage_stage_label <- geom_text(inherit.aes = FALSE,
                                  data = gl,
                                  aes(x = river_mile, y = elevation, label = stage),
                                  hjust = 0, nudge_x = 0.1, size = 2.5)
    }
   }
  }
 }
}

#add river features
  if(missing(features)) {
    river_feature_label <- NULL
  }else{

    f  <- features[features$river_mile <= start_mile &
                   features$river_mile >= end_mile,]

  #Label river features
    river_feature_label <- geom_text_repel(inherit.aes = FALSE,
                           data = f,
                           aes(x = river_mile, y = rep(plot_min_y - 0, length(name)),label = name),
                           nudge_x = 0, angle = 90, size = 2.5,
                           force = 0.01, segment.size = 0)
  }

#add bridge elevation data
  if(missing(bridges)) {
   bridge_elevation_bar <- NULL
  }else{
    #filter

        b  <- bridges[bridges$river_mile <= start_mile &
        bridges$river_mile >= end_mile,]

    #Draw bridge elevations
    bridge_elevation_bar <- geom_errorbar(inherit.aes = FALSE,
                                          data = b,
                                          aes(x = river_mile, ymin = lowest_elevation, ymax = highest_elevation),
                                          width = 0.5, size = 0.5, color = "red4")
  }


#add high water marks
  if(missing(high_water)) {
    hw_points <- NULL
  }else{

    #filter
      hw <- high_water[high_water$river_mile <= start_mile &
                       high_water$river_mile >= end_mile,]

      if(is.factor(hw[["event"]]) == "TRUE"){
          #Draw high water marks
              hw_points <- geom_point(inherit.aes = FALSE,
                                      data = hw,
                                      aes(x = river_mile, y = elevation_NAVD88, color = event),
                                      show.legend = FALSE, size = 4)
    } else{ stop("'event' column in not factor. Please change class to factor")}
  }


return(p + levee_line_raw + levee_line_labels + gage_label_text + gage_box_shape + gage_stage_label +
            river_feature_label+ bridge_elevation_bar + hw_points)

}


