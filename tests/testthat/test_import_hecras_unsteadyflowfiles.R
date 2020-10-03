context("import unsteady flow files")
library(razviz)
library(readr)
library(readtext)
library(stringr)

plan_events <- c(2001, 2014, 2019) #Replace with years for each event within the HEC-RAS plans


path <- system.file("extdata/hydrographs",
                                package = "razviz")

filelist = list.files(path, pattern="*.txt")

textfiles <- readtext::readtext(paste0(path,"/*.txt"), docvarsfrom = "filepaths")
for(i in 1:length(plan_events)){
  assign(paste0("UnsteadyFlowFile_",plan_events[i]),textfiles$text[i])
}

unsteadyflowfile_list <- mget(ls(pattern="UnsteadyFlowFile_"))

#Option #2 Manual

#UnsteadyFlowFile_2001 <- readtext::readtext(paste0(path,"/UnsteadyFlowObservedData_2001mod.txt"))
#UnsteadyFlowFile_2014 <- readtext::readtext(paste0(path,"/UnsteadyFlowObservedData_2014.txt"))
#UnsteadyFlowFile_2019 <- readtext::readtext(paste0(path,"/UnsteadyFlowObservedData_2019mod.txt"))
#unsteadyflowfile_list <- list(UnsteadyFlowFile_2001,UnsteadyFlowFile_2014,UnsteadyFlowFile_2019)

Formatted_UnsteadyFlowFileList <- razviz::import_hecras_unsteadyflowfiles(unsteadyflowfile_list = unsteadyflowfile_list,
                                                                  plan_events = plan_events)



test_that("import unsteady flow files", {
  expect_true(is.list(Formatted_UnsteadyFlowFileList))
  })


