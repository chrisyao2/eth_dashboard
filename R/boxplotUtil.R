
getGlobalMinUpperOutlier <- function(data, yVar)
{
  
    minUpperFactorOutliers <- by(data[[yVar]], data["hazard"], getMinUpperFactorOutliers)
    globalMinUpperOutlier <- max(minUpperFactorOutliers, na.rm = TRUE)

    return(globalMinUpperOutlier)
}

getMinUpperFactorOutliers <- function(data)
{
    quartiles <- quantile(data, c(.25,.75), na.rm = TRUE)
    minUpperOultier = (2.5*quartiles[2]) - (1.5*quartiles[1])

    return(minUpperOultier)
}


# createBoxPlot <- function(data, yAxisLimit,input)
# {
#     ggplot(data, ggplot2::aes_string(x ="hazard", y = input$dependentVar)) +
#         ggplot2::geom_boxplot(
#             fill = "slateblue",
#             outlier.shape = NA,
#         ) +
# 
#         ggplot2::ylab(input$dependentVar) +
# 
#         ggplot2::xlab("Hazards") +
# 
#         ggplot2::coord_cartesian(ylim = c(.1,yAxisLimit)) +
# 
#         ggplot2::ggtitle(paste(input$dependentVar, "by Hazard")) +
# 
#         ggplot2::theme(axis.text.x = ggplot2::element_text(size = 18, angle = 45,hjust = 1),
#                        axis.title = ggplot2::element_text(size = 22),
#                        axis.text.y = ggplot2::element_text(size = 15),
#                        plot.title = ggplot2::element_text(hjust = 0.5,size = 25)
#         )
# }

createBoxPlot <- function(data, yAxisLimit,input)
{
  ggplot(data, ggplot2::aes_string(x ="hazard", y = input$dependentVar)) +
    ggplot2::aes(text = input$dependentVar)+
    ggplot2::geom_boxplot(
      fill = "#C2185B",
      outlier.shape = NA,
    ) +
    
    ggplot2::ylab(input$dependentVar) +
    
    ggplot2::xlab("Hazards") +
    
    ggplot2::coord_cartesian(ylim = c(.1,100000000)) +
    
    ggplot2::ggtitle(paste(input$dependentVar, "by Hazard")) +
    
    ggplot2::theme(axis.text.x = ggplot2::element_text(size = 18, angle = 45,hjust = 1),
                   axis.title = ggplot2::element_text(size = 22),
                   axis.text.y = ggplot2::element_text(size = 15),
                   plot.title = ggplot2::element_text(hjust = 0.5,size = 25)
    )
}


createColorBoxPlot <- function(data, yAxisLimit,input, outlierColor)
{
    
    ggplot(data, ggplot2::aes_string(x = "hazard", y = input$dependentVar, fill = "group", text=input$dependentVar)) +
        ggplot2::geom_boxplot() +

        ggplot2::ylab(input$dependentVar) +

        ggplot2::xlab("Hazards") +

        ggplot2::coord_cartesian(ylim = c(.1,yAxisLimit)) +

        ggplot2::ggtitle(paste(input$dependentVar, "by Hazard")) +
    
        ggplot2::theme(axis.text.x = ggplot2::element_text(size = 18, angle = 45,hjust = 1),
                       axis.title = ggplot2::element_text(size = 22),
                       axis.text.y = ggplot2::element_text(size = 15),
                       plot.title = ggplot2::element_text(hjust = 0.5,size = 25),
                       
        ) +
    
        ggplot2::scale_fill_manual(values = c("#C2185B","#00BCD4"))
      
        
    
        #ggplot2::labs(caption = "The whiskers/tails of the boxplot are NOT necessarily the min/max values for each hazard. Instead, they are defined as follows: Upper whisker/tail = min(max(x), Q_3 + 1.5 * IQR)")
}


#ENSURES: Given the type of graph, the appropriate scaling is applied

scaleByGraphType <- function(type)
{
    if(type == "log")
    {
          
          #ggplot2::scale_y_continuous(trans=scales::pseudo_log_trans(base = 10), labels = scales::label_comma(), breaks=scales::extended_breaks(n=5))
        ggplot2::scale_y_continuous(trans=scales::pseudo_log_trans(base = 10), labels = scales::label_comma(), breaks=scales::log_breaks(n = 10, base = 10), expand = c(0, 0))
      

    }
    else if(type == "squareroot")
    {
        ggplot2::scale_y_sqrt() 
    }
  
    else if(type == "linear")
    {
      ggplot2::scale_y_continuous(labels = scales::label_number())
      
    }
}


scaleByGraphTypeFERG <- function(type)
{
  if(type == "log")
  {
    
    #ggplot2::scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x, n = 10),
    #                      labels = scales::trans_format("log10", scales::math_format(10^.x)))
    #ggplot2::scale_y_continuous(trans = "log10")
    
    ggplot2::scale_y_continuous(trans=scales::pseudo_log_trans(base = 10), labels = scales::label_comma(), breaks=scales::log_breaks(n = 10, base = 10), expand = c(0, 0))
    
    
    
  }
  else if(type == "squareroot")
  {
    ggplot2::scale_y_sqrt() 
  }
  
  else if(type == "linear")
  {
    ggplot2::scale_y_continuous(labels = scales::label_number())
    
  }
}


scaleByGraphType2 <- function(type,yLimit)
{
  if(type == "log")
  {
    
    #ggplot2::scale_y_log10(breaks = scales::trans_breaks("log10", function(x) 10^x, n = 10),
    #                       labels = scales::trans_format("log10", scales::math_format(10^.x)))
    #ggplot2::scale_y_continuous(trans = "log10")
    
    ggplot2::scale_y_continuous(trans=scales::pseudo_log_trans(base = 10), labels = scales::label_comma())
    
    
    
  }
  else if(type == "squareroot")
  {
    ggplot2::scale_y_sqrt() 
  }
  else if(type == "linear")
  {
    ggplot2::scale_y_continuous(labels = scales::label_number())
    
  }
}

