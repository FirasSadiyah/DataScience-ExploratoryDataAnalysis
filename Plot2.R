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

########### Plot 2 #####################
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
#  (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.

# Subset NEI to include readings from Baltimore City
baltimore <- subset(NEI, fips == '24510')

# Summerise (sum) of a variable (Emissions) by a factor (Year)
baltimore25 <- aggregate(baltimore$Emissions, list(baltimore$year), sum)

# Name the variables in baltimore25
names(baltimore25) <- c('Year', 'Emissions')

# Plot baltimore25
barplot2 <- barplot(baltimore25$Emissions,
                    names.arg = baltimore25$Year,
                    ylim = c(0, max(baltimore25$Emissions)*1.1), # set y axis length > Emissions
                    main='Total PM2.5 emissions in Baltimore City', # add title
                    ylab='Emissions (measured in tons of PM2.5)', # add y label
                    xlab='Year') # add x label
# put numbers above bars
text(x=barplot2, y=baltimore25$Emissions, labels=round(baltimore25$Emissions,0), pos=3, xpd=NA)

# open a png() device to save the plot to a PNG file with a width of 480 pixels 
#  and a height of 480 pixels
dev.copy(png, "Plot2.png", width = 480, height = 480, units = 'px')

# close the device
dev.off()
