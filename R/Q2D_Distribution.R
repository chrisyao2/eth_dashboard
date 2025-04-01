
simulate <- function(boundVector, overShootVal, probabilityVec, n_point)
{
    cdf <- generateCDF(boundVector, overShootVal, probabilityVec)
    uniformData <- generateObsUniform(n_point)
    result <- as.data.frame(mapUniformToCDF(cdf, uniformData))
    return(result)
}

generateCDF <- function(boundVector, overshoot, probabilityVec)
{

    xAxis <- probabilityVec

    lower <- boundVector[1]
    median <- boundVector[2]
    upper <- boundVector[3]

    yAxis <- c(0, lower, median, upper, overshoot * (upper - lower) + upper)

    cumulativeDistribution <- approxfun(x = xAxis, y = yAxis, method = "linear")

    return(cumulativeDistribution)
}


generateObsUniform <- function(numPoints)
{
    result <- runif(numPoints, min = 0, max = 1)
}


#param: cdf is a linear interpolated function
mapUniformToCDF <- function(cdf, uniformData)
{
  result <- cdf(uniformData)
}


simulate_new <- function(boundVector, probabilityVec, n_point)
{
   # Use pmap to generate random samples
   return(purrr::pmap(list(mqi=boundVector, n=n_point, mqi.quantile=probabilityVec), mc2d::rmqi))
   # Create dataframe with samples and identifiers
  
}


unitTest <- function()
{
   
}