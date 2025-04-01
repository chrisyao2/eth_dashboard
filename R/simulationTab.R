SimulationUI <- function(id)
{
  
  fluidPage(
   
    
    fluidRow(
      box(
      tags$h1("Purpose"),
      tags$p("The purpose of this tab is to give users the freedom to produce data with their own hazards using the same simulation that produced the data displayed on the dashboard. 
                            The sections below show how to use the simulation step-by-step."),
      
      
      width = 12,solidHeader = TRUE
      )
    ),
    fluidRow(
      
         box(
           tags$h1("1. Preparing the Data"),
           tags$h2("Data Types"),
           
           tags$p("The data needed to run the simulation may take on many forms, such as numbers and letters. As a result, we have defined a way to group similar data into 
                     what is refered as data types, and are defined below."),
           
           tags$ul(
             tags$li("Character Type - Any ASCII character which includes any character from a standard keyboard e.g. letters, numerical digits, special characters, etc"),
             tags$li("Numerical Type - Any string of real numbers e.g. 1234.12, 1000, 3.141592"),
             tags$li("n-tuple - A list of n numerical type strings separated by commas where n is an integer e.g A 3-tuple: 30,40,300")
           ),
           
           tags$p("The simulation requires the following information in the specified format for each hazard: "),
           tags$ul(
             tags$li("Hazard Name - Type Character that denotes the name of the hazard "),
             tags$li("Hazard Type - Type Character that denotes the hazard type"),
             tags$li("N Dependent Variables with Bounds - Bounds are a 3-tuple and N is an integer"),
           ),
           width = 12,solidHeader = TRUE
         ),
      
      
      
         box(
           tags$h1("2. Formatting the Data"),
           tags$h2("Input File Types"),
           
           tags$p("The simulation takes two file types: CSV and Excel(.xlsx). It is recommeded to input the data in an Excel sheet and then export as a CSV as it is easier to format the data"),
           
           tags$h2("Data Format"),
           tags$p("The data in Excel must follow the format in the image below. The header value does not need to match the names in the image."),
           tags$br(),
           tags$ul(
             tags$li("Column 1 - Contains the Hazard Name defined in Step 1"),
             tags$li("Column 2 - Contains the Hazard Type defined in Step 1"),
             tags$li("Remaining Columns - Contains the bound values for each dependent variable"),
           ),
           
           tags$img(src = "SimulationFormat.png", width = "50%", height = "50%"),
           
           width = 12,solidHeader = TRUE
         ),


         box(
           tags$h1("3. Running the Simulation"),
           tags$p("With the last two steps completed, we are ready to run the simulation by utilizing the graphical interface below. "),
           
           tags$ul(
             tags$li("1. File Selection - Click the Browse button and select the CSV file created from Step 2"),
             tags$li("2. Delimiter/Separator - Select the delimiter used by the CSV file"),
             tags$li("3. Output Name - Choose a name for the output data file without the file extension"),
             tags$li("4. Click the Run Sim Button and choose the download location"),
           ),
           
           
           width = 12,solidHeader = TRUE
         )
      
    ),
    
    
    tags$br(),
    titlePanel("File Config"),
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
      
      # Sidebar panel for inputs ----
      sidebarPanel(
        
        radioButtons(NS(id,"fileType"), "File Type",
                     choices = c(Excel = 1,
                                 CSV = 2),
                     selected = 1),
        
        # Input: Select a file ----
        fileInput(NS(id,"file1"), "Choose File",
                  multiple = TRUE,
                  accept = c("text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv",
                             ".xlsx")),
        
        # Horizontal line ----
        tags$hr(),
        
        
        # Input: Select separator ----
        radioButtons(NS(id,"sep"), "Separator",
                     choices = c(Comma = ",",
                                 Semicolon = ";",
                                 Tab = "\t"),
                     selected = ","),
        
  
        tags$br(),
        
        textInput(NS(id,"downloadText"), "Download Name", value = "", width = NULL, placeholder = "Sim")
        
      ),
      
      
      # Main panel for displaying outputs ----
      mainPanel(
        # Output: Data file ----
        tableOutput(NS(id,"contents")),
        downloadButton(NS(id,"downloadData"), "Run Sim & Download Data")
      )
      
    )
  )
}

SimulationServer <- function(id)
{
  moduleServer(id,function(input,output,session)
  {
    
    
    inputData <- reactive({
      req(input$file1)
      
      if(input$fileType == 1)
      {
        readxl::read_excel(input$file1$datapath)
      }
      else
      {
        read.csv(input$file1$datapath,
                 #header = input$header,
                 sep = input$sep,
                 #quote = input$quote,
                 
                 )
        
        
      }
    })
    
    
    output$contents <- renderTable({
      
      return(head(inputData()))
      
    })
    
    simulationData <- reactive(autoSimImportedData(inputData()))
    
    output$downloadData <- downloadHandler(
      filename = function() {
        paste(input$downloadText, ".csv", sep = "")
      },
      content = function(file) {
        write.csv(simulationData(), file, row.names = FALSE)
        #saveRDS(simulationData(), file)
      }
    )
    
    # output$exampleCSV <- downloadHandler(
    #   filename = function() {
    #     paste("EthiopianParamCSV", ".csv", sep = "")
    #   },
    #   content = function(file) {
    #     file.copy("EthiopianParamCSV.csv", file)
    #   },
    #   contentType = "text/csv"
    # )
    # 
    
    
    
  })
}