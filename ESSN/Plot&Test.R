library(ggplot2)
library(readr)
library(R.matlab)

ggplot.generation<-function(i,mat=F){
  ### PN model:
  trace=as.data.frame(read.csv( paste0("./PNresults/ModelAnalysisNumZonesSEIRS_",i,"/model_analysis-1.trace"), sep = ""))
  columnsName <- colnames(trace)
  n_sim_tot<-table(trace$Time)
  n_sim <- n_sim_tot[1]
  time_delete<-as.numeric(names(n_sim_tot[n_sim_tot!=n_sim_tot[1]]))
  
  if(length(time_delete)!=0) trace = trace[which(trace$Time!=time_delete),]
  Time.grid<- unique(trace$Time)
  
  PNList<-lapply(c("S","E","I","R"),function(j){
      indexes<-columnsName[grep(paste0("^",j,"_a"), columnsName)]
      if(length(indexes)>1){
        SumZones<-rowSums(trace[,indexes])
      }else{
        SumZones<-trace[,indexes]
      }
      df<-data.frame(Time = trace$Time, 
                     V=SumZones,
                     Pop = j,
                     ID = rep(1:n_sim,each = length(unique(trace$Time))) )
      return(df)
    } )
  PN.df<-do.call("rbind",PNList)
  PN.df$Model <- "PN"
  
  
  ### AM model:
  if(mat){
    resultsAM <- readMat(paste0("AMresults/",i,".mat"))[[1]]
  }else{
     resultsAM <- read_table2(paste0("AMresults/results",i,"_t20.csv"), 
                           col_names = FALSE)
  }
  
 
  AM_list<-lapply(seq(1,length(resultsAM[1,]),by = 5), function(j){
    res<-as.data.frame(resultsAM[,j:(j+4)])
    colnames(res) <- c( "Time" , "S" , "E" ,"I", "R")
    df <-lapply(c("S" , "E" ,"I", "R"),function(a){
      df<-data.frame(Time = res$Time,
                     V = res[,a])
      colnames(df)[2]<-"V"
      #df.spline<-spline(df$Time, df$V, xout = Time.grid,method = "natural")
      #df.spline<-approx(df$Time, df$V, xout = Time.grid,ties="mean")
      #df<-as.data.frame(do.call("cbind",df.spline))
      colnames(df)<-c("Time","V")
      df$Pop = a
      df$ID =  (j+4)/5 
      return(df)
    })
    return(do.call("rbind",df))
  })
  
  AM.df<-do.call("rbind",AM_list)
  AM.df$Model <- "AM"
  
  DF.All<- rbind(PN.df,AM.df)

  #df.plot<-DF.All[which(DF.All$Time %in% 0:10),]
  df.plot<-DF.All[which(DF.All$Time %in% Time.grid),]
pl<-ggplot(df.plot,aes(y = V,col=Model))+
  geom_boxplot(aes(x = as.factor(Time)) )+
  facet_wrap(~Pop,scale="free")+
  labs(title=paste("Number of Zones",i))

  df.plot2<-DF.All[which(DF.All$Time %in% Time.grid),]#[which(DF.All$Time %in% seq(0,10,by=1)),]
  
  Mean.plot<-aggregate(df.plot2$V,by=list(Time = df.plot2$Time,Model = df.plot2$Model,Pop = df.plot2$Pop ),
                       FUN = "mean")
  colnames(Mean.plot)[4]<-"Mean"
  sd.plot<-aggregate(df.plot2$V,by=list(Time = df.plot2$Time,Model = df.plot2$Model,Pop = df.plot2$Pop ),
                     FUN = "sd")
  colnames(sd.plot)[4]<-"sd"
  
  Stat.df <- merge(sd.plot,Mean.plot)
  
  pl2<-ggplot(df.plot,aes(y = V,col=Model))+
    geom_boxplot(aes(x = as.factor(Time)) )+
    geom_line(data= Stat.df,aes(x= Time+1, y = Mean,linetype="Mean"))+
    geom_line(data= Stat.df,aes(x= Time+1, y = Mean+sd,linetype="Mean+-sd"))+
    geom_line(data= Stat.df,aes(x= Time+1, y = Mean-sd,linetype="Mean+-sd"))+
    facet_wrap(~Pop,scale="free")
  
  Median.plot<-aggregate(df.plot2$V,by=list(Time = df.plot2$Time,Model = df.plot2$Model,Pop = df.plot2$Pop ),
                     FUN = "median")
  colnames(sd.plot)[4]<-"Median"
  
  diff.plot.all <- merge(sd.plot,Mean.plot)
  diff.plot <- diff.plot.all[which(diff.plot.all$Model == "PN"),]
  diff.plot$Median <-  diff.plot.all[which(diff.plot.all$Model == "PN"),"Median"] - diff.plot.all[which(diff.plot.all$Model == "AM"),"Median"]
  diff.plot$Mean <-  diff.plot.all[which(diff.plot.all$Model == "PN"),"Mean"] - diff.plot.all[which(diff.plot.all$Model == "AM"),"Mean"]
  
  diff.plot$Median.rel <- abs(diff.plot.all[which(diff.plot.all$Model == "PN"),"Median"] - diff.plot.all[which(diff.plot.all$Model == "AM"),"Median"])/1000
  diff.plot$Mean.rel <- abs(diff.plot.all[which(diff.plot.all$Model == "PN"),"Mean"] - diff.plot.all[which(diff.plot.all$Model == "AM"),"Mean"])/1000
  
  
  pldiff.ass<-ggplot(diff.plot)+
    geom_line(aes(x= Time, y = abs(Mean),linetype="Mean"))+
    geom_line(aes(x= Time, y = abs(Median),linetype="Median"))+
    facet_wrap(~Pop,scale="free")+
    labs(title="Diff. assoluta")
  
  pldiff.rel<-ggplot(diff.plot)+
    geom_line(aes(x= Time, y = (Mean.rel),linetype="Mean"))+
    geom_line(aes(x= Time, y = abs(Median.rel),linetype="Median"))+
    facet_wrap(~Pop,scale="free")+
    labs(title="Diff. relativa")
  
  ggsave(filename = paste0("Dynamics",i,".png"),plot = pl2,device = "png",width = 10,height = 8 )
  ggsave(filename = paste0("DiffAss",i,".png"),plot = pldiff.ass,device = "png",width = 10,height = 8 )
  ggsave(filename = paste0("DiffRel",i,".png"),plot = pldiff.rel,device = "png",width = 10,height = 8 )
  
return(list(pldiff.ass=pldiff.ass,
            pldiff.rel=pldiff.rel,
            pl2=pl2,
            df=DF.All))
}


