#' @title Import RAS Hydrographs
#'
#' @description Imports and formats the unsteady flow files (.u)
#' from the HEC-RAS GUI.
#'
#' @export
#' @param unsteadyflowfile_list  list; list of dataframes which contain
#'                                unsteady flow text files
#' @param plan_events            numeric; list of the years in which events occurred.
#'
#'
#' @return A list data frames containing unsteady flow files.
#'
#' @importFrom readr cols col_character col_double
#' @importFrom tibble add_column
#'

import_hecras_unsteadyflowfiles <- function(unsteadyflowfile_list, plan_events){
    for(p in 1:length(plan_events)){ #need to loop through the unsteady flow file for each plan
        event_year <- plan_events[p] #selects a single event year
        text <- as.data.frame(unsteadyflowfile_list[p]) #selects a single unsteady flow file

        if(ncol(text)==2){
          df <- str_split(text$text, "Observed DSS", simplify = TRUE) #now each row is a cell from the text file
        }else{
          df <- stringr::str_split(text[,1], "Observed DSS",simplify = TRUE) #now each row is a cell from the text file
        }


        df <- t(df) #invert the dataframe
        df_clean <- as.data.frame(df[2:nrow(df),]) #remove the first cell - doesn't contain useful information for this analysis

        #determine the number of observed timeseries that were imported into the model
        #NOTE: there can be more than one timeseries associated with the same cross-section (e.g. stage and disharge)
        l <- nrow(df_clean)/4

        #Spilt the dataframe into smaller dataframes (4 cells are associated with each cross-section)
        df_short <- split(df_clean, rep(1:l, each = 4))

        #Reformat the dataframes so that they are easier to read and recombine
        df_all_location <- c()
        for(i in 1:l){ #loop through all the locations in the text file
          add <- df_short[[i]]
          format_add <- t(add)
          df_all_location <- rbind(df_all_location, format_add) #add new row
        }

        #reformat the location column to put River, Reach, and cross section river mile into separate columns
        Location <-str_split_fixed(df_all_location[,1], c("="),2)
        Location <-str_split_fixed(Location[,2], c(","), 4)
        Location <- Location[,c(1:3)]
        colnames(Location) <- c("River", "Reach", "RiverMile")

        #Break the pathname into individual components in separate columns
        Observed_Pathname <-str_split_fixed(df_all_location[,3], c("/"),8)
        Observed_Pathname <- Observed_Pathname[,c(2:7)]
        colnames(Observed_Pathname) <- c("Observed_A","Observed_B","Observed_C","Observed_D","Observed_E","Observed_F")

        #reorganize the columns so easier to read
        Formatted_UnsteadyFlowFile<- cbind(Location, Observed_Pathname, df_all_location[,2])
        colnames(Formatted_UnsteadyFlowFile)[10] <- "Observed_DSS_File_Name"

        Formatted_UnsteadyFlowFile <- as.data.frame(Formatted_UnsteadyFlowFile)
        Formatted_UnsteadyFlowFile <- transform(Formatted_UnsteadyFlowFile, RiverMile = as.numeric(as.character(RiverMile)))

        #for each plan there is a different unsteady flow file need
        Formatted_UnsteadyFlowFile <- tibble::add_column(Formatted_UnsteadyFlowFile, UnsteadyFlowFile = event_year, .after = 10)
        rownames(Formatted_UnsteadyFlowFile) <- NULL

        assign(paste("FormattedUnsteadyFlowFile",event_year,sep="_"), Formatted_UnsteadyFlowFile)

      }#start a new plan

    Formatted_UnsteadyFlowFileList <- mget(ls(pattern="FormattedUnsteadyFlowFile_"))
  return(Formatted_UnsteadyFlowFileList)

}








