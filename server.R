#Coursera Data Science Specialiation
#Data Product
#Alternative Fuel Stations
#John James
#May 13, 2016

#Server.r
shinyServer(function(input, output, session) {

  #Format station information into stations data frame in global environment
  formatStations <- function(afs) {
    #Extract station fields replacing null values with NA
    id  	    <-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$id)) {return(NA)} else {return (x$id)}}))
    name	    <-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$station_name)) {return(NA)} else {return (x$station_name)}}))
    distance	<-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$distance)) {return(NA)} else {return (x$distance)}}))
    fuelType	<-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$fuel_type_code)) {return(NA)} else {return (x$fuel_type_code)}}))
    address	  <-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$street_address)) {return(NA)} else {return (x$street_address)}}))
    city	    <-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$city)) {return(NA)} else {return (x$city)}}))
    state	    <-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$state)) {return(NA)} else {return (x$state)}}))
    zip	      <-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$zip)) {return(NA)} else {return (x$zip)}}))
    phone	    <-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$station_phone)) {return(NA)} else {return (x$station_phone)}}))
    hours	    <-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$access_days_time)) {return(NA)} else {return (x$access_days_time)}}))
    latitude	<-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$latitude)) {return(NA)} else {return (x$latitude)}}))
    longitude	<-  unlist(sapply(afs$fuel_stations, function(x) { if (is.null(x$longitude)) {return(NA)} else {return (x$longitude)}}))
    
    stations  <<- data.frame(id, name, distance, fuelType, address, city, state, zip, phone, hours, latitude, longitude)
  }

  
  
  #Format search string for National Energy Laboratory API
  formatSearchURL <- reactive ({
    
    #Set location parameter to that indicated by the user
    if (input$currentLocation == TRUE) {
      locationParameter <- paste("&latitude=",homeLat,"&longitude=",homeLong, sep = "")
    } else {
      locationParameter <- paste("&location=",gsub(" ","+",input$location), sep = "")
    }    
    
    #Set radius parameter to that indicated by the user
    radiusParameter <- paste("&radius=", input$radius, sep = "")
    
    #Set fuel type option to that indicated by the user
    if (input$fuelType == "ALL") {
      fuelTypeParameter <- ""
    } else {
      fuelTypeParameter <- paste("&fuel_type=", input$fuelType, sep = "")
    }
    
    #Set payment type option to that indicated by user
    if (input$paymentType == "Choose") {
      paymentTypeParameter <- ""
    } else {
      paymentTypeParameter <- paste("&cards_accepted=", input$paymentType, sep = "")
    }
    
    #Concatenate and form search parameter
    paste(afsBaseURL, locationParameter, radiusParameter, fuelTypeParameter, paymentTypeParameter, sep = "")
  })
  

  #Reads station data from National Energy Laboratory API
  getStationData <- function() {
    afsJSON <- getURL(formatSearchURL())
    afs <- fromJSON(afsJSON)
  }


  #Get center latitude and longitude of map display  
  getCenter <- function() {
    afs       <<- getStationData() 
    stations  <<- formatStations(afs)

    if (nrow(stations) == 0) {
      center  <- data.frame(latitude = afs$latitude, longitude = afs$longitude)
    } else {
      center  <- data.frame(latitude = mean(stations$latitude), longitude = mean(stations$longitude))
    }
  }
  
  #Render Interactive Map
  output$m <- renderLeaflet({
    
    #Get map Center 
    center <- getCenter()

    #Format colors for legend
    cols <- rainbow(length(levels(stations$fuelType)), alpha = NULL)
    stations$colors <- cols[unclass(stations$fuelType)]
    
    #If no stations, present map centered as per user request
    if (nrow(stations) == 0) {
      leaflet(stations)  %>%
        addTiles() %>%
        setView(lng = center$longitude, lat = center$latitude, zoom = 15)
    
    #If there is a single station, center on the single station   
    } else if (nrow(stations) == 1){
      leaflet(stations)  %>%
        addTiles() %>%
        setView(lng = stations$longitude, lat = stations$latitude, zoom = 15) %>%
        addCircleMarkers(lat =  ~latitude, lng = ~longitude, popup = ~name, color = ~colors) %>% 
        addLegend(position = "bottomright", labels = unique(stations$fuelType), colors = cols)
    
    #If there are multiple stations, center on the mean location    
    } else {
      leaflet(stations)  %>%
        addTiles() %>%
        setView(lng = center$longitude, lat = center$latitude, zoom = 15) %>%
        fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude)) %>%
        addCircleMarkers(lat =  ~latitude, lng = ~longitude, popup = ~name, color = ~colors) %>% 
        addLegend(position = "bottomright", labels = unique(stations$fuelType), colors = cols)
    }
  })

  output$table <- DT::renderDataTable({
   afs       <<- getStationData() 
   stations  <<- formatStations(afs)
   if (nrow(stations) != 0) {
      DT::datatable(stations[c(1:10)], options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
    }
  })
})