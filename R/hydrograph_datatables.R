#' @title Hydrograph Datatable
#'
#' @description Create a data table for each cross section that has observed and model data.
#'
#' @export
#' @param list_observed_data      list; A list of data frames produced by the
#'                                `razviz::import_observed_data` function.
#' @param list_1Dmodel_data      list; A list of data frames produced by the
#'                                `razviz::import_hecras_1Dmodel_data` function.
#' @param list_2Dmodel_data      list; A list of data frames produced by the
#'                                `razviz::import_hecras_2Dmodel_data` function.
#'
#'
#'
#' @param hg_plot_pages           data frame; A data frame produced by the
#'                         `razviz::hydrograph_plot_pages` function.
#'
#' @return A list of dataframes.
#'
#' @importFrom dplyr filter

#'
hydrograph_datatables <- function(list_observed_data, list_1Dmodel_data, list_2Dmodel_data,
                                  locations, plan_events, run_type, run_number) {


  for(p in 1:length(plan_events)){ #loop through each plan
    event_year <-  plan_events[p]

    for (y in locations){ #loop through all the UNIQUE LOCATIONS  on the river and create observed and stage

      #need to pull observed data
      obs_subset <- list_observed_data[grepl(y, names(list_observed_data))]

      #then need to subset it for the plan
      obs_subset <- obs_subset[grepl(event_year, names(obs_subset))]
      obs_DF <- obs_subset[[1]]
      setnames(obs_DF, old = c("UnsteadyFlowFile"), new = c("Event"),  skip_absent=TRUE)
      #class(obs_DF$Event)

      #pull modeled data (this contains all the plans from the RAS model at a particular river mile location)
      model_subset <- list_1Dmodel_data[grepl(y, names(list_1Dmodel_data))]
      model_DF <- model_subset[[1]]

      #add column for event

      Event <- readr::parse_number(as.character(model_DF$Model_F)) #this breaks the F section of DSS
      model_DF$Event <- Event

      model_DF_plans <- split(model_DF,model_DF$Event)
      model_DF_plan <- model_DF_plans[[p]]

      Start_Date <- min(model_DF_plan$DAY.TIME)
      Start_Date

      End_Date <- max(model_DF_plan$DAY.TIME)
      End_Date

      #add column for run type
      model_DF_plan <- add_column(model_DF_plan, Run_type = run_type, .after = 11)

      #add column for run number
      model_DF_plan <- add_column(model_DF_plan, Run_num = run_number , .after = 12)



     if(missing(list_2Dmodel_data)){ #if 2D connections are not being added to the hydrographs, then keep the model data the same

       model_DF_plan <- model_DF_plan

     }else{ #if there are 2D area flows, then do the following

        #add 2D flows if needed at the particular river mile location
        #start by looking at river mile locations that have 2D areas associated with them
      SA2D_CONNECTIONS_CX_RM <- list(unique(readr::parse_number(names(list_2Dmodel_data))))

      if(y %in% SA2D_CONNECTIONS_CX_RM){ #if true there is a 2D area which has flow that needs to be added to this cross section
        #need to ADD to the model flow the 2D area flow from that plan
        #limit the list to the dataframe associated with that RM
        SA_CONNECTION_subset <- list_2Dmodel_data[grepl(y, names(list_2Dmodel_data))]

        #then need to subset it for the event year
        SA_CONNECTION_subset <- SA_CONNECTION_subset[grepl(event_year, names(SA_CONNECTION_subset))]
        SA_CONNECTION_DF <- SA_CONNECTION_subset[[1]] #there should only be one DF left in the list
        SA_CONNECTION_DF <- tibble::rownames_to_column(SA_CONNECTION_DF, "DAY.TIME") #moving date from row name into the first column

        Add_SA_Connection <- merge(model_DF_plan, SA_CONNECTION_DF) #merge the two dataframes

        #add the flow columns together and create a new column called sum
        Add_SA_Connection$Sum <- Add_SA_Connection$Model_Q + Add_SA_Connection$`FLOW-TOTAL`

        #rename the columns to match razviz and save as
        setnames(Add_SA_Connection, old = c('Model_Q','Sum'), new = c('Model_Q_CXonly','Model_Q'))

        model_DF_plan <- Add_SA_Connection
      }
     }


      final_df <- merge(obs_DF, model_DF_plan, all=TRUE)

      final_df$date <- parse_datetime(final_df$DAY.TIME,format = "%Y-%m-%d %H:%M:%S")

      final_df_clean <- final_df %>% filter(date > as.POSIXct(Start_Date, tz="UTC"))
      final_df_clean <- final_df_clean %>% filter(date < as.POSIXct(End_Date, tz="UTC"))
      #cutoff the dates which do not have modeled data


      final_df_clean$River_Sta <- obs_DF$River_Sta[1]
      final_df_clean$River <- obs_DF$River[1]
      final_df_clean$Reach <- obs_DF$Reach[1]
      final_df_clean$Gage_Location <- obs_DF$Gage_Location[1]

      #reset Gage location names for when a 2D connection was added
      if(c("SA_Name") %in% colnames(final_df_clean)){
        final_df_clean$Gage_Location_Only <- obs_DF$Gage_Location[1]
        final_df_clean$Gage_Location <- paste0(obs_DF$Gage_Location[1] , " + 2D Connection_",model_DF_plan$SA_Name[1])
      }


      dfname <- paste("Final_DF",y,event_year,sep="_")
      assign(dfname,final_df_clean)
      print(dfname)

    } #start a new river mile location

  } #Start a new plan

  hydrograph_df_list<- mget(ls(pattern="Final_DF_"))

  return(hydrograph_df_list)
}
