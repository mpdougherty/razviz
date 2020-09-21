context("hydrograph datatables")
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

dss_model_filename <- "razviz_ex_model.dss"
model_dss_file <- dssrip::opendss(paste0(path,"/", dss_model_filename), stopIfNew = TRUE)

time_interval <- "6HOUR"
plan_names <- c("UMR_PHASEIV_2001MOD-EVENT","UMR_PHASEIV_2014-EVENT","UMR_PHASEIV_2019MOD-EVENT")
plan_events <- c(2001, 2014, 2019)


filelist = list.files(path, pattern="*.txt")

textfiles <- readtext::readtext(paste0(path,"/*.txt"), docvarsfrom = "filepaths")

for(i in 1:length(plan_events)){
  assign(paste0("UnsteadyFlowFile_",plan_events[i]),textfiles$text[i])
}

unsteadyflowfile_list <- mget(ls(pattern="UnsteadyFlowFile_"))

Formatted_UnsteadyFlowFileList <- razviz::import_hecras_unsteadyflowfiles(
                                                    unsteadyflowfile_list = unsteadyflowfile_list,
                                                    plan_events = plan_events)

list_observed_data <- razviz::import_observed_data(observed_dss_file = observed_dss_file,
                                                    plan_events = plan_events,
                                                    Formatted_UnsteadyFlowFileList = Formatted_UnsteadyFlowFileList)



list_1Dmodel_data <- razviz::import_hecras_1Dmodel_data(model_dss_file = model_dss_file,
                                                plan_names = plan_names,
                                                plan_events = plan_events,
                                                time_interval = time_interval,
                                                Formatted_UnsteadyFlowFileList = Formatted_UnsteadyFlowFileList)



SA2D_CONNECTIONS <- read.csv(paste0(path,"/UMR_2DFLOWAREAS.csv"))

#Clean up data frame so that only 2D areas that have cross sections associated are kept.
SA2D_CONNECTIONS <- SA2D_CONNECTIONS[!(is.na(SA2D_CONNECTIONS$CX_RM) | SA2D_CONNECTIONS$CX_RM==""), ]

list_2Dmodel_data <- razviz::import_hecras_2Dmodel_data(model_dss_file = model_dss_file,
                                                  plan_names = plan_names,
                                                  plan_events = plan_events,
                                                  time_interval = time_interval,
                                                  Formatted_UnsteadyFlowFileList = Formatted_UnsteadyFlowFileList,
                                                  SA2D_CONNECTIONS = SA2D_CONNECTIONS)


#Identify if modeled data is a calibration run or final model
run_type <- "Calibration"
#Identify which calibration run it is
run_number <- 1

#Make a list of river miles where there are gage locations in the RAS model
Formatted_UnsteadyFlowFile <- Formatted_UnsteadyFlowFileList[[1]]
locations <- unique(Formatted_UnsteadyFlowFile$RiverMile)

hydrograph_datatables <- razviz::hydrograph_datatables(list_observed_data = list_observed_data,
                                                      list_1Dmodel_data = list_1Dmodel_data,
                                                      list_2Dmodel_data = list_2Dmodel_data,
                                                      locations = locations,
                                                      plan_events = plan_events,
                                                      run_type = run_type,
                                                      run_number = run_number)

test_that("hydrograph datatables", {
  expect_true(is.list(hydrograph_datatables))
})

hydrograph_datatable_no2D <- razviz::hydrograph_datatables(list_observed_data = list_observed_data,
                                                        list_1Dmodel_data = list_1Dmodel_data,
                                                        locations = locations,
                                                        plan_events = plan_events,
                                                        run_type = run_type,
                                                        run_number = run_number)





