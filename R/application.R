options(shiny.maxRequestSize = 30*1024^2)

dashboardApplication <- function()
{
    ethDataList <- getAllData()
    computeDiseaseList(ethDataList$totalPop)
    ui <- dashboardUI()
    server <- dashboardServer(input, output, session,ethDataList)
    

    shinyApp(ui,server)
}
