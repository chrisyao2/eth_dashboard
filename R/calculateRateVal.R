calculateRateValues <- function(data,indicies,rate, names, fileOutput)
{
  for(i in 1:length(indicies))
  {
    currentName <- names[i]
    data[,currentName] <- multiplyByConstant(data[[indicies[i]]], rate)
  }
  
  saveRDS(data, paste0("data/FERGData/FERG_Rates/Met_bio_dat_u5_Rate.rds"))
}


#data must be a vector
multiplyByConstant <- function(data, constant)
{
    return(constant * data)
}

