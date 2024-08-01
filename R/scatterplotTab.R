scatterplotTabUI <- function(id,dependentVarList, dataChoiceList)
{
  
  fluidRow(
    box(
      shinyWidgets::dropdown(
        shinyWidgets::pickerInput(NS(id,"selectData"),"Select Dataset", choices = dataChoiceList, selected = dataChoiceList[1]),
        shinyWidgets::pickerInput(NS(id,"xVar"),"Select X Var.", choices = dependentVarList, selected = dependentVarList[1]),
        shinyWidgets::pickerInput(NS(id,"yVar"),"Select Y Var.", choices = dependentVarList, selected = dependentVarList[1]),
        
        tags$style(type="text/css",
                   ".shiny-output-error { visibility: hidden; }",
                   ".shiny-output-error:before { visibility: hidden; }"
        ),
        
        circle = FALSE, 
        status = "danger",
        label = "Graph Options",
        width = "250px"
        
      ),
      
      plotOutput(NS(id, "scatterplot"), height = 900), 
      
      width = 12, 
      height = 1000
    ),
    
    
  )
  
}


scatterplotTabServer <- function(id, data)
{

  moduleServer(id, function(input, output, session)
  {
      dataset <- reactive(data[[input$selectData]])
      choiceListAllHazard2 <- list("DALY_Rate_100K","DALY_per_case","Case_fatality_ratio" ,"Incidence" = "Incidence", "Mortality" = "Mortality", "DALYs" = "DALYs", "Incidence_Rate_100K", "Mortality_Rate_100K")
    
      observeEvent(input$selectData, 
      {
          if(input$selectData == "totalPopAndNewHaz")
          {
              shinyWidgets::updatePickerInput(session, inputId = "xVar", choices = choiceListAllHazard2)
              shinyWidgets::updatePickerInput(session, inputId = "yVar", choices = choiceListAllHazard2)
          }
    
      })
      
      medianList <- reactive({   
          dataset() %>% dplyr::group_by(hazard, haz_group) %>%
          dplyr::summarise(xMedian = median(!!rlang::sym(input$xVar), na.rm = T),
                    yMedian = median(!!rlang::sym(input$yVar), na.rm = T))
      
      })
      
      output$scatterplot <- renderPlot(
      {
        
         colors = c( RColorBrewer::brewer.pal(name="Dark2", n = 8),  RColorBrewer::brewer.pal(name="Accent", n = 3))
         
         #colorTest <- c("#003f5c", "#2f4b7c", "#665191", "#a05195", "#d45087", "#f95d6a", "#ff7c43", "#ffa600","#ffa601","#ffa602","#ffa603" )
         #colorTest <- c("#001e4e", "#FD3903", "#802871", "#238181", "#d45087", "#800000", "#ff7c43","#24AB09","#2f4b7c","#f95d6a","#6B8E23" )
         #colorTest <- c("#001e4e", "#2f4b7c", "#802871", "#238181", "#48513D", "#f95d6a", "#ff7c43","#24AB09","#FD3903","#800000","#6B8E23" )
         
         colors <- c("#001e4e", "#1261A0", "#4F97A3", "#311465", "#9866c7", "#d45087", "#043927","#6B8E23","#24AB09","#CC7722","#E3242B" )
        
         ggplot2::ggplot(medianList(), aes(x = xMedian, y = yMedian, color= haz_group)) +  
        
          ggplot2::geom_point(size = 4) +
          ggplot2::scale_x_log10() +
          ggplot2::scale_y_log10() +
          ggplot2::ggtitle(paste("Scatterplot of ", input$yVar, "vs.",input$xVar)) +
          ggplot2::theme_light() +                                                        
          ggplot2::theme(plot.title = ggplot2::element_text(size = 30, face = "bold", hjust = .5),
                legend.title = ggplot2::element_text(size=20, face="bold"), 
                legend.text= ggplot2::element_text(size = 20),
                axis.title = ggplot2::element_text(size = 12) ,
                axis.text.x= ggplot2::element_text(size=14,face="bold"),
                axis.text.y= ggplot2:: element_text(size=14,face="bold")) +
          ggplot2::xlab(input$xVar) +
          ggplot2::ylab(input$yVar) +
          ggplot2::scale_size_area(max_size = 10) +
          ggplot2::labs(color= "Hazard group", size="Scale of weighted variable chosen") + 
          ggrepel::geom_label_repel(aes(label = hazard, fontface = "bold"), size = 4.0, show.legend = F, min.segment.length = ggplot2::unit(.1, "lines")) +
          ggplot2::scale_color_manual(values = colors)
          
          
      })
      
    
  })
  
}