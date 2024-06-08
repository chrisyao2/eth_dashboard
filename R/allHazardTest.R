allHazardTestUI <- function(id,choiceList, diseaseList)
{
  fluidRow(
    box(
      fluidRow(
        column(2,shinyWidgets::pickerInput(NS(id,"dependentVar"),"Select Risk Metric", choiceList)),
        column(2,
               shinyWidgets::radioGroupButtons(
                 inputId = NS(id,"radioGraphType"),
                 label = "Choose Graph Type",
                 choices = c("Linear" = "linear" , "Log." = "log"),
                 selected = "log")
        ),
        column(3, shinyWidgets::pickerInput(NS(id,"sortMetric"),"Select Sort Metric", c("Median", "Alphabetically"))),
        column(3,
               fileInput(NS(id,"file1"), "Choose CSV File",
                         multiple = TRUE,
                         accept = c("text/csv",
                                    "text/comma-separated-values,text/plain",
                                    ".csv"))
        ),
        column(2, 
               shinyscreenshot::screenshotButton(label = "Screenshot Plot", id = NS(id, "boxplot")))
      ),
      
      plotOutput(NS(id, "boxplot"), height = 900),
      
      
      width = 9, 
      height = 1000
    ),
    
    # box(
    #   sidebarPanel(
    #     collapsibleSelectUI(NS(id,"diseaseSelect"),diseaseList),
    # 
    #     width = 12) ,
    # 
    #   width = 3, height = 1000
    #)
    
    
  )
}


#Requirements on Data
# - Data contains a "group" column that distinguishes the dataset each observation comes from
allHazardTestServer <- function(id, data,diseaseList)
{
  moduleServer(id, function(input, output, session)
  {

    allHazardData <- initalizeDataWithoutSubset(input,data)
    
    data <- reactiveValues(plot = plotNewHazBoxPlot(allHazardData(),input))

    userInputData <- reactive({
      req(input$file1)
      read.csv(input$file1$datapath)
    })
    
   observeEvent(input$file1,
   {
     combinedPlot <- plyr::rbind.fill(allHazardData(), userInputData())
     data$plot <- plotNewHazBoxPlot(combinedPlot,input)
   })
    
    
    #ATTEMPT TO 
    # observeEvent(input$file1,
    # {
    #     processedCombinedData <- initalizeCombinedData(input, data[["totalPopAndNewHaz"]], userInputData(), diseaseList)
    #     data$plot <- plotNewHazBoxPlot(processedCombinedData(),input)
    # })
    # 
    output$boxplot <- renderPlot(
    {
        (data$plot)()
    })
    
  }) 
  
  
}


initalizeDataWithoutSubset <- function(input,data)
{
    dataset <- data[["totalPopAndNewHaz"]]
    
    dependentDataSubset <- reactive(
      {
        hazardDependentVarColumns <- c("hazard", input$dependentVar,"group")
        dependentVarData <- dataset %>% dplyr::select(hazard, input$dependentVar, haz_group, group)
        return(dependentVarData[, hazardDependentVarColumns])
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
    
    return(orderedSubset)
  
}

# Returns a dataframe of the inital allHazard data ready to be plot
initAllHazardData <- function(input,data,diseaseList)
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
   
  return(orderedSubset)
}


#Parameter
#data - the union of AllHazardData with file input data
initalizeCombinedData <- function(input,oldData,newData,diseaseList)
{
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
      hazardDependentVarColumns <- c("hazard", input$dependentVar)
      dependentVarData <- oldData %>% dplyr::select(hazard, input$dependentVar)
      appendedVarData <- newData %>% dplyr::select(hazard, input$dependentVar)
      return(rbind(dependentVarData[dependentVarData$hazard %in% allSelectedDiseases(),hazardDependentVarColumns], appendedVarData))
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
  
  return(orderedSubset)
  
}


plotNewHazBoxPlot <- function(data,input)
{ 
  yVar <-  reactive({paste0(input$dependentVar)})
  yAxisLimit <- reactive(getGlobalMinUpperOutlier(data, yVar()))
  boxplot <- reactive(createColorBoxPlot(data,yAxisLimit(),input) + scaleByGraphType(input$radioGraphType) )
  
  boxplot
}


