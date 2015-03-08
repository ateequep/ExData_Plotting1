# Load the packages
library(data.table)
library(dplyr)

# Load the data
data <- fread("household_power_consumption.txt",
              sep=";",
              header=T,
              na.strings="?",
              colClasses=c(rep("character",2), rep("numeric",7))
)

# Converting the columns to proper data types as data table does not override types due to loss of precision
data <- data[,lapply(.SD,as.numeric),by=c('Date','Time')]
data[,Date:= as.Date(Date,"%d/%m/%Y")]

# Subsetting the data for required dates
data_for_plot <- 
        data %>%
        filter(Date >= "2007-02-01" & Date <= "2007-02-02")

data_for_plot[,datetime:= as.POSIXct(paste(Date,Time,sep=" "),format="%Y-%m-%d %H:%M:%S")]

# Open the graphics device
png("plot3.png")
# Plot the required graph
plot(data_for_plot$datetime, data_for_plot$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
points(data_for_plot$datetime, data_for_plot$Sub_metering_2, col="red", type="l")
points(data_for_plot$datetime, data_for_plot$Sub_metering_3, col="blue", type="l")
legend("topright", paste(c("Sub_metering_1","Sub_metering_2", "Sub_metering_3")), col = c("black", "red", "blue"),lwd=1)
# Close the device connection
dev.off()
