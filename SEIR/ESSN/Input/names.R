library(readr)

Names <- read_table2(paste0(i,".PlaceTransition") )

transStart<- which(Names[,1] == "#TRANSITION")

NAMES = unlist(Names[1:(transStart-1),1])
NAMES = unname(NAMES)

saveRDS(NAMES,file="Input/NAMES.RDS")
