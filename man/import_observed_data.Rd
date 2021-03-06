% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_observed_data.R
\name{import_observed_data}
\alias{import_observed_data}
\title{Import observed data}
\usage{
import_observed_data(
  observed_dss_file,
  Formatted_UnsteadyFlowFileList,
  plan_events
)
}
\arguments{
\item{observed_dss_file}{jobjRef; open dss file where observed data is stored hydrograph using dssrip.}

\item{Formatted_UnsteadyFlowFileList}{list; list containing the unsteady flow data for each plan;
output from import_hecras_unsteadyflowfiles function.}

\item{plan_events}{list; The list of years in which the different events occurred}
}
\value{
A list of data frames Each data frames contains the observed flow (Q) and water surface (WS) elevation for each cross-section.
}
\description{
Imports observed data from a dss file. All observed data needs
to be in one dss file and the pathnames should be exactly the same as what
is in unsteady flow file from HEC-RAS.  It is okay if the dss file name does not
match the dss file name from the unsteady flow file. Different versions of
HEC-DSSVue may change how the Part E (typically time interval: MIN, HOUR) is written.
}
