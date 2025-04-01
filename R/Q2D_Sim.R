###3 CREATE EMPIRICAL CDF FROM QUANTILES ###3
## Based on Billy's dm.R script

#date edited: 02/06/2021


#Requires:
#     1. dependentVarList is a string vector that will correspond to the resulting dataframe's column names
#     2. length(boundsData) = length(dependentVarList) and the ith element of dependentVarList corresponds to the name of ith value of boundsData
runSimulation <- function(boundsData, diseaseName, diseaseType, dependentVarList)
{
    #probability <- replicateParam(length(boundsData),c(0, .025, .5,.975, 1)) # probabilities for each interval
    probability <- replicateParam(length(boundsData),c(.025, .5,.975)) # probabilities for each interval
    overShootVal <- replicateParam(length(boundsData),0.1) # overshoot value
    n_point <- replicateParam(length(boundsData),10000) # n of interpolation for CDF

    #simulationResults <- mapply(simulate, boundsData, overShootVal,probability, n_point, SIMPLIFY = FALSE)
    simulationResults <- simulate_new(boundsData,probability,n_point)
    simulationResults <- do.call(cbind,lapply(simulationResults,as.data.frame))
    names(simulationResults) <- dependentVarList
  
    #combinedResults <- combineSimResults(simulationResults, dependentVarList)

    appendedDiseaseInfo <- appendDiseaseInfo(simulationResults,diseaseName, diseaseType)
    return(appendedDiseaseInfo)

}


combineSimResults <- function(simulationResults, resultNames)
{
    mergedData <- do.call(cbind, simulationResults)
    names(mergedData) <- resultNames
    return(mergedData)
}

appendDiseaseInfo <- function(data, diseaseName, diseaseType)
{
    numRow <- nrow(data)
    diseaseVec <- rep(diseaseName, times = numRow)
    diseaseTypeVec <- rep(diseaseType, times = numRow)

    data$hazard <- diseaseVec
    data$haz_group <- diseaseTypeVec

    return(data)

}

replicateParam <- function(length,vector)
{
    replicate(length,vector, simplify = FALSE)
}


