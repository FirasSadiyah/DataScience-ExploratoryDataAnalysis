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

########### Plot 3 #####################
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#  which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#  Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

library(ggplot2)

# Subset NEI to include readings from Baltimore City
baltimore <- subset(NEI, fips == '24510')

# Extract unique elments of variable 'type' in 'baltimore' data frame
types <- unique(baltimore$type)

# Split 'baltimore' data frame based on variable 'type'
bm_types <- split(baltimore, baltimore$type)

# Extract the names of the list 'bm_types'
names(bm_types)

# Summerise (sum) of a variable (list' elements) by a factor (Year)
bm_nonpoints <- aggregate(bm_types[[1]][4], bm_types[[1]][6], sum)
bm_points <- aggregate(bm_types[[4]][4], bm_types[[4]][6], sum)
bm_onroad <- aggregate(bm_types[[3]][4], bm_types[[3]][6], sum)
bm_nonroad <- aggregate(bm_types[[2]][4], bm_types[[2]][6], sum)

# Plot using ggplot2 the changes in Emissions over year for all types
# Since all data frames have the same variable names, I can plot the first data frame
# then add all additional data frames
(ggplot(bm_points, aes(year, Emissions)) 
  + geom_line(aes(color='POINTS')) 
  + geom_line(data = bm_nonpoints, aes(color='NON-POINTS'))
  + geom_line(data = bm_onroad, aes(color='ON-ROAD'))
  + geom_line(data = bm_nonroad, aes(color='NON-ROAD'))
  + labs(y = 'Emissions (measured in tons of PM2.5)') # add y label
  + labs(color='PM2.5')
  + labs(x = 'Year')
)

# open a png() device to save the plot to a PNG file with a width of 480 pixels 
#  and a height of 480 pixels
dev.copy(png, "Plot3.png", width = 480, height = 480, units = 'px')

# close the device
dev.off()
