
bacillisLogTest <- function()
{
  data <- newHazEthSim2[newHazEthSim2$hazard == "Bacillis Anthrax", c("Incidence", "hazard")]
  #data <- newHazEthSim2[, c("Incidence", "hazard")]
  plot <- ggplot2::ggplot(data, ggplot2::aes_string(x ="hazard", y = "Incidence"))+ 
          ggplot2::geom_boxplot()#+
          #ggplot2::scale_y_log10()
 
  pg <- ggplot2::ggplot_build(plot)
  
  plotInfo <- pg$data[[1]]
  
  print(plotInfo)
  
  return(plot)
}

medianTest <- function()
{
  
    data <- newHazEthSim2[, c("hazard", "Incidence")]
    df1 <- data %>% dplyr::group_by(hazard)
    df2 <- df1 %>% summarise((median = median(newHazEthSim2$Incidence, na.rm = TRUE)))
    
    bacillis <- data[data$hazard == "Bacillis Anthrax",]
    print(median(bacillis$Incidence, na.rm = TRUE))
   
  
}

