library(readr)
library(ggplot2)
library(dplyr)


plot <- function(trace)
{
  trace <- as.data.frame(read.csv(trace, sep = "") )
  
  n_sim_tot<-table(trace$Time)
  n_sim <- n_sim_tot[1]
  time_delete<-as.numeric(names(n_sim_tot[n_sim_tot!=n_sim_tot[1]]))
  
  if(length(time_delete)!=0) trace = trace[which(trace$Time!=time_delete),]
  Time.grid<- unique(trace$Time)
  
  trace$ID <- rep(1:n_sim,each = length(Time.grid))
  DF.list<-lapply(colnames(trace),function(i){
    if(! i %in% c("Time", "ID")){
      d <- data.frame(Names = i, ID = trace$ID, Value = trace[,i],Time = trace$Time)
      return(d)
    }
  })
  DF <- do.call("rbind",DF.list)
  
  DF_mean <- DF %>%
    group_by(Time,Names) %>%
    dplyr::summarise(Mean= mean(Value)) 
  
  pl<-ggplot()+
    geom_line(data=DF,aes(x = Time,y=Value, group=ID),col="grey",alpha=.5)+
    geom_line(data= as.data.frame(DF_mean),aes(x = Time,y=Mean))+
    facet_wrap(~Names,nrow = 2,scales = "free")
  
  
  plDensityFinal <-ggplot(data=DF[which(DF$Time == max(DF$Time)),],aes(x=Value))+
    geom_histogram(aes(y=..density..), alpha=0.5, 
                   position="identity")+
    geom_density()+
    facet_wrap(~Names,nrow = 2)
  
  MeanV <- DF[which(DF$Time == max(DF$Time)),]  %>% group_by(Names)%>% summarise(Mean=mean(Value))
  MinV <- DF[which(DF$Time == max(DF$Time)),]  %>% group_by(Names)%>% summarise(Min=min(Value))
  MaxV <- DF[which(DF$Time == max(DF$Time)),]  %>% group_by(Names)%>% summarise(Max = max(Value))
  Freq0V <- DF[which(DF$Time == max(DF$Time)),]  %>% group_by(Names)%>% summarise(Freq0 = table(Value))
  
  return(pl)
}


#View(merge(merge(merge(MeanV,MinV),MaxV),Freq0V))


###########################
library(ggplot2)
library(readr)
library(dplyr)
library(gridExtra)
library(gtable)
library(grid)


