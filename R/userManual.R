userManualTabUI <- function(id)
{
  fluidRow(
  
    
      uiOutput(NS(id,"pdfview"))
    )
}


userManualTabServer <- function(id)
{
  moduleServer(id, function(input, output, session)
  {
    output$pdfview <- renderUI({
      tags$iframe(style="height:800px; width:100%", src="User_Manual.pdf")
    })
  })
}