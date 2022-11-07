
library(ggplot2)


trace=as.data.frame(read.csv( paste0("./ModelAnalysisNumZones",model,"/model_analysis-1.trace"), sep = ""))
columnsName <- colnames(trace)
n_sim_tot<-table(trace$Time)
n_sim <- n_sim_tot[1]
time_delete<-as.numeric(names(n_sim_tot[n_sim_tot!=n_sim_tot[1]]))

if(length(time_delete)!=0) trace = trace[which(trace$Time!=time_delete),]

SEIRList<-lapply(0:2, function(i){
  SEIR_age<-lapply(c("S","E","I","R"),function(j){
    indexes<-columnsName[grep(paste0("^",j,"_a",i,"_"), columnsName)]
    if(length(indexes)>1){
      SumZones<-rowSums(trace[,indexes])
    }else{
      SumZones<-trace[,indexes]
    }
    PopMean <- aggregate(SumZones,by=list(Time=trace$Time),FUN="mean")
    colnames(PopMean)[2]<- paste0(j,"_a",i,"_mean")
    PopSd <- aggregate(SumZones,by=list(Time=trace$Time),FUN="sd")
    colnames(PopSd)[2]<- paste0(j,"_a",i,"_sd")  
    
    Pop<-merge(PopMean,PopSd,by="Time")
    return(Pop[,-1])
  } )
  return(do.call("cbind",SEIR_age))
})
SEIR<-do.call("cbind",SEIRList)
SEIR$Time <- unique(trace$Time)

write_csv(x = SEIR[, c("Time",colnames(SEIR)[-length(SEIR[1,])]) ], path = paste0(model,".csv"))
