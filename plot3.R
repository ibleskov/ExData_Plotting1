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
png(filename = "plot3.png")
# Get required names for the legend
n <- names(dt)[grep("Sub*", names(dt))]
# Set colors for each data set
clrs <- c("black", "red", "blue")
# Create a plot area without image
plot(dt$datetime, dt$Sub_metering_1, # Since Sub_metering_1 has the highest 
                                     # values among Sub_metering_*
     type = "n", 
     xlab = "", 
     ylab = "Energy sub metering")
# Draw lines
for (i in 1:3) {
    lines(dt$datetime, dt[[n[i]]],
          col = clrs[i]) }
# Add legend
legend("topright", 
       col = clrs, 
       legend = n, 
       lwd = c(1,1,1))
# Close the graphics device
dev.off()