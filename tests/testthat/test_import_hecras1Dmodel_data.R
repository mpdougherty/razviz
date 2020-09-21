context("import model1d data")
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
dss_observed_filename <- "razviz_ex_model.dss"

model_dss_file <- dssrip::opendss(paste0(path,"/", dss_observed_filename), stopIfNew = TRUE)

time_interval <- "6HOUR"
plan_names <- c("UMR_PHASEIV_2001MOD-EVENT","UMR_PHASEIV_2014-EVENT","UMR_PHASEIV_2019MOD-EVENT")
plan_events <- c(2001, 2014, 2019)


path <- system.file("extdata/hydrographs",
  package = "razviz")

filelist = list.files(path, pattern="*.txt")

textfiles <- readtext::readtext(paste0(path,"/*.txt"), docvarsfrom = "filepaths")

for(i in 1:length(plan_events)){
  assign(paste0("UnsteadyFlowFile_",plan_events[i]),textfiles$text[i])
}

unsteadyflowfile_list <- mget(ls(pattern="UnsteadyFlowFile_"))

Formatted_UnsteadyFlowFileList <- razviz::import_hecras_unsteadyflowfiles(
  unsteadyflowfile_list = unsteadyflowfile_list,
  plan_events = plan_events)



List_1Dmodel_data <- import_hecras_1Dmodel_data(model_dss_file = model_dss_file,
                                                  plan_names = plan_names,
                                                  plan_events = plan_events,
                                                  time_interval = time_interval,
                                                  Formatted_UnsteadyFlowFileList = Formatted_UnsteadyFlowFileList)



test_that("import model1d data", {
  expect_true(is.list(List_1Dmodel_data))
})


