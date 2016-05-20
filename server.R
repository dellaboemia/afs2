#Coursera Data Science Specialiation
#Data Product
#Alternative Fuel Stations
#John James
#May 13, 2016

# Libraries
library(RCurl)
library(curl)
library(datasets)
library(dplyr)
library(jsonlite)
library(leaflet)
library(rjson)
library(shiny)
library(zipcode)

#Global Variables
## Base URL
afsBaseURL <- "https://developer.nrel.gov/api/alt-fuel-stations/v1/nearest.json?api_key=zhiWRDbKkuL7G0Iwm2IifkfxfBeqcJ46GaHQnv5E"

##User's location based upon their IP address
ipInfo  <- getURL("ipinfo.io/loc")
loc     <- gsub("[\n]","",ipInfo)

##User's Current longitude and latitude 
homeLat  <- strsplit(loc, ",")[[1]][1]
homeLong <- strsplit(loc, ",")[[1]][2]

##User's home URL for nearest stations
homeURL <- paste(afsBaseURL,"&latitude=",homeLat,"&longitude=",homeLong, sep = "")

## Fuel Types
fuelTypes <- c("BD", "CNG", "E85", "ELEC", "HY", "LNG", "LPG")

#Main server processing
shinyServer(function(input, output, session) {
  
  formatSearchURL <- reactive({
    
    # Form fuel type query string option
    if (input$BD == TRUE) { fuelTypeBD <- "&fuel_type=BD" } else {fuelTypeBD <- ""}
    if (input$CNG == TRUE) { fuelTypeCNG <- "&fuel_type=CNG" } else {fuelTypeCNG <- ""}
    if (input$E85 == TRUE) { fuelTypeE85 <- "&fuel_type=E85" } else {fuelTypeE85 <- ""}
    if (input$ELEC == TRUE) { fuelTypeELEC <- "&fuel_type=ELEC" } else {fuelTypeELEC <- ""}
    if (input$HY == TRUE) { fuelTypeHY <- "&fuel_type=HY" } else {fuelTypeHY <- ""}
    if (input$LNG == TRUE) { fuelTypeLNG <- "&fuel_type=LNG" } else {fuelTypeLNG <- ""}
    if (input$LPG == TRUE) { fuelTypeLPG <- "&fuel_type=LPG" } else {fuelTypeLPG <- ""}
    
    fuelTypeOption <- paste(fuelTypeBD, fuelTypeCNG, fuelTypeE85, fuelTypeELEC,  
                              fuelTypeHY, fuelTypeLNG, fuelTypeLPG, sep = "")
    
    
    # Format search string
    if (input$refresh[1] == 0 | input$currentLocation == TRUE) {
      #First time or use current location is selected
      paste(homeURL, fuelTypeOption, sep = "")
    } else {
      #Not first time, format location parameter
      location <- gsub(" ","+",input$location)
      paste(afsBaseURL, "&location=", location, fuelTypeOption, sep = "")
    }
    
  })

  
  formatStations <- function(afs){
    name            <- unlist(sapply(afs$fuel_stations, function(x) x$station_name))
    distance        <- unlist(sapply(afs$fuel_stations, function(x) x$distance))
    fuelType        <- unlist(sapply(afs$fuel_stations, function(x) x$fuel_type_code))
    address         <- unlist(sapply(afs$fuel_stations, function(x) x$street_address))
    city            <- unlist(sapply(afs$fuel_stations, function(x) x$city))
    state           <- unlist(sapply(afs$fuel_stations, function(x) x$state))
    zip             <- unlist(sapply(afs$fuel_stations, function(x) x$zip))
    phone           <- unlist(sapply(afs$fuel_stations, function(x) x$station_phone))
    hours           <- unlist(sapply(afs$fuel_stations, function(x) x$access_days_time))
    latitude        <- unlist(sapply(afs$fuel_stations, function(x) x$latitude))
    longitude       <- unlist(sapply(afs$fuel_stations, function(x) x$longitude))
    stations        <- data.frame(name, distance, fuelType, address, city, state, zip, phone, hours, latitude, longitude)
  }
  # Get alternative fuel stations based upon user's input or location
  output$m <- renderLeaflet({
    
    # Retrieve searchURL
    searchURL <- formatSearchURL()
    print(searchURL)

    # Get alternative fuel stations 
    afsJSON <- getURL(searchURL)
    afs     <- fromJSON(afsJSON)
    
    # Format station information
    stations <- formatStations(afs)
    print(stations)

    #Format colors for legend
    cols <- rainbow(length(levels(stations$fuelType)), alpha = NULL)
    stations$colors <- cols[unclass(stations$fuelType)]
 
    #Format map
    if (is.null(stations$latitude)) {
      leaflet(stations)  %>%
        addTiles() %>%
        setView(lng = afs$longitude, lat = afs$latitude, zoom = 15)
    } else {
      leaflet(stations)  %>%
        addTiles() %>%
        setView(lng = afs$longitude, lat = afs$latitude, zoom = 15) %>%
        fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude)) %>%
        addCircleMarkers(data = stations, lat =  ~latitude, lng = ~longitude, popup = ~name, color = ~colors) %>%
        addLegend(position = "bottomright", labels = unique(stations$fuelType), colors = cols)
    }

  })

  # output$table <- DT::renderDataTable({
  #   if (nrow(subset(afs, ZIP == input$zip)) !=0) {
  #     x <- subset(afs, ZIP == input$zip)
  #   } else {
  #     x <- subset(afs, City == input$city & State.Name == input$state)
  #   }
  #   DT::datatable(x[vars],options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  # })
})