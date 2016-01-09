str(newDate)
newDate$date <- as.Date(newDate$date, "%Y-%m-%d")
newDate$day <- weekdays(newDate$date)
newDate$weekday <- c("Weekday")
for (i in 1:nrow(newDate)){
  if (newDate$day[i] == "Saturday" || newDate$day[i] == "Sunday"){
    newDate$weekday[i] <- "Weekend"
  }
}
newDate$weekday <- as.factor(newDate$weekday)
weekend <- aggregate(steps ~ interval+weekday, newDate, mean)

##Uncomment the next line to save the chart as an image file.
##png("Steps_Means_on_Weekdays_Versus_Weekends.png", width=640, height=480)

print(qplot(
	interval, 
	steps, 
	data=weekend, 
	geom=c("line"), 
	xlab="Intervals of 5 Minutes", 
	ylab="Steps Means", 
	main="") 
	+ facet_wrap(~ weekday, ncol=1) 
	+ geom_smooth(method="loess")
	)

##Uncomment the next line to save the chart as an image file.
##dev.off()
