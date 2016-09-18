
library(httr)

baseurl <- "http://datamall2.mytransport.sg/ltaodataservice/BusArrival?BusStopID=11099&SST=True"
acc_key <- "7HYNDi9gRQ6yVg/S42ErLw=="
uuid <- '1bfc9ce5-3e1d-473b-8b57-4bac103231b2'

req <- GET(baseurl, add_headers(AccountKey = acc_key, UniqueUserID = uuid))
ans <- content(req)

