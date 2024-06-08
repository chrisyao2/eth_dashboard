ui <- fluidPage(
  fileInput("file1", "Choose CSV File",
            multiple = TRUE,
            accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),


  actionButton("add", "Add UI"),

  sidebarPanel(
    tags$div(id ="placeholder"),

    width = 12)



)

# Server logic
server <- function(input, output, session) {
  observeEvent(input$file1, {
    insertUI(
      selector = "#placeholder",
      where = "afterEnd",
      ui = collapsibleSelectUI("test", FERGDiseaseList)
    )
  })
}

# Complete app with UI and server components
shinyApp(ui, server)


