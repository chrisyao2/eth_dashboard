
collapsibleSelectApp <- function(checkBoxParamList)
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

        #collapsibleSelectServer("select", checkBoxParamList)

        #output$text <- renderText(paste(list()))
    }

    shinyApp(ui,server)
}

collapsibleTitledSelectApp <- function(title,checkBoxParamList)
{
    ui <- dashboardPage(
        dashboardHeader(disable = TRUE),
        dashboardSidebar(disable = TRUE),
        dashboardBody(
            collapsibleSelectUI("select", title, checkBoxParamList),
            textOutput("text")
        )
    )

    server <-  function(input, output, session)
    {

        val <- collapsibleSelectServer("select", title,checkBoxParamList)
        allSelectedDiseases <- reactive(unlist(sapply(val, function(reactiveVal){
            reactiveVal()
        })))

        output$text <- renderText({
            paste(allSelectedDiseases())
        })
    }

    shinyApp(ui,server)
}

singleBoxApp <- function(title, checkBoxList)
{
    ui <- dashboardPage(
        dashboardHeader(disable = TRUE),
        dashboardSidebar(disable = TRUE),
        dashboardBody(
            collapsibleCheckBoxUI("box",title, checkBoxList),
            textOutput("text")
        )
    )

    server <-  function(input, output, session)
    {
        list <- collapsibleCheckBoxServer("box", checkBoxList)

        output$text <- renderText(paste(list()))
    }

    shinyApp(ui,server)

}

doubleBoxApp <- function(title, checkBoxList)
{
    ui <- dashboardPage(
        dashboardHeader(disable = TRUE),
        dashboardSidebar(disable = TRUE),
        dashboardBody(
            collapsibleCheckBoxUI("box1",title, checkBoxList),
            collapsibleCheckBoxUI("box2", title, checkBoxList),


        )
    )

    server <-  function(input, output, session)
    {
        #collapsibleCheckBoxServer("select", checkBoxList)
    }

    shinyApp(ui,server)

}


testCollapsibleBox <- function()
{
    checkBoxList <- list("Diarrheal" = c("reddit", "csgo"), "Chemicals" = c("Hello", "World"))

    collapsibleSelectApp(checkBoxList)

}

testVectorizedBox <- function()
{
    titleList <- c("Diarrheal", "Chemicals")
    checkBoxList <- list(c("reddit", "csgo"), c("hello", "world"))

    collapsibleTitledSelectApp(titleList, checkBoxList)
}

testSingleBox <- function()
{
    checkBoxList <- list("reddit", "csgo")

    singleBoxApp("Diarrheal",checkBoxList)
}

testDoubleBox <- function()
{
    checkBoxList <- list("reddit", "csgo")

    doubleBoxApp("Diarrheal",checkBoxList)
}

testSingleVectorizedBox <- function()
{
    checkBoxList <- c("reddit", "csgo")
    singleBoxApp("Diarrheal",checkBoxList)
}

