####
#
#
###
init_generation<-function(S, I,NamesRDS)
{
  
  columnsName<-readRDS(NamesRDS)
  init <- rep(0,length(columnsName))
  names(init)<- columnsName
  
  A0indexes<-columnsName[grep("S_a0", columnsName)]
  A1indexes<-columnsName[grep("S_a1", columnsName)]
  A2indexes<-columnsName[grep("S_a2", columnsName)]
  Iindexe<-columnsName[grep("I_a1", columnsName)][1]
  
  init[A0indexes] <- S/5 * 1/length(A0indexes)
  init[A1indexes] <- S* 2/5 * 1/length(A1indexes)
  init[A2indexes] <- S* 2/5 * 1/length(A2indexes)
  init[Iindexe] <- I
  
  return( init )
}