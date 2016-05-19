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
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("m", height = 500)
           )
    ),
    column(width = 3,
           box(width = NULL, status = "warning",
               p(
                 class = "text-muted",
                 paste("Please enter either the state and city, or enter the",
                       "zip code below.  Note: if the zip code is entered, state",
                       "and city are ignored."
                 )
               ),               
               htmlOutput("stateUi"),
               htmlOutput("cityUi"),
               htmlOutput("zipUi"),
               actionButton("refresh", "Render Map")
           )
    )
  ),
  fluidRow(
    box(width = 9, status = "warning", 
        tabPanel("Data Explorer", DT::dataTableOutput("table"))
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)