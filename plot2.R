#Library
library(data.table)

#Read data
urldata = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists("data")) {
  dir.create("data")
}

def <- "./data/household_power_consumption.zip"
download.file(urldata,destfile = def ,method = "curl")
unzip(def, exdir = "./data",overwrite = TRUE)

#Read All (127MB file -> 266085888 bytes)
#data <- read.csv("./data/household_power_consumption.txt",sep=";",header = TRUE)
#object.size(data)

#We actually only need data from the dates 2007-02-01 and 2007-02-02
#Start line 66638 1/2/2007
#End line 69517 2/2/2007
data <- read.csv("./data/household_power_consumption.txt",sep=";",
                 skip = 66636 , nrows=  (69518 - 66638) )
#Get Head
colnames(data) <- colnames(read.csv("./data/household_power_consumption.txt",sep=";",
                           header = TRUE, nrows =2))

#Convert Time and Date Posix
data$Date <- as.Date(data$Date, "%d/%m/%y")
data$Time <- strptime(data$Time, format = "%T")

data$FullDate <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

#Convert "?" into true NA
#grep('\\?', data[,names(data)[2:9]])
# return integer(0) => not present in interval of interest.


png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(y = data$Global_active_power, x = data$FullDate,
     type = 'l', xlab ="", ylab = "Global Active Power (kilowatts)")
dev.off()

