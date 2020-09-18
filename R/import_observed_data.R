#' @title Import observed data
#'
#' @description Imports observed data from a dss file. All observed data needs
#' to be in one dss file and the pathnames should be exactly the same as what
#' is in unsteady flow file from HEC-RAS.  It is okay if the dss file name does not
#' match the dss file name from the unsteady flow file. Different versions of
#' HEC-DSSVue may change how the Part E (typically time interval: MIN, HOUR) is written.
#'
#' @export
#' @param folder      character; Path to a folder of `.csv` files of RAS model
#'                    hydrograph `.csv` files.
#' @param event       character; The name of the model event.
#' @param run_number  numeric; The model run number. Used to label plot title.
#' @param run_type    character; The type of model run. Label used to in plot
#'                    title.
#' @param col_spec    readr::cols object; A column specification used to define
#'                    the columns of the input model results. Optional. Defaults
#'                    to the current RAS column names.
#'
#' @return A data frame of RAS model results.
#'
#' @importFrom readr cols col_character col_double
#' @importFrom tibble add_column
#'




import_observed_data <- function(observed_dss_file,
                                   Formatted_UnsteadyFlowFileList,
                                   plan_events) {

  #establish dataframe to check timeseries data
  #DSS stores NA values as really small negative numbers which are not possible for
  check_all <- c()


  #loop through each of the Formatted Unsteady Flow Files pathnames and pull the files out of dss
  for(p in 1:length(plan_events)){
    Formatted_UnsteadyFlowFile <- Formatted_UnsteadyFlowFileList[[p]]
    event_year <- plan_events[p]

    #Recreate the paths for those DSS files
    Observed_Pathnames_Formatted <-c()

    for(j in 1:nrow(Formatted_UnsteadyFlowFile)){ #for each row in the data frame
      Formmated_Pathname <- paste0("/",Formatted_UnsteadyFlowFile[j,4],"/",
        Formatted_UnsteadyFlowFile[j,5],"/",
        Formatted_UnsteadyFlowFile[j,6],"/",
        "/",
        Formatted_UnsteadyFlowFile[j,8],"/",
        Formatted_UnsteadyFlowFile[j,9],"/")

      Observed_Pathnames_Formatted  <- c(Observed_Pathnames_Formatted , Formmated_Pathname)
    }

#now that we have all the path names, need to loop through a extract them from the dss file and rename the columns and dataframe.

    for(z in 1:length(Observed_Pathnames_Formatted)){ #loop through each path and make a data frame
      pathname <- Observed_Pathnames_Formatted[z]

      DSS_OBSERVED <-as.data.frame(dssrip::getFullTSC(observed_dss_file, pathname))

      check <- summary(DSS_OBSERVED <= -100000)
      check_all <- cbind(check_all, check[2])

      #for some reason why data brought in from DSS, missing data comes in as a very large negative numbers
      DSS_OBSERVED[DSS_OBSERVED <= -100000] <- NA


      if(Formatted_UnsteadyFlowFile$Observed_C[z] == "FLOW"){
        colnames(DSS_OBSERVED) <- "Obs_Q"
      } else {
        colnames(DSS_OBSERVED) <- "Obs_WS"
      }

      DSS_OBSERVED <- tibble::rownames_to_column(DSS_OBSERVED, "DAY.TIME") #moving date from row name into the first column
      #Adds a new column after column 1 with the river mile
      DSS_OBSERVED <- add_column(DSS_OBSERVED, River_Sta = Formatted_UnsteadyFlowFile[z,3], .after = 1)
      #Adds a new column after column 2 with the river
      DSS_OBSERVED <- add_column(DSS_OBSERVED, River = Formatted_UnsteadyFlowFile[z,1], .after = 2)
      #Adds a new column after column 3 with the river reach
      DSS_OBSERVED <- add_column(DSS_OBSERVED, Reach = Formatted_UnsteadyFlowFile[z,2], .after = 3)
      #Adds a new column after column 1 with the gage location
      DSS_OBSERVED <- add_column(DSS_OBSERVED, Gage_Location = Formatted_UnsteadyFlowFile[z,5], .after = 4)

      #warnings will appear if the date is not in that format
      DAY.TIME.FORMAT <- parse_datetime(DSS_OBSERVED$DAY.TIME,format = "%Y-%m-%d %H:%M:%S")


      format <- sapply(DAY.TIME.FORMAT , function(x) !all(is.na(as.Date(as.character(x), format=c('%Y-%m-%d',' %h:%m:%s')))))

      name <- paste("obs_data",Formatted_UnsteadyFlowFile[z,6],Formatted_UnsteadyFlowFile[z,3], event_year, sep="_")

      if(format[[1]]== "TRUE"){ #check formatting of date column in the dss file that was pulled
        DSS_OBSERVED <- add_column(DSS_OBSERVED, UnsteadyFlowFile = event_year)
        #identifies which unsteady flow file used this observed data
        assign(name, DSS_OBSERVED)
      }else{
        #need to add a time stamp of  12.00 - for daily average values from USGS
        DSS_OBSERVED$DAILYTIME <- "23:59:00"
        #Concatenate Date and Time fields into a single character field
        DSS_OBSERVED$date_string <- paste(DSS_OBSERVED$DAY.TIME, DSS_OBSERVED$DAILYTIME)
        #Reformat data frame back two columns
        DSS_OBSERVED <-  DSS_OBSERVED[,c(8,2:6)]
        colnames(DSS_OBSERVED)[1] <- "DAY.TIME"
        #identifies which unsteady flow file used this observed data
        DSS_OBSERVED <- add_column(DSS_OBSERVED, UnsteadyFlowFile = event_year)
        assign(name, DSS_OBSERVED)
      }
    } #start with a new pathname within the same event_year

  } #start with a new unsteady flow plan


  #list of the individual time series which are now stored in data frames that were used as inputs in the HEC-RAS model
  observed_dataframes_list <- mget(ls(pattern="obs_data"))

  return(observed_dataframes_list)
}