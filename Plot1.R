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

########### Plot 1 #####################
# Have total emissions from PM2.5 decreased in the United States 
#  from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission 
#  from all sources for each of the years 1999, 2002, 2005, and 2008.

# Summarise (sum) the variable 'Emissions' by the 'year' factor
PM25 <- aggregate(NEI$Emissions, list(NEI$year), sum)

# Name the variables in PM25
names(PM25) <- c('Year', 'Emissions')

# Plot PM25
barplot1 <- barplot(PM25$Emissions,
                    names.arg = PM25$Year,
                    ylim = c(0, max(PM25$Emissions)*1.1), # set y axis length > Emissions
                    main='Total PM2.5 emissions in the United States', # add title
                    ylab='Emissions (measured in tons of PM2.5)', # add y label
                    xlab='Year') # add x label
# put numbers within bars
text(x=barplot1, y=PM25$Emissions, labels=round(PM25$Emissions,0), pos=1)

# open a png() device to save the plot to a PNG file with a width of 480 pixels 
#  and a height of 480 pixels
dev.copy(png, "Plot1.png", width = 480, height = 480, units = 'px')

# close the device
dev.off()