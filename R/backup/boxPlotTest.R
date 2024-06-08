
outlierTest <- function()
{
    data <- getAllData()
    
    totalPopAndHazData <- data$totalPopAndNewHaz
    
    getGlobalMinUpperOutlier(totalPopAndHazData, "Incidence")
}