ggplot.generation<-function(tracefile,csvPath=NULL,plotname = "Models"){
  ### PN model:
  trace=as.data.frame(read.csv(tracefile, sep = ""))
  columnsName <- colnames(trace)
  n_sim_tot<-table(trace$Time)
  n_sim <- n_sim_tot[1]
  
  print(paste0("Considering ",n_sim," simulations, ", 
               n_sim_tot[length(n_sim_tot)]," have finished!") )
  
  time_delete<-as.numeric(names(n_sim_tot[n_sim_tot!=n_sim_tot[1]]))
  if(length(time_delete)!=0) trace = trace[which(!trace$Time%in%time_delete),]
  Time.grid<- unique(trace$Time)
  trace$ID <- rep(1:n_sim,each = length(Time.grid))
  
  DF.list<-lapply(colnames(trace),function(i){
    if(! i %in% c("Time", "ID")){
      d <- data.frame(Names = i, ID = trace$ID, Value = trace[,i],Time = trace$Time)
      return(d)
    }
  })
  PN.df <- do.call("rbind",DF.list)
  PN.df$Model <- "SSA"
  
  ### AM model:
  
  NetLogofiles = list.files(path = csvPath,pattern = "csv")
  resultsAM = do.call("rbind",lapply(NetLogofiles, function(x){
    trace <- read_table2(paste0(csvPath,"/",x), 
                      col_names = FALSE)

    
    colnames(trace) = c("Time","C","Einj","Etravel", "Es","Ab","Abtravel","As","Ag","N")
    trace$ID = gsub(pattern = ".csv",replacement = "",x = x)
    return(trace)
  }))

  AM.df = resultsAM %>% tidyr::gather(-ID,-Time,value = "Value",key = "Names")
  AM.df$Model <- "ABM"
  
  DF.All<- rbind(PN.df,AM.df)
  
  if(plotname == "treated")
    nametokeep = c("C","Einj","Etravel", "Es","Ab","Abtravel","As","Ag","N")
  else nametokeep = c("C","Einj","Etravel", "Es","Ab","Abtravel","As","Ag","N")
    
  DF.All = DF.All %>% filter(Names %in% nametokeep)
  
  df.plot<-DF.All[which(DF.All$Time %in% Time.grid),]
  
  DF_mean <- df.plot %>%
    group_by(Time,Names,Model) %>%
    dplyr::summarise(Mean= mean(Value))

  steps=unique(df.plot[which(df.plot$Time %in% round(seq(0,max(df.plot$Time),length.out = 15) ) ),"Time"])
  
  pl<-ggplot()+
    geom_line(data=df.plot,aes(x=Time,y = Value,col=Model, group=ID),alpha=.6)+
    #geom_boxplot(aes(x = as.factor(Time)) )+
    geom_line(data= as.data.frame(DF_mean),aes(x = Time,y=Mean),col="black",linetype="dashed")+
    facet_grid(Names~Model,scale="free")+
    theme(axis.text=element_text(size = 10, hjust = 0.5),
          axis.title=element_text(size=20,face="bold"),
          axis.line = element_line(colour="black"),
          plot.title=element_text(size=10, face="bold", vjust=1, lineheight=0.6),
          legend.title = element_blank() , 
          legend.position = "none",
          panel.background = element_rect(colour = NA),
          plot.background = element_rect(colour = NA),
          plot.margin=unit(c(10,5,5,5),"mm") )+
    labs(x="",y="Value")+
    scale_x_continuous(breaks = steps, labels=steps )
  
  DF_max <- DF.All %>%
    group_by(Names) %>%
    dplyr::summarise(Max= max(Value))
  DF_max$Time=0
  
  plBox<-ggplot()+
    geom_point(data=as.data.frame(DF_max),aes(x = Time, y = Max),alpha = 0)+
    geom_boxplot(data=df.plot[which(df.plot$Time %in% steps ),],aes(x = as.factor(Time),y = Value,col=Model) )+
    #geom_line(data= as.data.frame(DF_mean),aes(x = Time,y=Mean,col=Model),linetype="dashed")+
    facet_grid(rows = vars(Names),scale="free")+
    theme(axis.text=element_text(size = 10, hjust = 0.5),
          axis.title=element_text(size=20,face="bold"),
          axis.line = element_line(colour="black"),
          plot.title=element_text(size=10, face="bold", vjust=1, lineheight=0.6),
          legend.text=element_text(size=18),
          legend.title=element_text(size=20,face="bold"),
          legend.key=element_blank(),
          legend.key.size = unit(.9, "cm"),
          legend.key.width = unit(.9,"cm"),
          legend.position = "top",
          panel.background = element_rect(colour = NA),
          plot.background = element_rect(colour = NA),
          strip.text.y = element_text(size=14,face="bold")
    )+
    labs(x="",y="")+
    scale_x_discrete(breaks = steps, labels=steps )
  
  # Extracxt the legend from p1
  legend = gtable_filter(ggplotGrob(plBox), "guide-box") 
  # grid.draw(legend)    # Make sure the legend has been extracted
  labelx = textGrob("Time", vjust = 0.5,
                    gp = gpar(fontsize = 20, fontface = 'bold'))
  
  pl.arranged = grid.arrange(arrangeGrob(pl + theme(legend.position="none", 
                                                    strip.background = element_blank(),
                                                    strip.text.x = element_blank(),
                                                    plot.margin=unit(c(1,-0.3,-0.5,1), "cm")), 
                                         plBox + theme(legend.position="none",
                                                       axis.title.y=element_blank(),
                                                       axis.text.y=element_blank(),
                                                       axis.ticks.y=element_blank(),
                                                       axis.line.y = element_blank(),
                                                       plot.margin=unit(c(1,1,-0.5,-0.3), "cm")), 
                                         nrow = 1, 
                                         widths= c(4,2)), 
                             labelx,
                             legend,
                             heights = c(1.5,.1,.2),
                             ncol=1)
  
  ggsave(filename = paste0(plotname,".png") ,plot = pl.arranged,
         device = "png",width = 14,height = 12 )
  
  return(list(pl=pl.arranged,
              plBox=plBox + facet_wrap(~Names,scale="free"),
              df=DF.All))
}



