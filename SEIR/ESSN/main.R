library(epimod)
#setwd("~/GIT/ModelliEpimod/PNvsMA/LotkaVolterra/")
#library(devtools)
#install_github("https://github.com/qBioTurin/epimod")
timeList<- list()
k<-1

for( i in paste0("SEIRS_",c(5,10,20,25)))
{
  start1 <- Sys.time()
  model_generation(net_fname = paste0("./Net/",i,".PNPRO") )
  
  source("Input/names.R")
  start2 <- Sys.time()
  
  model_analysis(out_fname = "model_analysis",
                 solver_fname = paste0(i,".solver"),
                 f_time = 20,
                 s_time = 1,
                 solver_type = "SSA",
                 n_run = 1000,
                 parallel_processors = 15,
                 parameters_fname = "Input/Functions_list.csv",
                 functions_fname = "Rfunction/Functions.R"
  )
  
  end.time<- Sys.time() 
  
  folder = paste0("ModelAnalysisNumZones",i)
  if(file.exists(folder)) {
    system(paste('rm -rd ', sprintf(folder)) )
  }
  system(paste('mv', 
               sprintf("results_model_analysis"),
               sprintf(folder)) )
  
  model <- i
  source("writeCsv.R")
  
  timeList[[k]]<-data.frame(start1=start1,start2=start2,end.time = end.time)
  k=k+1
}

times<-do.call("rbind",timeList)

df<-data.frame(NumberOfPositions = c(5,10,20,25),
           Generationtime = times$start2 - times$start1,
           SimulationTime = times$end.time - times$start2 )
save(df,file = "Times.RData")

