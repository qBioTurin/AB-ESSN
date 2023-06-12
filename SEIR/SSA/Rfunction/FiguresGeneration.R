library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)

col = RColorBrewer::brewer.pal(n = 2,name = "Pastel1")
viridis::viridis(2, alpha = 0.5, option = "D")

csvPaths = list.files(path = "../ABM/sim_reinfezioni/")

ReInfectionTimes = lapply(csvPaths, function(csvPath){
  print(csvPath)
  X1_rtime <- read_csv(paste0("../ABM/sim_reinfezioni/",csvPath),col_names = F)
  X1_rtime = gsub(X1_rtime$X1,pattern = "\\[|\\]",replacement = "")
  X1split = strsplit(X1_rtime,split = " ")
  ReInfectionTimes = matrix(NA, nrow = length(X1split),ncol = 10 )
  ReInfectionTimes = as.data.frame(ReInfectionTimes) 
  colnames(ReInfectionTimes) = c("Deceased",paste0(1:(length(ReInfectionTimes)-1)))
  for(i in 1:length(X1split))
  {
    ReInfectionTimes[i,1] = X1split[[i]][1]
    if(length(X1split[[i]]) > 1)
      ReInfectionTimes[i,2:length(X1split[[i]])] = as.numeric(X1split[[i]][-1])
  }
  ReInfectionTimes$IDagent = paste0(gsub(pattern = ".csv",replacement = "",x = csvPath), 
                                    "_",
                                    1:length(ReInfectionTimes$Deceased)
  )
  return(ReInfectionTimes)
})
ReInfectionTimesDF = do.call(rbind,ReInfectionTimes)

ReInfectionTimesDF$Deceased = factor(ReInfectionTimesDF$Deceased,
                                     levels = c("alive","dead"),
                                     labels = c("Alive","Dead"))
pl = ReInfectionTimesDF %>%
  gather(-Deceased,-IDagent, value = "Time", key = "Ninfection") %>% 
  group_by(Ninfection) %>%
  mutate(File = stringi::stri_extract_first_regex(IDagent,pattern = "[0-9]+")) %>%
  na.omit() %>% 
  filter(File == "1") %>%
  ggplot() + 
  geom_boxplot(aes(x = Ninfection, y = Time, col = Deceased))+ 
  geom_violin(aes(x = Ninfection, y = Time, col = Deceased, fill = Deceased),alpha= 0.2) +
  scale_fill_manual(values = c("Dead" = col[1], "Alive" = col[2])) +
  scale_color_manual(values = c("Dead" = col[1], "Alive" = col[2])) +
  labs(x = "Number of infections", 
       y = "Time of the infection (days)", 
       col = "Status",
       fill = "Status") +
  theme_bw() +
  facet_wrap(~Deceased,scales = "free")+
  theme(
    legend.position = "none"
  )

pl = ReInfectionTimesDF %>%
  gather(-Deceased,-IDagent, value = "Time", key = "Ninfection") %>% 
  group_by(Ninfection) %>%
  mutate(File = stringi::stri_extract_first_regex(IDagent,pattern = "[0-9]+")) %>%
  na.omit() %>% 
  filter(File == "1") %>%
  ggplot() + 
  geom_boxplot(aes(x = Ninfection, y = Time, col = "blue"))+ 
  geom_violin(aes(x = Ninfection, y = Time, col =  "blue", fill = "blue"), alpha= 0.2) +
  scale_fill_manual(values =  col[2] ) +
  scale_color_manual(values = col[2] ) +
  labs(x = "Number of infections", 
       y = "Time of the infection (days)", 
       col = "Status",
       fill = "Status") +
  theme_bw()+
  theme(legend.position = "none",
        axis.title = element_text(face="bold",size = 15),
        legend.title = element_text(face="bold",size = 15),
        axis.text = element_text(size = 10),
        legend.text = element_text(size = 12),
        strip.text = element_text(face="bold",size = 12))

pl

