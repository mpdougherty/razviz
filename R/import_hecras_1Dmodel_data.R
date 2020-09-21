#' @title Import HEC-RAS 1D Model Data
#'
#' @description Imports data from dss file created from HEC-RAS model
#'
#' @export
#' @param model_dss_file   jobjRef; open dss file where observed data is stored hydrograph using dssrip.
#'
#' @param plan_names       list; list of the plan names as they are written in Part F of dss path.
#' @param plan_events      list; list of years of when events used in the plans occured.
#' @param time_interval    character; time interval chosen to run HEC-RAS model,matches Part E dss path.
#' @param Formatted_UnsteadyFlowFileList    list; list containing the unsteady flow data for each plan;
#'                                          output from import_hecras_unsteadyflowfiles function.

#' @return A list of data frames with the HEC-RAS model results.
#'
#' @importFrom readr cols col_character col_double
#' @importFrom tibble add_column
#'
import_hecras_1Dmodel_data <- function(model_dss_file, plan_names, plan_events, time_interval, Formatted_UnsteadyFlowFileList) {

  model_Stages_List  <- c()
  model_Flows_List  <- c()

  #Need to reduced the observed data to a single row for each cross section
  Formatted_UnsteadyFlowFile <- Formatted_UnsteadyFlowFileList[[1]] #assuming that have the same cross-sections for all plans
  Formatted_UnsteadyFlowFile_Unique <- Formatted_UnsteadyFlowFile[!duplicated(Formatted_UnsteadyFlowFile[,c("RiverMile")]),]

  Unique_model_ID_list <-c()
  for (i in 1:nrow(Formatted_UnsteadyFlowFile_Unique)){
    Unique_model_ID_flow <- paste0(Formatted_UnsteadyFlowFile_Unique[i,3], "FLOW", sep="")
    Unique_model_ID_stage <- paste0(Formatted_UnsteadyFlowFile_Unique[i,3], "STAGE", sep="")
    Unique_model_ID  <- c(Formatted_UnsteadyFlowFile_Unique[i,3], Unique_model_ID_flow, Unique_model_ID_stage)
    Unique_model_ID_list <- rbind(Unique_model_ID_list, Unique_model_ID)
  }

  model_Stages_List <- c()
  model_Flows_List <- c()
  model_DF_names_list <- c()

  for(i in 1:nrow(Formatted_UnsteadyFlowFile_Unique)){ #loop through each cross-section in unsteady flow file.
    for(j in 1:length(plan_events)){#loop through each plan that was modeled

      model_Stages <- paste0("/",trimws(as.character(Formatted_UnsteadyFlowFile_Unique[i,1]))," ",
        trimws(as.character(Formatted_UnsteadyFlowFile_Unique[i,2])),"/",
        Formatted_UnsteadyFlowFile_Unique[i,3],"/","STAGE","/","/",time_interval,"/",plan_names[j],"/")
      model_Stages_List  <- c(model_Stages_List , model_Stages)

      model_DF_names <- paste(Formatted_UnsteadyFlowFile_Unique[i,3],"OBS",Formatted_UnsteadyFlowFile[i,6], sep="_")
      model_DF_names_list <- c(model_DF_names_list, model_DF_names)


      model_Flows <- paste0("/",trimws(as.character(Formatted_UnsteadyFlowFile_Unique[i,1]))," ",
        trimws(as.character(Formatted_UnsteadyFlowFile_Unique[i,2])),"/",
        Formatted_UnsteadyFlowFile_Unique[i,3],"/","FLOW","/","/",time_interval,"/",plan_names[j],"/")
      model_Flows_List  <- c(model_Flows_List , model_Flows)

    } #start a new event_year
  }#start next RIVER LOCATION

  #Create a dataframe showing the model data that will be pulled from the dss file listed by location and plan.
  model_Paths_df <- cbind(model_Flows_List ,model_Stages_List)

  #LOAD DSS FILE
  model <- model_dss_file

  MOD_DF_Names<- c()

  #Make a list of river miles where there are gage locations in the RAS model
  Locations <- unique(Formatted_UnsteadyFlowFile$RiverMile)

  for(y in Locations){ #loop through each river mile locations
    subset_model <- as.data.frame(model_Paths_df[grepl(y, model_Paths_df)])
    subset_model_FLOW <- as.data.frame(subset_model[grep("FLOW", subset_model$`model_Paths_df[grepl(y, model_Paths_df)]`),])

    DSS_MODEL_AllFlowPlans <- c()
    for(x in 1: nrow(subset_model_FLOW)){
      pathname <- as.character(subset_model_FLOW[x,1])
      DSS_MODEL <- as.data.frame(dssrip::getFullTSC(model, pathname))
      #this dss file contains only the data not identifiers - need to add some columns
      #Adds a new column after column 1 with the river mile
      DSS_MODEL <- add_column(DSS_MODEL, Path = pathname, .after = 0)
      #Adds columns for each section of the path name (A/B/C/D/E/F)
      DSS_MODEL <-cbind(DSS_MODEL, str_split_fixed(DSS_MODEL[,1], c("/"),8))
      #Reorganizes the columns and removes blank columns
      DSS_MODEL <- DSS_MODEL[,c(4,5,6,8,9,1,2)]

      #Creates a new name to save the dataframe
      dfname <- paste("MODEL_DF_FLOW", y, plan_events[x], sep="_")
      #Saves the time series data that was taken out of DSS as a new dataframe in R
      #this data frame only has one of the models plans
      assign(dfname, DSS_MODEL)
      print(dfname)

      #creates a dataframe with all of the HEC-RAS plans/events for a particular location
      DSS_MODEL_AllFlowPlans <- rbind(DSS_MODEL_AllFlowPlans, DSS_MODEL)

    } #after all the model flows for all the plans are in one data frame we will assign the data frame a new name

    colnames(DSS_MODEL_AllFlowPlans) <- c("Model_A", "Model_B", "Model_C", "Model_E", "Model_F","Path_Flow","Model_Q")
    assign( paste0("model_Flows_",y),DSS_MODEL_AllFlowPlans)


    #Repeat this process for the stage or elevation data
    subset_model_STAGE <- as.data.frame(subset_model[grep("STAGE", subset_model$`model_Paths_df[grepl(y, model_Paths_df)]`),])
    DSS_MODEL_AllStagePlans <- c()
    for(x in 1: nrow(subset_model_FLOW)){
      pathname <- as.character(subset_model_STAGE[x,1])
      DSS_MODEL <- as.data.frame(dssrip::getFullTSC(model, pathname))

      #Adds a new column after column 1 with the river mile
      DSS_MODEL <- add_column(DSS_MODEL, Path = pathname, .after = 0)
      DSS_MODEL <-cbind(DSS_MODEL, str_split_fixed(DSS_MODEL[,1], c("/"),8))
      DSS_MODEL <- DSS_MODEL[,c(4,5,6,8,9,1,2)]

      dfname <- paste("MODEL_DF_STAGE", y, plan_events[x], sep="_")
      assign(dfname, DSS_MODEL)
      DSS_MODEL_AllStagePlans <- rbind(DSS_MODEL_AllStagePlans, DSS_MODEL)

    } #after all the modeled flows for all the plans are in one dataframe we will assign the dataframe a new name

    colnames(DSS_MODEL_AllStagePlans) <- c("Model_A", "Model_B", "Model_C", "Model_E", "Model_F","Path_Stage","WS_Elev")
    assign(paste0("model_Stages_",y), DSS_MODEL_AllStagePlans)

    model_Data <- merge(DSS_MODEL_AllFlowPlans, DSS_MODEL_AllStagePlans[,c(7,6)], by = 0)
    colnames(model_Data)[1]<-  "DAY.TIME"

    #saving all modeled timeseries together
    assign(paste0("model_RAS_DF_",y), model_Data)
    filename <- paste0("model_RAS_DF_",y,".csv")

  } #now start with a new river mile location

  MOD_RAS_DFList <- mget(ls(pattern="model_RAS_DF_"))


  return(MOD_RAS_DFList)
}
