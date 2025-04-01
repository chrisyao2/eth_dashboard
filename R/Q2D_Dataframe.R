
#Requires data to be a dataframe
autoSimImportedData <- function(data)
{
  
  df <- NULL
  
  for(x in 1:nrow(data))
  {
    
    disease <- data[[x,1]]
    diseaseType <- data[[x,2]]
    
    parameterList <- NULL
    
    for(i in 1:(ncol(data) - 2))
    {
      offset <- 2
      currentDependentVar <- reformatList(data[[x,offset + i]])
      #currentDependentVar <- as.vector(currentDependentVar)
      
      if(is.null(parameterList))
      {
        parameterList <- list(currentDependentVar)
      }
      else
      {
        parameterList[[i]] <- currentDependentVar
      }
    }
    
    presentDiseases <- colnames(data)
    presentDiseases <- presentDiseases[c(-1,-2)]
    
    
    simResults <- runSimulation(parameterList,disease, diseaseType,presentDiseases)
    
    df <- rbind(df, simResults)
  }
  
  df
}


listElementsToNum <- function(listVal)
{
  as.numeric(listVal)
}

#list has a single element of type chr
reformatList <- function(list)
{
    containsCommas <- grepl(",",list)
    if(containsCommas)
    {
        listElement <- strsplit(list, ",")
        sapply(listElement, listElementsToNum)
    }
    else
    {
        listElementsToNum(list)
    }
}