ggplot.generation(5) -> pl5
ggplot.generation(10) -> pl10
ggplot.generation(20) -> pl20
ggplot.generation(25) -> pl25

#
# ##### Testing:
library(fdatest)

ggplot.generation(5,mat = T) -> pl5.mat
data<-pl5.mat$df
pl5.mat$pl2
pl5.mat$pldiff.rel
pl5.mat$pldiff.ass

ggplot.generation(10,mat = T) -> pl10.mat
data<-pl10.mat$df
pl10.mat$pl2
pl10.mat$pldiff.rel
pl10.mat$pldiff.ass


ggplot.generation(5) -> pl5
data<-pl5$df
# ggplot.generation(10) -> pl10
# data<-pl10$df


pvalesDF<-lapply(c("S","E","I","R"),function(i){
  PNdata<-data[data$Model == "PN" & data$Pop == i & data$Time %in% seq(0,20,by=0.5),c("ID","V")]
PNmatrix<-t(sapply(unique(PNdata$ID),function(j) PNdata$V[PNdata$ID == j]))

AMdata<-data[data$Model == "AM" & data$Pop == i & data$Time %in% seq(0,20,by=0.5),c("ID","V")]
AMmatrix<-t(sapply(unique(AMdata$ID),function(j) AMdata$V[AMdata$ID == j]))

ITP.result <- ITP2bspline(AMmatrix,PNmatrix,B=10^4)
c(i,ITP.result$corrected.pval)
})
pvalesDF <- do.call("cbind",pvalesDF)

PNdata<-data[data$Model == "PN" & data$Pop == "S" & data$Time %in% seq(0,20,by=0.5),c("ID","V")]
PNmatrix<-t(sapply(unique(PNdata$ID),function(j) PNdata$V[PNdata$ID == j]))

AMdata<-data[data$Model == "AM" & data$Pop == "S" & data$Time %in% seq(0,20,by=0.5),c("ID","V")]
AMmatrix<-t(sapply(unique(AMdata$ID),function(j) AMdata$V[AMdata$ID == j]))

ITP.result <- ITP2bspline(AMmatrix,PNmatrix,B=10^4)

plot(ITP.result)


