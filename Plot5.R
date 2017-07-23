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

########### Plot 5 #####################
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# search for 'Motor Vehicle' (type = 'Onroad') in Baltimore
mv.bm.pm25 <- subset(NEI, type == 'ON-ROAD' & fips == '24510')

# Summerise (sum) of a variable (Emissions) by a factor (Year)
mv.bm.pm25.year <- aggregate(mv.bm.pm25$Emissions, list(mv.bm.pm25$year), sum)

# Name the variables in fcc.pm25.year
names(mv.bm.pm25.year) <- c('Year', 'Emissions')

# Convert year to character to avoid trailing zeros
mv.bm.pm25.year$Year <- as.character(mv.bm.pm25.year$Year)

# Plot fcc.pm25.year
(ggplot(mv.bm.pm25.year, aes(Year, Emissions, fill = Year, label = sprintf('%2.0f', Emissions), ymax = max(Emissions)*1.1))
  + geom_bar(position = 'dodge', stat = "identity")
  + geom_text(position = position_dodge(width = 1), vjust = -0.25) 
  + labs(y = 'Emissions (measured in tons of PM2.5)') # add y label
  + labs(title = "Emissions from motor vehicle sources in Baltimore") # add a title
  + theme(plot.title = element_text(hjust = 0.5)) # center the title
  )

# open a png() device to save the plot to a PNG file with a width of 480 pixels 
#  and a height of 480 pixels
dev.copy(png, "Plot5.png", width = 480, height = 480, units = 'px')

# close the device
dev.off()