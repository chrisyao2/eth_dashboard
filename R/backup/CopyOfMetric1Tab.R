#
# metric1SelectBox <- function(id,namespaceId, label,choiceList)
# {
#     selectInput(NS(id, namespaceId), label = label, choices = choiceList, selected = choiceList[1])
# }
#
# getDiseaseTypeChoices <- function()
# {
#     c("Diarrheal disease - virus","Diarrheal disease - bacteria" ,"Diarrheal disease - protozoa",
#       "Invasive infectious disease agents - virus", "Invasive infectious disease agents - bacteria",
#       "Invasive infectious disease agents - protozoa","Helminths - cestodes","Helminths - nematodes",
#       "Helminths - trematodes","Chemicals and toxins","Metals")
# }
#
# Metric1UI <- function(id, choiceList)
# {
#
#     diseaseTypeChoiceVector <- getDiseaseTypeChoices()
#
#     fluidRow(
#         box(plotly::plotlyOutput(NS(id,"boxplot"), height = 700), width = 9),
#         #box(plotOutput(NS(id,"boxplot"), height = 750), width = 9),
#
#         box(
#             sidebarPanel(
#
#                 metric1SelectBox(id, "datasetSelect", "Select Dataset", list("Total population"="totalPop", "Under 5 years of age"="underFive", "Over five years of age"="overFive")),
#
#                 metric1SelectBox(id, "dependentVar", "Select Dependent Var.", choiceList),
#
#                 checkboxGroupInput(NS(id,"diseaseTypeCBox"), label = "Disease Type", choices = diseaseTypeChoiceVector),
#
#                 checkboxInput(NS(id,"diseaseCBoxControl"), label = "Select All/None", value = TRUE),
#
#                 width = 12
#             ),
#
#             width = 3
#         )
#     )
# }
#
# Metric1Server <- function(id,data)
# {
#     moduleServer(id, function(input, output, session){
#
#         observe({
#             updateCheckboxGroupInput(session, "diseaseTypeCBox", choices = getDiseaseTypeChoices(), selected = if(input$diseaseCBoxControl) getDiseaseTypeChoices())
#         })
#
#         dataset <- reactive(data[[input$datasetSelect]])
#
#
#         output$boxplot <- plotly::renderPlotly(
#         {
#             dependentVarData <- dataset() %>% dplyr::select(hazard, input$dependentVar, haz_group)
#             hazardDependentVarColumns <- c(1,2)
#             dependentDataSubset <- dependentVarData[dependentVarData$haz_group %in% input$diseaseTypeCBox,hazardDependentVarColumns]
#
#             plotBoxPlot(dependentDataSubset,input)
#         })
#
#         # output$boxplot <- renderPlot(
#         # {
#         #     hazardDependentVarColumns <- c(1,2)
#         #     dependentVarData <- dataset() %>% dplyr::select(hazard, input$dependentVar, haz_group)
#         #     dependentDataSubset <- dependentVarData[dependentVarData$haz_group %in% input$diseaseTypeCBox,hazardDependentVarColumns]
#         #
#         #     plotBoxPlot(dependentDataSubset,input)
#         #   })
#
#     })
# }
#
#
# plotBoxPlot <- function(data,input)
# {
#     yAxisLimit <- getGlobalMinUpperOutlier(data)
#     boxplot <- createBoxPlot2(data,yAxisLimit,input)
#     #boxplot <- createBoxPlot(data,yAxisLimit,input)
#     boxplot
# }
#
# getGlobalMinUpperOutlier <- function(data)
# {
#     minUpperFactorOutliers <- by(data$Incidence, data[1], getMinUpperFactorOutliers)
#     globalMinUpperOutlier <- max(minUpperFactorOutliers, na.rm = TRUE)
#
#     return(globalMinUpperOutlier)
# }
#
# getMinUpperFactorOutliers <- function(data)
# {
#     quartiles <- quantile(data, c(.25,.75))
#     minUpperOultier = (2.5*quartiles[2]) - (1.5*quartiles[1])
#
#     return(minUpperOultier)
# }
#
# createBoxPlot <- function(data, yAxisLimit,input)
# {
#     ggplot(data, ggplot2::aes_string(x = "hazard", y = input$dependentVar)) +
#         ggplot2::geom_boxplot(
#             fill = "slateblue",
#             outlier.shape = NA,
#         ) +
#
#         ggplot2::ylab(input$dependentVar) +
#
#         ggplot2::xlab("Hazards") +
#
#         ggplot2::coord_cartesian(ylim = c(0,yAxisLimit)) +
#
#         ggplot2::scale_y_sqrt() +
#
#         ggplot2::theme(axis.text.x = ggplot2::element_text(size = 15, angle = 45,hjust = 1),
#                        axis.title = ggplot2::element_text(size = 20)
#                        )
# }
#
# createBoxPlot2 <- function(data, yAxisLimit, input)
# {
#     boxPlot <- plotly::plot_ly(data, y = ~get(input$dependentVar, quartilemethod="exclusive")) %>% plotly::add_boxplot(x = ~hazard, boxpoints = "outliers") %>% plotly::layout(yaxis = list(range = c(0,yAxisLimit)))
#
#       #plotly::layout(yaxis = list(range = c(0,log(yAxisLimit)), type = "log"))
# }
#
#
