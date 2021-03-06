###########################################
# Exploratory Data Analysis [Project 01]  #
# by Firas Sadiyah                        #
###########################################

########### Getting the data ##############

# download data file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./data/household_power_consumption.zip",method="curl")

# unzip data file
unzip(zipfile="./data/household_power_consumption.zip",exdir="./data")

# read the name of the unzipped data file
# full.names = TRUE will return the full (relative) path
dataFilesPath <- file.path("./data")
dataFile<-list.files(dataFilesPath, recursive=TRUE, pattern = "\\.txt$", full.names = TRUE)

# read the specific dates from the data file
# skip=grep # will skip all lines until it matches the grep 
# nrows     # will read a specific number of rows only 'after' grep condition
energyData <- read.table(dataFile, skip=grep('^31/1/2007;23:59:00', readLines(dataFile)), nrows=2880, header = FALSE, sep = ';', na.strings = '?' )

# add descriptive names to variables in data
names(energyData) <- c('Date', 'Time', 'Global_active_power', 'Global_reactive_power', 'Voltage', 'Global_intensity', 'Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')

# merge Date and Time variables to create a datetime variable
energyData$datetime <- as.POSIXct(paste(energyData$Date, energyData$Time), format="%d/%m/%Y %H:%M:%S")

##### Plot3 ####
# plot a line plot showing the three different sub metering (1, 2, and 3) over the period from the dates 2007-02-01 and 2007-02-02
with(energyData, plot(datetime, Sub_metering_1, xlab = '', ylab = 'Energy sub metering', type ="n"))
lines(energyData$datetime, energyData$Sub_metering_1, xlab = '', ylab = 'Energy sub metering', type = 'l', col = 'black' )
lines(energyData$datetime, energyData$Sub_metering_2, xlab = '', ylab = 'Energy sub metering', type = 'l', col = 'red' )
lines(energyData$datetime, energyData$Sub_metering_3, xlab = '', ylab = 'Energy sub metering', type = 'l', col = 'blue' )
legend('topright', col = c('black', 'red', 'blue'), lwd=c(1,1,1), legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'))

# open a png() device to save the plot to a PNG file with a width of 480 pixels and a height of 480 pixels
dev.copy(png, "plot3.png", width = 480, height = 480, units = 'px')

# close the device
dev.off()