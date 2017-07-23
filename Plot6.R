########### Getting the data ###########

# download the data file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl,destfile="./data/NEI_data.zip",method="curl")

# unzip data file
unzip(zipfile="./data/NEI_data.zip",exdir="./data")

# list all files in the unzipped data folder
dataFilesPath <- file.path("./data")
dataFiles<-list.files(dataFilesPath, recursive=TRUE, full.names = TRUE)
dataFiles

########### Reading the data ###########
NEI <- readRDS(dataFiles[3])
SCC <- readRDS(dataFiles[2])

########### Plot 6 #####################
# Compare emissions from motor vehicle sources in Baltimore City with 
#  emissions from motor vehicle sources in Los Angeles County, California 
#  (fips == "06037"). Which city has seen greater changes over time in motor 
#  vehicle emissions?

# search for 'Motor Vehicle' (type = 'Onroad') in Baltimore
mv.bm.pm25 <- subset(NEI, type == 'ON-ROAD' & fips == '24510')

# Summerise (sum) of a variable (Emissions) by a factor (Year)
mv.bm.pm25.year <- aggregate(mv.bm.pm25$Emissions, list(mv.bm.pm25$year), sum)

# Name the variables in fcc.pm25.year
names(mv.bm.pm25.year) <- c('Year', 'Emissions')

# Plot fcc.pm25.year
plot(mv.bm.pm25.year)

# search for 'Motor Vehicle' (type = 'Onroad') in Los Angeles
mv.la.pm25 <- subset(NEI, type == 'ON-ROAD' & fips == '06037')

# Summerise (sum) of a variable (Emissions) by a factor (Year)
mv.la.pm25.year <- aggregate(mv.la.pm25$Emissions, list(mv.la.pm25$year), sum)

# Name the variables in fcc.pm25.year
names(mv.la.pm25.year) <- c('Year', 'Emissions')

# Plot fcc.pm25.year
plot(mv.la.pm25.year)

# Add a county column to both data frames
mv.bm.pm25.year$County = 'Baltimore'
mv.la.pm25.year$County = 'Los Angeles'

# Merge both data frames in one
mv.pm25.year = rbind(mv.bm.pm25.year, mv.la.pm25.year)
# Convert year to character to avoid trailing zeros
mv.pm25.year$Year <- as.character(mv.pm25.year$Year)

# Plot using ggplot2 the changes in Emissions over year for all types comparing 
# Baltimore city with Los Angeles city

# ymax = max(Emissions)*1.1) increase y axis to accomodate for values above bars
# + facet_grid(County ~ .) # seperate the plot by County
# position = position_dodge(width = 1) # to put values over their corresponding bars
# vjust = -0.25 # level the values higher above their corresponding bars
# aes(color = County) # match the color of the values with the colors of the bars
(ggplot(mv.pm25.year, aes(Year, Emissions, fill = County, label = sprintf('%2.0f', Emissions), ymax = max(Emissions)*1.1))
    + geom_bar(position = 'dodge', stat = "identity")
    + geom_text(position = position_dodge(width = 1), vjust = -0.25) 
    + labs(y = 'Emissions (measured in tons of PM2.5)') # add y label
    + labs(title = "Emissions from motor vehicle sources") # add a title
    + theme(plot.title = element_text(hjust = 0.5)) # center the title
)

# open a png() device to save the plot to a PNG file with a width of 480 pixels 
#  and a height of 480 pixels
dev.copy(png, "Plot6.png", width = 480, height = 480, units = 'px')

# close the device
dev.off()