
getAllData <- function()
{
    #FERG Data without 100k Rates
    totalPopData <- loadFERGData("data/FERGData/20200908_met_bio_dat_all.rds")
    underFiveData <- loadFERGData("data/FERGData/20200908_met_bio_dat_u5.rds")
    overFiveData <- loadFERGData("data/FERGData/20200908_met_bio_dat_o5.rds")

    newHazardData <- loadNewHazardData()
    
    names(newHazardData)[names(newHazardData) == 'Case fatality ratio'] <- 'Case_fatality_ratio'
    names(newHazardData)[names(newHazardData) == 'DALYs per Case'] <- 'DALY_per_case'
    
    totalPopSubset <- totalPopData[, c("hazard", "haz_group", "Incidence", "Mortality", "DALYs","Incidence_Rate_100K", "Mortality_Rate_100K", "DALY_Rate_100K","Case_fatality_ratio", "DALY_per_case")]

    totalPopAndNewHazData <- combineDatasets(newHazardData,totalPopSubset)

    dataList <- list(totalPop = totalPopData, underFive = underFiveData, totalPopAndNewHaz = totalPopAndNewHazData, overFive = overFiveData)
    names(dataList)
    return(dataList)
}

loadFERGData <- function(filePath)
{
    data <- readRDS(filePath)
    data$case_fatality_ratio <- data$mrt / data$inc * 100
    
    data$hazard <- as.character(data$hazard)
    data$hazard[data$hazard == "Aflatoxin"] <- "Aflatoxin B1"
    
    
    names(data) <- c("hazard","haz_group","Population","Incidence","Mortality","DALYs","YLL","YLD",
                     "Incidence_Rate_100K","Mortality_Rate_100K","DALY_Rate_100K","YLL_Rate_100K","YLD_Rate_100K","DALY_per_case","DALYs_per_1000_Cases","Case_fatality_ratio")

    
    data <- orderDiseaseTypes(data)
}

loadNewHazardData <- function()
{
    #newHazardData <- readRDS("data/sim_lowerbound0/newHazEthSim.rds")
    
    #Data from CFI Sim but without updated data
   # newHazardData <- readRDS("data/sim_lowerbound0/CFISimulation/CFISim1.rds")
    
    #CFI Sim data but with renamed Diseases
    #newHazardData <- readRDS("data/sim_lowerbound0/CFISimulation/CFISim1_UpdatedName.rds")
    #newHazardData <- readRDS("data/UpdatedNonFERG.rds")
    
  
    newHazardData <- readRDS("data/rmqi_sim_results.rds")
    
    newHazardData$hazard <- as.factor(newHazardData$hazard)
    newHazardData$Case_fatality_ratio <- newHazardData$Case_fatality_ratio * 100
    newHazardData <- orderDiseaseTypes(newHazardData)
    return(newHazardData)
}

#Requires data to have column named "haz_group"
orderDiseaseTypes <- function(data)
{
    data$haz_group <- ordered(data$haz_group, levels = c("Diarrheal disease - virus","Diarrheal disease - bacteria" ,"Diarrheal disease - protozoa",
                                                                        "Invasive infectious disease agents - virus", "Invasive infectious disease agents - bacteria",
                                                                        "Invasive infectious disease agents - protozoa","Helminths - cestodes","Helminths - nematodes",
                                                                        "Helminths - trematodes","Chemicals and toxins","Metals"))

    return(data)

}



# Requires both dataset1 and dataset2 to have same number of rows
# Requires dataset1 to contain New Hazard and dataset2 to be FERG Data
combineDatasets <- function(dataset1, dataset2)
{
    groupNew <- rep("New Hazard", length(nrow(dataset1)))
    groupOld <- rep("FERG Hazard", length(nrow(dataset2)))

    dataset1$group <- groupNew
    dataset2$group <- groupOld

    combinedDataSet <- rbind(dataset1, dataset2)
    return(combinedDataSet)
}


selectData <- function(userselect)
{
    if (userselect == "TotalPop"){
        data = TP
    } else if (userselect == "UnderFive"){
        data = U5
    } else if (userselect == "OverFive"){
        data = O5
    } else {
        print("error")
    }
    return(data)
}

#Requires: dataframe to be a dataframe
#          columnName must be a string that is a column name in dataframe
getUniqueColumnVals <- function(dataframe, columnName)
{
    return(unique(dataframe[,columnName]))
}




