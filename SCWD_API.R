library(tidyverse)
library(httr)
library(jsonlite)

options(stringsAsFactors = FALSE)

## Base URL

# Construct url from API documentation (http://alert.valleywater.org/dataAPI/howto.php)

url <- 'http://alert.valleywater.org/dataAPI/retrievedata.php?'
url <- paste(url, 'format=csv', sep="") #format can be tsv, csv, xml, html, json
url <- paste(url, 'bydate=range', 'timeunits=', sep="&") #can be =back for all data(requires timeunits=), or specified range
url <- paste(url, 'sortasc=1', sep="&") # =1 earliest date on top, =0, most recent date on top
url <- paste(url, 'bytype=sensor', sep="&") #category (use cid=) or sensor (use sids[]=)
url <- paste(url, 'rate=1', sep="&") # =1 include rated values, =0 exclude
url <- paste(url, 'precip=0','precipstep=1d', 'eventime=0', sep="&") #precip parameters



#stream stations            
sensors <- c(1445,	1450,	1451,	1456,	1459,	1460,	1463,	1469,	1475,	1477,	1479,	1481,	1484,	1485,	1487, 1489,	1490,	1491,	1492,	1494,	1495,	1496,	1498,	1502, 1523, 1532,	1535,	1539,	1540,	1541,	1542,	1543,	1544,	1545,	1546,	1548,	1549,	1550,	2050,	2054,	2058,	2062)

#discharge stations
sensors <- c(7010,	7020,	7030,	15077,	15085,	15096,	15097,	15101,	15109,	15112) 

#rainfall stations
sensors <- c(1454,	1457,	1461,	1465,	1471,	1500,	1503,	1508,	1509,	1510,	1511,	1512,	1513,	1514,	1515,	1516,	1517,	1518,	1519,	1520,	1521,	1522,	1524,	1526,	1527,	1528,	1529,	1530,	1551,	1868,	1876,	1884,	1889,	1890,	2053,	2057,	2065,	2066,	2067,	2068,	2069,	2070,	2071,	2072,	2073,	2075,	2079,	2080,	2081,	2099,	20001,	20002,	20003,	20004,	20005,	20006,	20007,	20008,	20009)

#1488 not working (not active), 1506, 1525, 1531, 1547, 2056 (do in segments) for stream stations
#1880, 1882, 1884 for rainfall
#1497,	1504,	1506,	1525, 1531

# TO DO: if the request is successful (i.e. status_code=200), then write contents to file

for (i in sensors) {
  
  #### first set of dates, API limits by number of rows
  url_write <- paste(url, 'tstart=2007%2F01%2F01', 'tend=2011%2F12%2F31', sep="&") #start and end dates
  url_write <- paste(url_write, '&', 'sids[]=',i, sep="") #set sensor id using i
  
  #make the API request
  repo <- GET(url = url_write)
  repo_content <- content(repo)
  
  print(paste("writing Sensor ", i, " to file...", sep=""))
  write.table(repo_content, paste("Station", i,"_a", ".csv", sep=""))
  
  #### second set of dates
  url_write <- paste(url, 'tstart=2012%2F01%2F01', 'tend=2017%2F09%2F30', sep="&") #start and end dates
  url_write <- paste(url_write, '&', 'sids[]=',i, sep="") #set sensor id using i
  
  #make the API request
  repo <- GET(url = url_write)
  repo_content <- content(repo)
  
  print(paste("writing Sensor ", i, " to file...", sep=""))
  write.table(repo_content, paste("Station", i, "_b", ".csv", sep=""))
  
}