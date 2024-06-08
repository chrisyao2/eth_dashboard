
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