ggsave(pl,filename = "InfectionTimes.pdf",device = "pdf",width = 8,height = 5)

pl =  ReInfectionTimesDF %>%
  gather(-Deceased,-IDagent, value = "Time", key = "Ninfection") %>% 
  group_by(Ninfection) %>% 
  na.omit() %>% 
  ungroup() %>%
  group_by(IDagent,Deceased) %>%
  count() %>% 
  mutate(File = stringi::stri_extract_first_regex(IDagent,pattern = "[0-9]+")) %>%
  ungroup() %>%
  #filter( File == "0") %>%
  group_by(File,Deceased,n) %>%
  dplyr::summarise(Ninfection = length(n)) %>%
  ggplot() +
  #geom_bar(aes(x = as.factor(n), fill = Deceased),position = "dodge") +
  geom_boxplot(aes(x = as.factor(n), y = Ninfection, col = Deceased, fill = Deceased),alpha = 0.4) +
  scale_fill_manual(values = c("Dead" = col[1], "Alive" = col[2])) +
  scale_color_manual(values = c("Dead" = col[1], "Alive" = col[2])) +
  facet_wrap(~Deceased,scales = "free")+
  labs(x = "Number of infections, 1000 simulations", y = "Distribution of the counts",fill = "Status") +
  theme_bw()+
  theme(
    legend.position = "none"
  )

pl =  ReInfectionTimesDF %>%
  gather(-Deceased,-IDagent, value = "Time", key = "Ninfection") %>% 
  group_by(Ninfection) %>% 
  na.omit() %>% 
  ungroup() %>%
  group_by(IDagent,Deceased) %>%
  count() %>% 
  mutate(File = stringi::stri_extract_first_regex(IDagent,pattern = "[0-9]+")) %>%
  ungroup() %>%
  group_by(File,Deceased,n) %>%
  dplyr::summarise(Ninfection = length(n)) %>%
  #filter(Deceased=="Alive") %>%
  ggplot() +
  geom_boxplot(aes(x = as.factor(n), y = Ninfection,
                   col = "blue", fill = "blue"),
               alpha = 0.4) +
  scale_fill_manual(values =  "#44015480" ) +
  scale_color_manual(values = "#44015480" ) +
  labs(x = "Number of infections",
       y = "Distribution of counts",
       fill = "Status") +
  theme_bw()+
  theme(legend.position = "none",
        axis.title = element_text(face="bold",size = 15),
        legend.title = element_text(face="bold",size = 15),
        axis.text = element_text(size = 10),
        legend.text = element_text(size = 12),
        strip.text = element_text(face="bold",size = 12))
pl

ggsave(pl,filename = "Plots/InfectionCounts.pdf",device = "pdf",width = 8,height = 5)






######## OTHER THINGS
pl = ReInfectionTimesDF %>%
  gather(-Deceased,-IDagent, value = "Time", key = "Ninfection") %>% 
  group_by(Ninfection) %>% 
  na.omit() %>% 
  ungroup() %>%
  group_by(IDagent,Deceased) %>%
  count() %>% 
  mutate(File = substr(IDagent,1,1)) %>%
  filter( Deceased == "dead") %>%
  ggplot() +
  geom_bar(aes(x = as.factor(n), fill = Deceased),position = "dodge") +
  #geom_boxplot(aes(x = n, fill = Deceased),position = "dodge") +
  labs(x = "Number of infections, 1000 simulations", y = "Counts",fill = "Status") +
  theme_bw()

pl



pl = ReInfectionTimesDF %>%
  gather(-Deceased,-IDagent, value = "Time", key = "Ninfection") %>% 
  group_by(Ninfection) %>%
  mutate(File = substr(IDagent,1,1)) %>% 
  na.omit() %>% 
  filter(File %in% paste(1:4)) %>%
  ggplot() + 
  geom_boxplot(aes(x = Ninfection, y = Time, col = Deceased)) +
  facet_wrap(~File,nrow = 2) +
  labs(x = "Number of infections", y = "Infection timing") +
  theme_bw()

pl