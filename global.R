#Coursera Data Science Specialiation
#Data Product
#Alternative Fuel Stations
#John James
#May 13, 2016
# global.R

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

###################################################################################################
#                                     GLOBAL VARIABLES                                            #
###################################################################################################

## Base URL
afsBaseURL <- "https://developer.nrel.gov/api/alt-fuel-stations/v1/nearest.json?api_key=zhiWRDbKkuL7G0Iwm2IifkfxfBeqcJ46GaHQnv5E"

##User's location based upon their IP address
ipInfo  <- getURL("ipinfo.io/loc")
loc     <- gsub("[\n]","",ipInfo)

##User's Current longitude and latitude 
homeLat  <- strsplit(loc, ",")[[1]][1]
homeLong <- strsplit(loc, ",")[[1]][2]

## Fuel Types used for legend
fuelTypes <- c("BD", "CNG", "E85", "ELEC", "HY", "LNG", "LPG")

## Fuel Type Select for dropdown
fuelTypeSelect <- c("All fuel types" = "ALL",
                    "Biodiesel (B20 and above) (BD)" = "BD", 
                    "Compressed Natural Gas (CNG)" = "CNG",
                    "Ethanol (E85)" = "E85",
                    "Electric (ELEC)" = "ELEC", 
                    "Hydrogen (HY)" = "HY", 
                    "Liquefied Natural Gas (LNG)" = "LNG", 
                    "Liquefied Petroleum Gas (Propane) (LPG)" = "LPG")
