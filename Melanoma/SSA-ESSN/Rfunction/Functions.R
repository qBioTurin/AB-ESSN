InitGeneration <- function(n_file,optim_v=NULL, ini = NULL)
{
  yini.names <- readRDS(n_file)
  
  y_ini <- rep(0,length(yini.names))
  names(y_ini) <- yini.names
  
  y_ini["Einj"] = optim_v[2]
  y_ini["Ab"] = optim_v[1]
  #   y_ini["Etravel"] =
  #   y_ini["Abtravel"] =
  # y_ini["Es"] = optim_v[2]
  #   y_ini["As"] =
  #   y_ini["Ag"] =  
  y_ini["C"] =  100
  y_ini["N"] = 20
  y_ini["environment"] =  1
  
  return( y_ini )
}

