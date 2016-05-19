#Coursera Data Science Specialiation
#Data Product
#Alternative Fuel Stations
#John James
#May 13, 2016
# Libraries
library(RCurl)
library(datasets)
library(dplyr)
library(ggplot2)
library(jsonlite)
library(leaflet)
library(shiny)
library(zipcode)

# Zipcode, state, city data
data("zipcode")

# Standardize Column names for zipcode file
colnames(zipcode) <- c("Zip", "City", "State", "Latitude", "Longitude")

# Create States data set with abbreviation and name
states <- data.frame(state.abb, state.name)
colnames(states) <- c("State", "State.Name")

# Merge zipcode and states data frame
zipcode <- merge(zipcode, states)

# Sort zipcode by state and city
zipcode <- arrange(zipcode, State, City)

# Download alternative fuel station data
apsUrl <- "https://api.data.gov/nrel/alt-fuel-stations/v1.csv?api_key=zhiWRDbKkuL7G0Iwm2IifkfxfBeqcJ46GaHQnv5E&format=csv"

# Download alternative fuel data for current day.
today <- Sys.Date()
mDate <- as.Date(file.info("./data/afs.csv")$mtime)
if ((!file.exists("./data/afs.csv")) | (mDate != today)){
  download.file(apsUrl, destfile = "./data/afs.csv", method = "libcurl")
}

# Read alternative fuel station data
afs <- read.csv("./data/afs.csv", na.strings = "")

# Add state name to AFS
afs <- merge(afs, states)

# Variables to display in data table
vars <- c("Fuel.Type.Code", "Station.Name", "Street.Address","City","State","ZIP","Station.Phone" ,"EV.Connector.Types")

# Initiate fuel types for Pulldown
fuel_types <- c("BD","CNG","E85","ELEC","HY","LNG","LPG")