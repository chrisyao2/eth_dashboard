customHazardTabUI <- function(id)
{
  
  fluidRow(
    box(
      fluidRow(
        column(2,shinyWidgets::pickerInput(NS(id,"dependentVar"),"Select Risk Metric", choices = "No Diseases")),
        column(3,
               shinyWidgets::radioGroupButtons(
                 inputId = NS(id,"radioGraphType"),
                 label = "Choose Graph Type",
                 choices = c("Linear" = "linear" , "Log." = "log" , "Sqrt" = "squareroot"),
                 selected = "log")
        ),
        column(2, shinyWidgets::pickerInput(NS(id,"sortMetric"),"Select Sort Metric", c("Median", "Alphabetically"))),
        
        column(4,
          fileInput(NS(id,"file1"), "Choose CSV File",
                    multiple = TRUE,
                    accept = c("text/csv",
                               "text/comma-separated-values,text/plain",
                               ".csv")),
          actionButton(NS(id,"submitButton"), label = "Submit")
        )
        
      ),

      plotOutput(NS(id, "boxplot"), height = 900),


      width = 9,
      height = 1000
    ),
    
    box(
      sidebarPanel(
        tags$div(id= "placeholder"),
        width = 12) ,

      width = 3, height = 1000
    )


  )

  
  }


customHazardTabServer <- function(id)
{
  moduleServer(id,function(input,output,session)
  {
    print(paste("Server Select", id))
    dataset <- reactive({
      req(input$file1)
      read.csv(input$file1$datapath)
    })
    

     
   
    observeEvent(input$file1,
    {
      choiceList <- computeChoiceList(dataset())
      diseaseList <- computeDiseaseList(dataset())
      
      freezeReactiveValue(input, "dependentVar")
      shinyWidgets::updatePickerInput(session, input = "dependentVar", choices =  choiceList)
      
      insertUI(selector = "#placeholder",
               where = "beforeEnd",
               ui = collapsibleSelectUI(NS(id,"diseaseSelect"), diseaseList)
              )
      
       })
    

    
      
    observeEvent(input$submitButton,
    {
      diseaseList <- computeDiseaseList(dataset())
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
     
       output$boxplot <- renderPlot(
         {

           plotMetricBoxPlot(dependentData(),input)
         })

    
    #   dependentData <- reactive({
    # 
    #       hazardDependentVarColumns <- c("hazard", input$dependentVar)
    #       dependentVarData <- dataset() %>% dplyr::select(hazard, input$dependentVar, haz_group) #Selects columns of main dataset
    #       dependentDataSubset <- dependentVarData[dependentVarData$hazard %in% dataset(),hazardDependentVarColumns]  #Subsets based on selected diseases
    #     })
    # 
    #     output$boxplot <- renderPlot(
    #     {
    #         plotMetricBoxPlot(dataset(),input)
    #     })
    # 
    # })
    
    })
  })
}



computeChoiceList <- function(data)
{
    columnNames <- colnames(data)
    namesToRemoveIndices <- match(c("hazard", "haz_group"), columnNames) 
    columnNames <- columnNames[-namesToRemoveIndices]
}


computeDiseaseList <- function(data)
{
    
    data <- data[,c("hazard", "haz_group")]
    
    uniqueHazardGroups <- unique(data$haz_group)
    
    hazardList <- NULL
    
    for(i in 1:length(uniqueHazardGroups))
    {
        hazardVector <- NULL
        currentHazardGroup <- uniqueHazardGroups[i]
        subset <- data[data$haz_group == currentHazardGroup,]
        
        hazardVector <- unique(subset$hazard)
        hazardList[[i]] <- hazardVector
        
    }
    
    names(hazardList) <- uniqueHazardGroups
    return(hazardList)
}

