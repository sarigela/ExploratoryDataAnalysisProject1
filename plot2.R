########################## Plot2.R ##########################

## Clean local environment variables
rm(list = ls())

########################## Get Data ##########################

## verify data directory exits. If not create one.
if (!file.exists("data")) { dir.create("data")}

## Download data from URL if data does not exists already.
dataSourceURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists("data/HouseHoldPowerConsumption.zip") || !file.exists("data/household_power_consumption.txt")){
  download.file (dataSourceURL, destfile ="./data/HouseHoldPowerConsumption.zip", cacheOK = FALSE)
  
  ## Unzip the file to get the data.
  unzip("./data/HouseHoldPowerConsumption.zip", exdir = "./data")  
}


########################## Read data from the dates 2007-02-01 and 2007-02-02 ##########################

## Read the column Headers (Reading just one line will be very quick and gives header information)
colHeaders <- read.table(file("./data/household_power_consumption.txt"), sep = ";", header = TRUE, nrows = 1)

## Just read the data from 2007-02-01 and 2007-02-02.  Data starts from line 66638 and ends at line 69517 for these dates
dataSet <- read.table(file("./data/household_power_consumption.txt"), sep = ";", header = FALSE, col.names = names(colHeaders),
                      skip = 66637, nrows = (69517 - 66637), na.strings = "?", as.is = TRUE)


########################## Cleaning Data ##########################

## Install Lubridate package if not already isntalled.  ## install.packages("lubridate")
library(lubridate)
dataSet$DateTime <- as.POSIXct(dmy_hms(paste(dataSet[,"Date"], dataSet[, "Time"])))

## Creating Clean Data Set.
cleandataset <- cbind(dataSet[, c(10, 3:9)])

########################## Creating the Plot ##########################

## Open PNG device; create 'plot2.png' in working directory 
png(filename = "plot2.png", width = 480, height = 480, units = "px")

### Creating the line plot for Dat Time vs Global active power.
with (cleandataset, plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))

dev.off()    ## Close the png file device


