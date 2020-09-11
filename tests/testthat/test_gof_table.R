context("gof_table")
library(razviz)

# Import hydrograph data
hydrograph_csv <- system.file("extdata/hydrographs", "LD10.csv",
                              package = "razviz")
hydrograph <- readr::read_csv(hydrograph_csv)

# Calculate goodness of fit statistics
gof_stats_df <- gof_stats(hydrograph)

run_num = 1
metric = "WSE"
output_format = "word_document"

table <- gof_table(gof_stats_df = gof_stats_df,
                   run_num = run_num,
                   metric = metric,
                   output_format = output_format)
