allHazardDiseaseList <- list("Diarrheal Disease" = c("Norovirus spp.","Campylobacter spp.","Enteropathogenic E. coli","Enterotoxigenic E. coli", "Shiga toxin-producing E. coli","Cryptosporidium spp.", "Entamoeba histolytica", "Giardia spp.","Rotavirus","Vibrio cholerae","Shigella spp.", "Non-typhodial Salmonella enterica"),
                              "Invasive Infectious Disease Agents" = c("Hepatitis A virus","Brucella spp.","Listeria monocytogenes", "Mycobacterium bovis","Salmonella Paratyphi","Salmonella Typhi","Bacillus anthracis","Toxoplasma gondii","Clostridium botulinum","Staphylococcus aureus","Rift Valley Fever"),
                              "Helminths" = c("Echinococcus granulosus","Taenia saginata","Fasciola spp.","Ascaris spp.", "Trichinella spp."),
                              "Chemicals and Toxins" = c("Aflatoxin M1","Aflatoxin B1","Acrylamide", "Dioxin","Lathyrus sativus"),
                              "Metals" = c("Arsenic","Cadmium", "Mercury", "Lead")
)

FERGDiseaseList <- list("Diarrheal Disease" = c("Norovirus spp.","Campylobacter spp.","Enteropathogenic E. coli","Enterotoxigenic E. coli", "Shiga toxin-producing E. coli","Cryptosporidium spp.", "Entamoeba histolytica", "Giardia spp.","Vibrio cholerae", "Shigella spp.", "Non-typhodial Salmonella enterica"),
                             "Invasive Infectious Disease Agents" = c("Hepatitis A virus","Brucella spp.","Listeria monocytogenes", "Mycobacterium bovis","Salmonella Paratyphi","Salmonella Typhi","Bacillis Anthrax","Toxoplasma gondii"),
                             "Helminths" = c("Echinococcus granulosus","Taenia Saginata","Fasciola spp.","Ascaris spp.", "Trichinella spp."),
                             "Chemicals and Toxins" = c("Aflatoxin B1", "Dioxin","Lathyrus Sativus"),
                             "Metals" = c("Arsenic","Cadmium", "Mercury", "Lead")
)




dashboardUI <- function()
{
  # FERGVarList <- list("Incidence" = "Incidence", "Incidence per person year" = "Incidence_per_person_year", "Mortality" = "Mortality","Mortality per person year" = "Mortality_per_person_year",
  #                           "Case fatality ratio" ="Case_fatality_ratio","DALYs" = "DALYs", "DALYs per person year" = "DALYs_per_person_year","DALYs per 1000 cases" ="DALYs_per_1000_cases","YLL"="YLL","YLL per person year" ="YLL_per_person_year",
  #                           "YLD"="YLD","YLD per person year"= "YLD_per_person_year")

  FERGVarList <- list("DALY Rate per 100,000" =  "DALY_Rate_100K", "DALYs" = "DALYs", "Case Fatality Ratio" ="Case_fatality_ratio", "Incidence" = "Incidence", "Mortality" = "Mortality",
                      "DALYs per 1000 cases" ="DALYs_per_1000_Cases","YLL"="YLL","YLL Rate per 100,000" ="YLL_Rate_100K",
                      "YLD"="YLD","YLD Rate per 100,000"= "YLD_Rate_100K", "Incidence Rate per 100,000" = "Incidence_Rate_100K", "Mortality Rate per 100,000" = "Mortality_Rate_100K")

   
  #Old list contains DALYs per case, but we dont have data assosiated with it
  #choiceListAllHazard <- list("Incidence" = "Incidence", "Mortality" = "Mortality", "DALYs" = "DALYs", "DALYs Per Case" = "DALYs_per_case")
  
  choiceListAllHazard <- list("DALY_Rate_100K","DALY_per_case","Case_fatality_ratio", "Incidence" = "Incidence", "Mortality" = "Mortality", "DALYs" = "DALYs", "Incidence_Rate_100K", "Mortality_Rate_100K")
  
  scatterDataList <- list("Total Population w/ Non-FERG" = "totalPopAndNewHaz","Under 5 years of age"="underFive", "Over five years of age"="overFive")
  

  
  sideBar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "homepageTab"),
      menuItem("Definitions", tabName = "definitionTab"),
      menuItem("All Hazards", tabName = "allHazardTab"),
      
      menuItem("FERG Hazards", tabName = "FERGHazards"),
      #menuItem("Custom Hazards", tabName = "CustomHazards"),
      menuItem("Scatter Plot", tabName ="Scatter"),
      menuItem("Weighted Scatter Plot", tabName ="WeightedScatter"),
      menuItem("Add New Hazards", tabName = "Simulation")
      #Hide these tabs for now
      #menuItem("All Hazards Test", tabName = "allHazardTabTest")
      #menuItem("User Manual", tabName = "UserManual")
    )
  )
  
  body <- dashboardBody(
    tabItems(
      tabItem(tabName = "definitionTab",
              definitionTabUI("defintionTab")
      ),
      tabItem(tabName = "allHazardTab",
              allHazardTabUI("allHazardTab",choiceListAllHazard,allHazardDiseaseList)
      ),
      
      tabItem(tabName = "FERGHazards",
              FERGHazardUI("FERGHazardTab",FERGVarList,FERGDiseaseList)
      ),
      
      # tabItem(tabName = "CustomHazards",
      #         customHazardTabUI("CustomHazardTab")
      # ),
      
      tabItem(tabName = "WeightedScatter",
              weightedScatterplotTabUI("weightedScatterPlotTab",FERGVarList, scatterDataList)
      ),
      tabItem(tabName = "Scatter",
              scatterplotTabUI("scatterPlotTab",FERGVarList, scatterDataList)
      ),
      
      tabItem(tabName = "Simulation",
              SimulationUI("simulationTab")
      ),
      
      #Hidden for now
      #tabItem(tabName = "allHazardTabTest",
      #        allHazardTestUI("allHazardTabTest", choiceListAllHazard,allHazardDiseaseList)
      #),
      #tabItem(tabName = "UserManual",
      #        userManualTabUI("userManual")
      #),
      tabItem(tabName = "homepageTab",
              homepageTabUI("homepage")
      )
      
      
    )
  )
  
  dashboardPage( skin = "blue",
                 dashboardHeader(title = "ETH. Dashboard"),
                 sideBar,
                 body
              )
}


dashboardServer <- function(input,output,session,dataList)
{
  
  function(input,output,session)
  {
    defintionTabServer("definitionTab")
    allHazardTabServer("allHazardTab" , dataList[c("totalPopAndNewHaz")],allHazardDiseaseList)
    FERGHazardServer("FERGHazardTab",dataList[c("totalPop", "underFive", "overFive")],FERGDiseaseList)
    scatterplotTabServer("scatterPlotTab", dataList)
    weightedScatterplotTabServer("weightedScatterPlotTab", dataList)
    SimulationServer("simulationTab")
    #customHazardTabServer("CustomHazardTab")
    #allHazardTestServer("allHazardTabTest", dataList[c("totalPopAndNewHaz")],allHazardDiseaseList)
    #userManualTabServer("userManual")
    homepageTabServer("homepage")
  }
}

