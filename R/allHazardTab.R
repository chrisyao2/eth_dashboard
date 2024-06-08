allHazardTabUI <- function(id,choiceList, diseaseList)
{
  fluidRow(
      box(
          fluidRow(
              column(3,shinyWidgets::pickerInput(NS(id,"dependentVar"),"Select Risk Metric", choiceList), offset = 1),
              column(2,
                     shinyWidgets::radioGroupButtons(
                        inputId = NS(id,"radioGraphType"),
                        label = "Choose Graph Type",
                        choices = c("Linear" = "linear" , "Log." = "log"),
                        selected = "log")
              ),
              column(2, shinyWidgets::pickerInput(NS(id,"sortMetric"),"Select Sort Metric", c("Median", "Alphabetically"))),
              column(2, shinyWidgets::switchInput(NS(id,"darkMode"),label = "Dark Mode", labelWidth = "150px", value = FALSE)),
              column(2, 
                     shinyscreenshot::screenshotButton(label = "Screenshot Plot", id = NS(id, "boxplot"))),
          ),
            
          plotOutput(NS(id, "boxplot"), height = 900),
          
          #Uncomment line below and comment "plotOutput(NS(id, "boxplot"), height = 900)" for hover
          #plotly::plotlyOutput(NS(id, "boxplot"), height = 900),
          
        
          width = 9, 
          height = 1000
    ),

    box(
      sidebarPanel(
        collapsibleSelectUI(NS(id,"diseaseSelect"),diseaseList),

        width = 12) ,

      width = 3, height = 1000
    )

    
  )
}


#Requirements on Data
# - Data contains a "group" column that distinguishes the dataset each observation comes from
allHazardTabServer <- function(id, data,diseaseList)
{
  moduleServer(id, function(input, output, session)
  {
    dataset <- data[["totalPopAndNewHaz"]]
    
    diseaseSelectList <- collapsibleSelectServer("diseaseSelect", diseaseList)

    allSelectedDiseases <- reactive(
      unlist(
        sapply(diseaseSelectList, function(reactiveVal){
          reactiveVal()
        })
      )
    )
 
    dependentDataSubset <- reactive(
    {
      hazardDependentVarColumns <- c("hazard", input$dependentVar,"group")
      dependentVarData <- dataset %>% dplyr::select(hazard, input$dependentVar, haz_group, group)
      return(dependentVarData[dependentVarData$hazard %in% allSelectedDiseases(),hazardDependentVarColumns])
    })
 

    orderedSubset <- reactive(
    {
        dependentDataTemp <- dependentDataSubset()
        if(input$sortMetric == "Median")
        {
            dependentDataTemp$hazard <- eval(parse(text = paste("with(dependentDataSubset(),reorder(hazard,",input$dependentVar,", median, na.rm = TRUE, ordered = TRUE))")))
            return(dependentDataTemp)

        }
        else
        {
            dependentDataTemp <- dependentDataTemp[order(dependentDataTemp$hazard),]
        }
    })


    
    output$boxplot <- renderPlot(
    {
        plotBoxPlot(orderedSubset(),input)
    })
    
    #For hover, uncomment. the code chunk below while commenting out the renderPlot code chunk above
    # output$boxplot <- plotly::renderPlotly(
    # {
    #     plotBoxPlotHover(orderedSubset(),input)
    # })

  })


}

plotBoxPlot <- function(data,input)
{
    yVar <- input$dependentVar
    yAxisLimit <- getGlobalMinUpperOutlier(data, yVar)
    boxplot <- createColorBoxPlot(data,yAxisLimit,input, outlierColor = "#ECFA78") + scaleByGraphType(input$radioGraphType) 
    
    if(input$darkMode == TRUE)
    {
        boxplot <- boxplot + ggplot2::theme_dark()
    }
    
    return(boxplot)

}

plotBoxPlotHover <- function(data,input)
{
    yVar <- input$dependentVar
    yAxisLimit <- getGlobalMinUpperOutlier(data, yVar)
    boxplot <- createColorBoxPlot(data,yAxisLimit,input, outlierColor = "#ECFA78") + scaleByGraphType(input$radioGraphType) 
    
    if(input$darkMode == TRUE)
    {
      return(boxplot %>% plotly::ggplotly(tooltip="text")%>% plotly::layout(autosize = T,legend = list(orientation = "h"), yaxis = list(title=list(font = list(size = 20))), xaxis=list(title=list(font = list(size = 30))), plot_bgcolor='rgb(70, 70, 70)') ) 
    }
    else
    {
      return(boxplot %>% plotly::ggplotly(tooltip="text")%>% plotly::layout(autosize = T,legend = list(orientation = "h"), yaxis = list(title=list(font = list(size = 20))), xaxis=list(title=list(font = list(size = 30)))))
    }
  
}


