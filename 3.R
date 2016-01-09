timeSeries <- aggregate(steps ~ interval, data = activity, FUN = mean)

##Uncomment the next line to save the chart as an image file.
##png("Average_Number_of_Steps_Taken_Per_Day.png", width=640, height=480)

plot(
	timeSeries, 
	type = "l", 
	axes = F, 
	xlab = "Time of Day",
	ylab = "Average Number of Steps Across All Days", 
	main = "Average Number of Steps Taken Per Time of Day", 
	col = "blue"
	)

axis(
	1,
	at=c(seq(0,2400,100),835), 
	label = paste(c(seq(0,24,1),8),
	c(rep(":00",25),":40"),sep=""), 
	pos = 0
	)
axis(
	2, 
	at=c(seq(0,210,30),206.2), 
	label = c(seq(0,210,30),206.2), 
	pos = 0
	)
maximum <- which.max(timeSeries$steps)
segments(832, 0, 832, 206.2, col = "red", lty = "dashed")
text(
	835,
	200, 
	"Maximum average number of steps: (832,206.2)", 
	col = "black", adj = c(-.1, -.1)
	)
segments(0, 206.2, 832, 206.2, col = "red", lty = "dashed")
timeSeries [maximum, ]

##Uncomment the next line to save the chart as an image file.
##dev.off()

print(paste(835, " = 8.667 hours, reached at 8:40 am"))