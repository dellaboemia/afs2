#Coursera Data Science Specialiation
#Data Product
#Alternative Fuel Stations
#John James
#May 13, 2016

library(shinydashboard)
library(leaflet)

header <- dashboardHeader(
  title = "Alternative Fuel Station Finder"
)

body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE, status = "warning",
               leafletOutput("m", height = 500)
           )
    ),
    column(width = 3,
           box(width = NULL, status = "warning",
               textInput("location", label = h3("Location"), value = "Enter state, city and/or zip..."),
               checkboxInput("currentLocation", label = "Use Current Location", value = TRUE)
               ),
           box(width = NULL, status = "warning",
               h3("Fuel Types"),
               checkboxInput("BD", label = "Biodiesel (B20 and above)", value = TRUE),
               checkboxInput("CNG", label = "Compressed Natural Gas", value = TRUE),
               checkboxInput("E85", label = "Ethanol (E85)", value = TRUE),
               checkboxInput("ELEC", label = "Electric", value = TRUE),
               checkboxInput("HY", label = "Hydrogen", value = TRUE),
               checkboxInput("LNG", label = "Liquefied Natural Gas", value = TRUE),
               checkboxInput("LPG", label = "Liquefied Petroleum Gas (Propane)", value = TRUE)               
               ),
           actionButton("refresh", "Render Map")
  )
  # fluidRow(
  #   box(width = 9, status = "warning", 
  #       tabPanel("Data Explorer", DT::dataTableOutput("table"))
  #   )
  #)
 )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)