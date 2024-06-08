FERGHazardUI <- function(id, choiceList, diseaseList)
{
    fluidRow(
        
        box(
            fluidRow(
                column(3,shinyWidgets::pickerInput(NS(id,"dependentVar"),"Select Risk Metric", choiceList), offset = 1),
                column(3,
                       shinyWidgets::radioGroupButtons(
                           inputId = NS(id,"radioGraphType"),
                           label = "Choose Graph Type",
                           choices = c("Linear" = "linear" , "Log." = "log" , "Sqrt" = "squareroot"),
                           selected = "log")
                ),
                column(3, shinyWidgets::pickerInput(NS(id,"sortMetric"),"Select Sort Metric", c("Median", "Alphabetically"))),
                column(2, shinyWidgets::pickerInput(NS(id, "datasetSelect"), label = "Select Dataset", choices = list("Total population"="totalPop", "Under 5 years of age"="underFive", "Over five years of age"="overFive"), selected = "totalPop"))
            ),
            
            plotOutput(NS(id, "boxplot"), height = 900),
            
            
            width = 9, 
            height = 1000
        ),
        
        
        box(
            sidebarPanel(
              
                collapsibleSelectUI(NS(id,"diseaseSelect"), diseaseList),
                width = 12
            ),

            width = 3
        )
    )
}

FERGHazardServer <- function(id,data, diseaseList)
{
    moduleServer(id, function(input, output, session){
        
        dataset <- reactive(data[[input$datasetSelect]])
        
        diseaseSelectList <- collapsibleSelectServer("diseaseSelect", diseaseList)
        
        allSelectedDiseases <- reactive(
          unlist(
            sapply(diseaseSelectList, function(reactiveVal){
              reactiveVal()
            })
          )
        )
        
        dependentData <- reactive({
          
          hazardDependentVarColumns <- c("hazard", input$dependentVar)
          dependentVarData <- dataset() %>% dplyr::select(hazard, input$dependentVar, haz_group) #Selects columns of main dataset 
          dependentDataSubset <- dependentVarData[dependentVarData$hazard %in% allSelectedDiseases(),hazardDependentVarColumns]  #Subsets based on selected diseases
        })
        
        
        orderedSubset <- reactive(
          {
            dependentDataTemp <- dependentData()
            if(input$sortMetric == "Median")
            {
              dependentDataTemp$hazard <- eval(parse(text = paste("with(dependentData(),reorder(hazard,",input$dependentVar,", median, na.rm = TRUE, ordered = TRUE))")))
              return(dependentDataTemp)
              
            }
            else
            {
              dependentDataTemp <- dependentDataTemp[order(dependentDataTemp$hazard),]
            }
          })
        
        
        

        output$boxplot <- renderPlot(
        {
          plotMetricBoxPlot(orderedSubset(),input)
        })

    })
}

plotMetricBoxPlot <- function(data,input)
{
    yVar <- input$dependentVar
    yAxisLimit <- getGlobalMinUpperOutlier(data, yVar)
    boxplot <- createBoxPlot(data,yAxisLimit,input) + scaleByGraphTypeFERG(input$radioGraphType)
    boxplot
}

