
### MODULE WIDE REQUIRMENT
# - The formal parameter "checkBoxParamList" must be the same object for both functions collapsibleCheckBoxUI and collapsibleCheckBoxServer


#Requires checkBoxParamList to be a list of lists/vectors.
collapsibleSelectUI <- function(id, checkBoxParamList)
{
    print(paste("UI Select", id))
    numElements <- length(checkBoxParamList)
    uniqueId <- seq(1,numElements)
    namespaceIds <- as.character(uniqueId)

    fluidRow(
        
        column(12,offset = 0,
               
               div(style = "font-size: 16px;",
                   shinyWidgets::prettyCheckbox(NS(id,"selectAll"), label = div(style = "padding-left: 20px","Select All/None"), value = TRUE, status = "warning")
               ),
               mapply(collapsibleCheckBoxUI, NS(id,namespaceIds),names(checkBoxParamList),checkBoxParamList, SIMPLIFY = FALSE)
        )
    )
}

#Requires: A valid id and a string list
#Ensures: A string list consisting of all values checked in each collapsible group check box
collapsibleSelectServer <- function(id, checkBoxParamList)
{
    
    numElements <- length(checkBoxParamList)
    uniqueId <- seq(1,numElements)
    namespaceIds <- as.character(uniqueId)
    
    moduleServer(id, function(input, output, session){
       
        print(namespaceIds)
        selectAllVector <- list()

        for(i in 1:numElements)
        {
            selectAllVector$i <- reactive(input$selectAll)
        }
        mapply(collapsibleCheckBoxServer, namespaceIds, checkBoxParamList, selectAllVector, SIMPLIFY = FALSE)
    })
}


