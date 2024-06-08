testType <- c("Albert Camus", "Kant")

list <- list(c("The Plague", "The Stranger"), c("God", "Suffering"))


ui <-

server <- function(input,output,session)
{
    output$text <- renderText({
        paste(input$check)
    })
}

shinyApp(ui, server)
