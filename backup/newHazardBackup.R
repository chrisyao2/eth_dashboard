# newHazardTabUI <- function(id,choiceList)
# {
#     diseaseTypeChoiceVector <- getDiseaseTypeChoices()
#
#     fluidRow(
#         box(plotOutput(NS(id, "boxplot"), height = 800), width = 9, height = 800),
#
#         box(
#             sidebarPanel(
#
#                 selectInput(NS(id, "dependentVar"), "Select Dependent Var.",choiceList),
#
#                 checkboxGroupInput(NS(id,"diseaseTypeCBox"), label = "Disease Type", choices = diseaseTypeChoiceVector),
#
#                 checkboxInput(NS(id,"diseaseCBoxControl"), label = "Select All/None", value = TRUE),
#
#                 width = 12) ,
#
#             width = 3, height = 800
#         )
#     )
# }
#
#
# #Requirements on Data
# # - Data contains a "group" column that distinguishes the dataset each observation comes from
# newHazardTabServer <- function(id, data)
# {
#     moduleServer(id, function(input, output, session)
#     {
#         observe({
#           updateCheckboxGroupInput(session, "diseaseTypeCBox", choices = getDiseaseTypeChoices(), selected = if(input$diseaseCBoxControl) getDiseaseTypeChoices())
#         })
#
#         dataSelected <- data[["totalPopAndNewHaz"]]
#
#         dependentDataSubset <- reactive({
#             hazardDependentVarColumns <- c("hazard", input$dependentVar,"group")
#             dependentVarData <- dataSelected %>% dplyr::select(hazard, input$dependentVar, haz_group, group)
#             dependentDataSubset <- dependentVarData[dependentVarData$haz_group %in% input$diseaseTypeCBox,hazardDependentVarColumns]
#         })
#
#         output$boxplot <- renderPlot(
#         {
#             plotNewHazBoxPlot(dependentDataSubset(),input)
#         })
#     })
#
#
# }
#
