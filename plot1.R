## Getting data
# Download archive with data set
filename <- "Electric_power_consumption.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists(filename)) {
    download.file(fileUrl,
                  destfile = filename,
                  method = "curl")
}
# Unzip archive to get access to data set
if (!file.exists("household_power_consumption.txt")) {
    unzip(filename)
}

## Upload packages
library(data.table)
library(lubridate)

## Getting required data
# Upload data set to data.table
dt <- fread("./household_power_consumption.txt", 
            sep = ";", 
            na.strings = "?", 
            header = TRUE)
# Add new column with date and time
dt$datetime <- as.POSIXct(paste(dt$Date, 
                                dt$Time), 
                          format = "%d/%m/%Y %H:%M:%S")
# Delete unnecessary columns
dt$Date <- NULL
dt$Time <- NULL
# Change the order of columns (datetime is the first one now)
setcolorder(dt, c(8, 1,2,3,4,5,6,7))
# Extract only requred rows (01-02.02.2007)
dt <- dt[(year(dt$datetime) == 2007 & 
              month(dt$datetime) == 2 & 
              day(dt$datetime) <= 2)]

## Save file as png image
# Initiate a graphics file device png
png(filename = "plot1.png")
# Plot histogram
hist(dt$Global_active_power,
     col = "red",
     xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power")
# Close the graphics device
dev.off()