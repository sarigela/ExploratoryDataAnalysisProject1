########################## Plot4.R ##########################

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



########################## Creating Multiple Plots ##########################


### Open PNG device; create 'plot4.png' in working directory 
png(filename = "plot4.png", width = 480, height = 480, units = "px")

### Initializing the plotting area for multiple polts
par(mfrow = c(2,2))

with (cleandataset, {
  ### Plot 1
  ## Creating the line plot for Dat Time vs Global active power.
  plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
  
  
  ### Plot 2  
  ## Plotting Date Time Vs Voltage
  plot(DateTime, Voltage, xlab = "datetime", ylab ="Voltage", type = "l")
  
  
  ### Plot 3 -  Creating the Plot for Date Time vs Energey sub metering
  ## Initializing the plot with required labelling
  plot(DateTime, Sub_metering_1, xlab = "", ylab = "Energy sub metering", type ="n")
  
  ## Add 'Sub_metering_1" data
  lines(DateTime, Sub_metering_1)
  
  ## Add 'Sub_metering_2" data
  lines(DateTime, Sub_metering_2, col = "red")
  
  ## Add 'Sub_metering_1" data
  lines(DateTime, Sub_metering_3, col = "blue")
  
  ## Create Legend
  legend("topright", lwd = 1, col = c("black", "red", "blue"), bty = "n",
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  
  
  ### Plot 4
  ## Plotting Date Time Vs Global reactive power
  plot(DateTime, Global_reactive_power, xlab ="datetime", type = "l") 
})

dev.off()    ## Close the png file device