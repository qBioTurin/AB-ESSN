# 1 Step) Load libraries and functions
library(epimod)
library(dplyr)
library(ggplot2)
source("./Rfunction/PlotsGeneration.R")

# 2 step) SSA model generation using the decolored ESSN model

model.generation(net_fname = "Net/MelanomaModels.PNPRO",
                 transitions_fname = "Net/transitionsGen.cpp")
system("mv MelanomaModels.* Net")

## First scenario: Untreat
ini_v = c(0,0) # set the initial condition of the place

model.analysis(solver_fname = "./Net/MelanomaModels.solver",
               parameters_fname = "./Input/ParameterList",
               functions_fname = "./Rfunction/Functions.R",
               solver_type = "SSA",
               parallel_processors = 2,
               n_run = 1000,
               f_time = 20,
               s_time = 1,
               i_time = 0,
               ini_v = ini_v) #debug = T )


ggplot.generation(tracefile = "MelanomaModels_analysis/MelanomaModels-analysis-1.trace",
                  csvPath="../AB-ESSN/NetLogoSimulations/untreated/",  
                  plotname = "Plots/untreated") -> plU

plU$plBox
 
## Second scenario: Treated

ini_v = c(100,76) # Treat

model.analysis(solver_fname = "./Net/MelanomaModels.solver",
               parameters_fname = "./Input/ParameterList",
               functions_fname = "./Rfunction/Functions.R",
               solver_type = "SSA",  
               parallel_processors = 2,
               n_run = 1000,
               f_time = 20,
               s_time = 1,
               i_time = 0,
               ini_v = ini_v) #debug = T )


ggplot.generation(tracefile = "MelanomaModels_analysis/MelanomaModels-analysis-1.trace",
                  csvPath="../AB-ESSN/NetLogoSimulations/treated/",  
                  plotname = "Plots/treated") -> plT

plT$plBox
