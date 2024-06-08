definitionTabUI <- function(id)
{
  fluidRow(
    
    fluidRow(
      column(1, headerPanel("Definitions"))
    
    ),
    
    
    box(
      tags$h3("Incidence"),
      tags$p("The number of newly diagnosed cases (that is, people newly acquiring a disease) developed during a specified period of time
              in the population of interest, for example, 1000 cases per year in Ethiopia."),
      
      tags$h3("Incidence Rate"),
      tags$p("Incidence divided by the total number of people in the population of interest, for example, 10 per 100,000 people per year in Ethiopia."),
      
      tags$h3("Mortality"),
      tags$p("The number of new deaths that occur during the specified period of time in the population of interest."),
      
      tags$h3("Disability-Adjusted Life Year (DALY)"),
      tags$p("The addition of Years Lost due to Disability (YLD) and Years of Life Lost (YLL). One DALY can be thought of as one lost year of healthy life."),
      
      width = 11, solidHeader = TRUE
    ),
    
   
  
   
   
   box(
     tags$h3("Link to incidence/rate definition"),
     tags$a(href = "https://www.cdc.gov/csels/dsepd/ss1978/lesson3/section2.html", "https://www.cdc.gov/csels/dsepd/ss1978/lesson3/section2.html"),
     
     tags$h3("Link to mortality/rate definition"),
     tags$a(href = "https://www.cdc.gov/csels/dsepd/ss1978/lesson3/section3.html", "https://www.cdc.gov/csels/dsepd/ss1978/lesson3/section3.html"),
     
     tags$h3("Link to YLL, YLD and DALY definitions"),
     tags$a(href = "https://www.who.int/data/gho/indicator-metadata-registry/imr-details/158 ", "https://www.who.int/data/gho/indicator-metadata-registry/imr-details/158"),
     
     width = 11, solidHeader = TRUE)
   )
  
  
}



defintionTabServer <- function(id)
{
  moduleServer(id, function(input, output, session)
  {
    output$definitionText <- renderText("Definitions") 
    
  })
}