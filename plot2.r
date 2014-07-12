## *** Notice *** ##
# I have kept the weekdays of my locale (pt_PT), so 'qui' = Thu, 'sex' = Fri and 'sab' = Sat
## *** End of Notice *** ##

## Create a new filtered file or use a previously created txt file based on date filters
# (so that for the four plots of this exercise we only need to create this file once)
# Setup reader and writer files
loaded <- FALSE
# if file exists but it's empty
if(file.exists('household_power_consumption-filtered.txt')) {
  if(length(readLines('household_power_consumption-filtered.txt', n=1)) == 0) {
    loaded <- FALSE
  }
  else { loaded <- TRUE }
}
# if file does not exist or it's empty, let's create/ fill it
if (!loaded) {
  file.create('household_power_consumption-filtered.txt')
  file_in <- file("household_power_consumption.txt","r")
  file_out <- file("household_power_consumption-filtered.txt","a")
  # retrieve the file headers
  row <- readLines(file_in, n=1)
  writeLines(row, file_out)
  # for each row, if condition is met, write the row to file
  rowsTotal <- readLines(file_in) 
  for (i in 2:length(rowsTotal)) {
    row <- rowsTotal[i]
    rowSplit <- strsplit(row, ';')
    filterValue <- rowSplit[[1]][1]
    if (filterValue == "1/2/2007" | filterValue == "2/2/2007") writeLines(row, file_out)
  }
  close(file_in)
  close(file_out)
}
## Read filtered file into R
# Get the collumn classes to improve speed of read.table
fileSample <- read.table("household_power_consumption-filtered.txt", header = TRUE, nrows = 5, sep=";")
classes <- sapply(fileSample, class)
file <- read.table("household_power_consumption-filtered.txt", header = TRUE, sep=";", colClasses=classes, stringsAsFactors=FALSE)

## Convert to date & time
# Adding the day to time to prevent strptime() from adding todays date
file$Time <- paste(file$Date, file$Time)
file$Date <- as.Date(file$Date, format = '%d/%m/%Y')
file$Time <- strptime(file$Time, format = '%d/%m/%Y %H:%M:%S')


## Make plot
# Reseting the screen to one chart only
par(mfrow=c(1,1))
plot(file$Time, file$Global_active_power, type='n', cex.axis = 0.75, cex.lab = 0.75, ylab='Global Active Power (kilowatts)')
lines(file$Time, file$Global_active_power, type='l') 

## Export the plot to PNG
dev.copy(png, file='plot2.png', width = 480, height = 480, units = "px")
dev.off()