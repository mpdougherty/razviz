# `razviz` v0.0.3 (release date 6/28/2020)
* Added the `import_ras_hydrographs` function. This function handles the specfic case of using data exported from the RAS GUI. A seperate `import_dssvue_hydrographs` function will be needed to handle DSSVue exports. 
* Added the `combine_hydrographs` function. This function can handle datasets in either the RAS GUI export format or the DSSVue format when the `import_dssvue_hydrographs` function is implemented. 
* Added the `lengthen_hydrographs` function to convert hydrograph data in wide format to long format suitable for graphing.
* Added the `hydrograph_plot_pages` function to define the plots needed for a hydrographs dataset. 
* Added the `hydrograph_plot` function to draw a hydrograph plot. 
* Added the `hydrograph_report` function to produce a set of hydrographs for the input dataset. 
* Added the `hydrographs` vignette to explain how to produce a hydrograph report. 

# `razviz` v0.0.2 (release date 6/25/2020)
* Added the `combine_files` function to streamline importing a folder of `.csv` files. 
* Added the `long_plot_pages` function to define the characteristics of each longitudinal profile plot page in a report. 
* Added the `gage_labels` function to define the characteristics of each gage for drawing gage stage labels. 
* Added the `gage_boxes` function to define the characteristics of each gage for drawing gage stage boxes. 
* Added the `longitudinal_profile_plot` function to draw an individual longitudinal profile graph. 
* Added the `longitudinal_profile_report` function to produce a set of longitudinal profile graphs for a modeled reach. 
* Added the `longitudinal_profile` vignette to explain how to produce a longitudinal profile report. 

# `razviz` v0.0.1 (release date 6/22/2020)
* Created the `razviz` package.
* Began porting code from a series of rmarkdown documents used to create graphs and reports from a previous project to the `razviz` package to improve code reusability, code maintanence, portability, and enhancement.
* Porting the code from a set of rmarkdown documents required some refactoring and decisions about the `razviz` package interface. The decision was made at this point that `razviz` would focus on providing functions that create standard graphs, summary tables, and reports. Data wrangling should probably be handled by other packages to maintain the focus of this package.
