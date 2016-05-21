#Coursera Data Science Specialiation
#Data Product
#Alternative Fuel Stations
#John James
#May 13, 2016

library(shinydashboard)
library(leaflet)

header <- dashboardHeader(
  title = "Alternative Fuel Station Finder",
  titleWidth = 450
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
               textInput(inputId = "location", label = "Location:", value = "ZIP or address, city, state"),
               checkboxInput("currentLocation", label = "Use Current Location", value = TRUE),
               sliderInput("radius", label = "Radius:", min = 0, max = 100, value = 5),
               p(
                 class = "text-muted",
                 paste("Limit results to stations within a designated radius (in miles)"))

           ),
           box(width = NULL, status = "warning",
               selectInput("fuelType", label = "Fuel Type:", choices = fuelTypeSelect, selected = "ALL"),
               selectInput("paymentType", label = "Payment Type:", choices = paymentTypeSelect, selected = "Choose"),
               p(
                 class = "text-muted",
                 paste("Note: Location details are subject to change. We recommend calling the stations to verify location, 
                        hours of operation, and access.")
                )
          )
      )
  ),
  
  fluidRow(
    box(title = "Alternative Fuel Station List", width = 9, status = "primary", solidHeader = TRUE,
        DT::dataTableOutput("table")
    )
  )
)


dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)