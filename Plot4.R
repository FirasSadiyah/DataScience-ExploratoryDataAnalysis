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

########### Plot 4 #####################
# Across the United States, how have emissions from coal combustion-related 
#  sources changed from 1999–2008?

# search for 'Fuel Comb' and 'Coal'
fuelCombCoal <- grep('(^Fuel\\sComb .* Coal)', SCC$EI.Sector)

# create an empty data frame
fcc <- data.frame()

# subset the fuelCombCoal from SCC
fcc <- SCC[fuelCombCoal,]

# merge both fcc and NEI data frames by the common variable 'SCC'
fcc.pm25 <- merge(fcc, NEI, by = 'SCC')

# Summerise (sum) of a variable (Emissions) by a factor (Year)
fcc.pm25.year <- aggregate(fcc.pm25$Emissions, list(fcc.pm25$year), sum)

# Name the variables in fcc.pm25.year
names(fcc.pm25.year) <- c('Year', 'Emissions')

# Convert year to character to avoid trailing zeros
fcc.pm25.year$Year <- as.character(fcc.pm25.year$Year)

# Plot fcc.pm25.year
(ggplot(fcc.pm25.year, aes(Year, Emissions, fill = Year, label = sprintf('%2.0f', Emissions), ymax = max(Emissions)*1.1))
    + geom_bar(position = 'dodge', stat = "identity")
    + geom_text(position = position_dodge(width = 1), vjust = -0.25) 
    + labs(y = 'Emissions (measured in tons of PM2.5)') # add y label
    + labs(title = "Emissions from coal combustion-related sources in the United States") # add a title
    + theme(plot.title = element_text(hjust = 0.5)) # center the title
)

# open a png() device to save the plot to a PNG file with a width of 480 pixels 
#  and a height of 480 pixels
dev.copy(png, "Plot4.png", width = 480, height = 480, units = 'px')

# close the device
dev.off()
