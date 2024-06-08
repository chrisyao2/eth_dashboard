
### MODULE WIDE REQUIRMENT
# - The formal parameter "checkBoxList" of collapsibleCheckBoxServer must be the same object or a subset of the formal parameter "checkBoxList" for collapsibleCheckBoxUI


#Requires a string "checkBoxTitle" and a list/vector of strings "checkBoxList"
# The list/vector "checkBoxList" must not contain named elements
#Ensures: A graphical box defined in the documentation consisting of a checkbox titled "checkBoxTitle" and a collapsible list containing the names of each string in "checkBoxList"
collapsibleCheckBoxUI <- function(id, checkBoxTitle, checkBoxList)
{
    #print(paste("UI BOX", id))
    tags$head(
         tags$link(rel = "stylesheet", type = "text/css", href = "collapsibleBox.css")
    )

    fluidRow(
        column(1, shinyWidgets::prettyCheckbox(NS(id, "selectAll"), label = NULL, status = "warning")),

        column(10, box(
            title = checkBoxTitle, status = "warning",
            collapsible = TRUE,
            checkboxGroupInput(NS(id, "checkBox"), choices = checkBoxList, label = NULL),
            width = 12
        ))

    )
}

#Requires: A valid id and a string list/vector "checkBoxList"
#Ensures: A reactive list containing the names of each value in checkBoxList that has been checked will be returned
collapsibleCheckBoxServer <- function(id, checkBoxList, updateSelectAll)
{
    moduleServer(id, function(input, output, session){
        #print(paste("Server NON BOX", id))
        observe(
        {
            updateCheckboxGroupInput(session, "checkBox", choices = checkBoxList, selected = if(input$selectAll) checkBoxList)
        })
        
        observeEvent(updateSelectAll(), 
        {
            
                    if(updateSelectAll())
                    {
                        shinyWidgets::updatePrettyCheckbox(session, inputId = "selectAll", value = TRUE)
                    }
                    else
                    {
                        shinyWidgets::updatePrettyCheckbox(session, inputId = "selectAll", value = FALSE)
                    }
        })
        
        return(reactive(input$checkBox))
    })
    
}

collapsibleCheckBoxServerTest <- function(id, checkBoxList, updateSelectAll)
{
    #print(paste("Server BOX", id))
    moduleServer(id, function(input, output, session){
        
        observe(
            {
                
                updateCheckboxGroupInput(session, "checkBox", choices = checkBoxList, selected = if(input$selectAll) checkBoxList)
            })
        
    })
}

