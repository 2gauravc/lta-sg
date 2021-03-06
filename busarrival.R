
library(httr)
library(knitr)

baseurl <- "http://datamall2.mytransport.sg/ltaodataservice/BusArrival?BusStopID=11099&SST=True"
acc_key <- "7HYNDi9gRQ6yVg/S42ErLw=="
uuid <- '1bfc9ce5-3e1d-473b-8b57-4bac103231b2'

req <- GET(baseurl, add_headers(AccountKey = acc_key, UniqueUserID = uuid))
ans <- content(req)

num_bus <- length(ans[[3]])

serv_no <- vector(mode="character", length = num_bus)
in_serv <- vector(mode="character", length = num_bus)
next_time <- vector(mode="character", length = num_bus)
sub_time <- vector(mode="character", length = num_bus)

for ( i in 1:num_bus){
  serv_no[i] <- ans[[3]][[i]]$ServiceNo
  in_serv[i] <- ans[[3]][[i]]$Status
  next_time[i] <- ans[[3]][[i]]$NextBus$EstimatedArrival
  sub_time[i] <- ans[[3]][[i]]$SubsequentBus$EstimatedArrival
}

time_now = strptime (format(Sys.time(), tz = "Asia/Singapore"), 
                     format = "%Y-%m-%d %H:%M:%S", tz = "Asia/Singapore")
next_time1 <- strptime(next_time, format="%Y-%m-%dT%H:%M:%S", tz = "Asia/Singapore")
time_diff <- round(difftime(next_time1, time_now, units = "mins"), 0)

sub_time1 <- strptime(sub_time, format="%Y-%m-%dT%H:%M:%S", tz = "Asia/Singapore")
time_diff1 <- round(difftime(sub_time1, time_now, units = "mins"),0)


bus_arr <- data.frame(serv_no = serv_no, status = in_serv, next_bus = time_diff, sub_bus = time_diff1)

kable(bus_arr)