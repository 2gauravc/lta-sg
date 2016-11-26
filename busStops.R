

library(httr)
library(knitr)
library(leaflet)
library(dplyr)

to_skip = 0
max_stops <- 2000
ans <- NULL
acc_key <- "7HYNDi9gRQ6yVg/S42ErLw=="
uuid <- '1bfc9ce5-3e1d-473b-8b57-4bac103231b2'

repeat { 
baseurl <- sprintf("http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=%s", to_skip)
#baseurl <- "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$all=TRUE"
req <- GET(baseurl, add_headers(AccountKey = acc_key, UniqueUserID = uuid))
ans_th <-  content(req)
ans <- rbind(ans, ans_th[[2]])
if (to_skip > max_stops) break
to_skip <- to_skip + 50

}

num_stops <- length(ans)
stop_name <- vector(mode="character", length = num_stops)
stop_lat <- vector(mode="character", length = num_stops)
stop_lon <- vector(mode="character", length = num_stops)

for (i in 1:num_stops ){
  
  stop_name[i] <- ans[[i]]$Description
  stop_lat[i] <- ans[[i]]$Latitude
  stop_lon[i] <- ans[[i]]$Longitude
  
}

bus_stops <- data.frame(stop_name = stop_name, stop_lat = stop_lat, stop_lon = stop_lon)

bus_stops$stop_lat <- as.numeric(as.character(bus_stops$stop_lat))  
bus_stops$stop_lon <- as.numeric(as.character(bus_stops$stop_lon))  

map <- Leaflet$new()
map$setView(c(median(bus_stops$stop_lat), median(bus_stops$stop_lon)), zoom = 10)
#map$tileLayer(provider = 'Stamen.Watercolor')

for (i in 1: num_stops){
  map$marker(c(bus_stops$stop_lat[i], bus_stops$stop_lon[i]), bindPopup = bus_stops$stop_name[i])
}

map




