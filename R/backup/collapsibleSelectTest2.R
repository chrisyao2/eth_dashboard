collapsibleSelectApp2 <- function(checkBoxParamList)
{
    ui <- dashboardPage(
        dashboardHeader(disable = TRUE),
        dashboardSidebar(disable = TRUE),
        dashboardBody(
            collapsibleSelectUI("select", checkBoxParamList),
            textOutput("text")
        )
    )

    server <-  function(input, output, session)
    {

        val <- collapsibleSelectServer("select", checkBoxParamList)
        allSelectedDiseases <- reactive(unlist(sapply(val, function(reactiveVal){
            reactiveVal()
        })))

        output$text <- renderText({
            paste(allSelectedDiseases())
        })
    }

    shinyApp(ui,server)
}



routineTest <- function()
{
    checkBoxList <- list("Games" = c("reddit", "csgo"), "Chemicals" = c("Hello", "World"))
    collapsibleSelectApp2(checkBoxList)
}
