####
#
#
###

init_generation<-function(S, W,NamesRDS)
{

	columnsName<-readRDS(NamesRDS)
	init <- rep(0,length(columnsName))
	names(init)<- columnsName
	
	Sindexes<-columnsName[grep("Env_sh", columnsName)]
	Windexes<-columnsName[grep("Env_wo", columnsName)]
	
	Slist<-strsplit(Sindexes, "_")
	Szone<-sapply(Slist, `[[`, 3)
	Zones <- unique(Szone)
	STotal <- length(sapply(Slist, `[[`, 2))/length(Zones)
	Wlist<-strsplit(Windexes, "_")
	WTotal <- length(sapply(Wlist, `[[`, 2))/length(Zones)
	# ho inserito più zone del dovuto
	if(length(S) > length(Zones)){ L = length(Zones)}else {L = length(S)}
	if(sum(S) > STotal ){
	  warnErrList("Troppe pecore!!!!")
	  }else{ 
	    S_Container <- STotal - sum(S)
	    }
	
	if(sum(W) > WTotal ){
	  warnErrList("Troppi lupi!!!!")
	  }else{
	    W_Container <- WTotal - sum(W)
	    }
	
  initColS<-1
  initColW<-1
	for(i in 1:L)
	{
	  if(!is.na(S[i] )& S[i] > 0)
	  {
	    init[paste0("Env_sh",initColS:(initColS+S[i]-1),"_z",i)]<-1
	    initColS<-initColS+S[i]
	  }
	  if(!is.na(W[i] )& W[i] > 0)
	  {
	    init[paste0("Env_wo",initColW:(initColW+W[i]-1),"_z",i)]<-1
	    initColW<-initColW+W[i]
	  }
	}
  
  if(W_Container>0)  init[paste0("Container_wo",initColW:(initColW+W_Container-1))]<-1
  if(S_Container>0)  init[paste0("Container_sh",initColS:(initColS+S_Container-1))]<-1

    return( init )
}

