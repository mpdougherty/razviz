context("import observed data")
library(razviz)
library(readr)
library(readtext)
library(stringr)

software_file <- system.file("development/HEC-DSSVue-v3.0.00.212/HEC-DSSVue-v3.0.00.212", package = "razviz")
options(dss_location=software_file)

library(rJava)
library(dssrip)

#to remove scientific notation
options(scipen=999)

path <- system.file("extdata/hydrographs", package = "razviz")
dss_observed_filename <- "razviz_ex_observed.dss"

observed_dss_file <- dssrip::opendss(paste0(path,"/", dss_observed_filename), stopIfNew = TRUE)

#TIME IN DSS IS DIFFERENT THAN TIME STORAGE IN R
test <-as.data.frame(dssrip::getTSC(observed_dss_file, "/MISSISSIPPI RIVER/HWY 610 IN BROOKLYN PARK, MN/FLOW//15MIN/USGS/"))
head(test)


plan_events <- c(2001, 2014, 2019) #Replace with years for each event within the HEC-RAS plans

path <- system.file("extdata/hydrographs",
  package = "razviz")

filelist = list.files(path, pattern="*.txt")

textfiles <- readtext::readtext(paste0(path,"/*.txt"), docvarsfrom = "filepaths")

for(i in 1:length(plan_events)){
  assign(paste0("UnsteadyFlowFile_",plan_events[i]),textfiles$text[i])
}

unsteadyflowfile_list <- mget(ls(pattern="UnsteadyFlowFile_"))

Formatted_UnsteadyFlowFileList <- razviz::import_unsteadyflowfile(
                                              unsteadyflowfile_list = unsteadyflowfile_list,
                                              plan_events = plan_events)

observed_Q_WS_df_list <- razviz::import_observed_data(observed_dss_file = observed_dss_file,
                                                         Formatted_UnsteadyFlowFileList = Formatted_UnsteadyFlowFileList,
                                                         plan_events = plan_events)

test_that("import observed data", {
  expect_true(is.list(observed_Q_WS_df_list))
})


