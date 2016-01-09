paste("Number of missing observations: ", sum(is.na(activity$steps)))

## Missing values are replaced with the mean.

newDate <- activity
newDate[is.na(activity$steps), ]$steps <- mean(activity$steps)

newDate$dateAndTime <- as.POSIXct(
	with(newDate, paste(date, paste(interval %/% 100, interval %% 100, sep=":"))),
    	format="%Y-%m-%d %H:%M",tz="")

stepsPerDay2 <- setNames(
	aggregate(steps~as.Date(date), newDate, sum, na.rm = TRUE), 
	c("date","steps")
	)

xaxis <- seq(1, nrow(stepsPerDay2), by = 6)

scale2 <- list(
	x = list(rot = 45, 
	cex = 1.0, 
	labels = format(stepsPerDay2$date, "%d-%b-%Y")[xaxis], 
	at = xaxis)
	)

##Uncomment the next line to save the chart as an image file.
##png("StepsPerDay2.png", width=640, height=480)

plot(
	steps ~ date,
	type="l", 
	data = stepsPerDay2, 
	main = "Number of Steps Per Day", 
	ylab = "Number of Steps", 
	xlab = "Date"
	)

##Uncomment the next line to save the chart as an image file.
##dev.off()

print(paste("The mean:", mean(stepsPerDay2$steps)))
print(paste("The median:", median(stepsPerDay2$steps)))

print(paste("The means difference:", mean(stepsPerDay2$steps)-mean(stepsPerDay$steps)))
print(paste("The medians difference:", median(stepsPerDay2$steps)-median(stepsPerDay$steps)))