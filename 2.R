activity$dateAndTime <- as.POSIXct(
	with(activity, 
	paste(date, paste(interval %/% 100, interval %% 100, sep=":"))),
	format="%Y-%m-%d %H:%M",
	tz=""
	)

stepsPerDay <- setNames(
	aggregate(steps~as.Date(date), 
	activity, sum, na.rm = TRUE), 
	c("date","steps")
	)

xaxis <- seq(1, nrow(stepsPerDay), by = 6)

scale <- list(
	x = list(rot = 45, cex = 1.0, 
	labels = format(stepsPerDay$date, "%d-%b-%Y")[xaxis], at = xaxis)
	)

##Uncomment the next line to save the chart as an image file.
##png("StepsPerDay1.png", width=640, height=480)

plot(
	steps ~ date, 
	type="l", 
	data = stepsPerDay, 
	main = "Steps Per Day", 
	ylab = "Steps", 
	xlab = "Date"
	)

##Uncomment the next line to save the chart as an image file.
##dev.off()

print(paste("Mean:", mean(stepsPerDay$steps)))
print(paste("Median:", median(stepsPerDay$steps)))