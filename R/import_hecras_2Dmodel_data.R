#' @title Import HEC-RAS 2D Model Data
#'
#' @description Imports 'FLOW-TOTAL'  timeseries from SA Connections in dss file created from HEC-RAS model
#'
#' @export
#' @param model_dss_file   jobjRef; open dss file where observed data is stored hydrograph using dssrip.
#'
#' @param plan_names       list; list of the plan names as they are written in Part F of dss path.
#' @param plan_events      list; list of years of when events used in the plans occured.
#' @param time_interval    character; time interval chosen to run HEC-RAS model,matches Part E dss path.
#' @param Formatted_UnsteadyFlowFileList    list; list containing the unsteady flow data for each plan;
#'                                          output from import_hecras_unsteadyflowfiles function.

#' @return A list of data frames with the SA Connection timeseries from HEC-RAS model results.
#'
#' @importFrom readr cols col_character col_double
#' @importFrom tibble add_column
#'

import_hecras_2Dmodel_data <- function(model_dss_file, plan_names, plan_events, time_interval,
                                        Formatted_UnsteadyFlowFileList, SA2D_CONNECTIONS) {


  #Need to merge by the cross section at a particular river mile.
  SA_Modeled_Flows_List <- c()

    for(m in 1:nrow(SA2D_CONNECTIONS)){ #loop through the cross sections where 2D area will be added.
      for(n in 1:length(plan_names)){#loop through each plan that was modeled
            SA_Modeled_Flows <- paste0("/","SA CONNECTION","/",
          trimws(as.character(SA2D_CONNECTIONS[m,2])),"/",
                                   "FLOW-TOTAL","/",
                                    "/",
                                     time_interval,"/",
                                     plan_names[n],"/")
          SA_Modeled_Flows_List  <- c(SA_Modeled_Flows_List , SA_Modeled_Flows)
    }#start next event_year
  }#start next cross section location

  #LOAD DSS FILE
  model <- model_dss_file

  for(t in 1:length(SA_Modeled_Flows_List)){ #for each 2d area path name in the list
      pathname <- SA_Modeled_Flows_List[t]

      #extract timeseries from dss file using pathname
      DSS_2D_MODEL <- as.data.frame(dssrip::getFullTSC(model, pathname))

      #this dss file contains only the data not identifiers - need to add some columns
      DSS_2D_MODEL <- add_column(DSS_2D_MODEL, Path = pathname, .after = 0) #Adds a new column after column 1 with the pathname
      DSS_2D_MODEL <- cbind(DSS_2D_MODEL, str_split_fixed(DSS_2D_MODEL[,1], c("/"),8)) #splits the path name into columns
      DSS_2D_MODEL <- DSS_2D_MODEL[,c(4,5,6,8,9,1,2)] #reorganizes the dataframe to keep the columns of the pathnames

       #add column for event
       Event <- regmatches(DSS_2D_MODEL[1,  5], gregexpr("[[:digit:]]+", DSS_2D_MODEL[1,  5]))
       DSS_2D_MODEL$Event <- Event

  #Need to add the cross section information from SA2D_Connections, match by column B in csv and pathname
  for(r in 1:nrow(SA2D_CONNECTIONS)){ #loop through each SA connection to find the one that matches.
    if(SA2D_CONNECTIONS$B[r]== DSS_2D_MODEL[r,2]){
      #if the 2d connection name sections match
      DSS_2D_MODEL$CX_RM <- SA2D_CONNECTIONS$CX_RM[r]
      #Adds a column with the river mile that the 2D area should be added to
      dfname <- paste("SA_CONNECTION_FLOW", DSS_2D_MODEL$CX_RM[1], DSS_2D_MODEL$Event[1], sep="_")
      print(dfname)
      colnames(DSS_2D_MODEL) <- c( "SA_Connection","SA_Name" ,
                                    "Variable" ,"Time_Interval",
                                    "Plan_Name", "Path" ,"FLOW-TOTAL",
                                    "Event","CX_RM")
      assign(dfname, DSS_2D_MODEL)
      }#ends if statement
    }#start a new SA connection

} #start new SA connection path

SA_CONNECTION_DFList <- mget(ls(pattern="SA_CONNECTION_FLOW"))

  return(SA_CONNECTION_DFList)
}
