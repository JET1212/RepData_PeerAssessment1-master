# Reproducible Research Assignment 1
JET1212  
February 3, 2016  
## Loading and preprocessing the data

Show any code that is needed to:

  Load the data (i.e. read.csv())
  Process/transform the data (if necessary) into a format suitable for your analysis


```r
packs <- c("plyr", "lattice", "data.table", "httr", "ggplot2")

new.packs <- packs[!(packs %in% installed.packages()[, "Package"])]
if (length(new.packs)) {
    install.packages(new.packs, dependencies = TRUE)
  sapply(packs, require, character.only = TRUE)
}

directory <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"

zip <- paste(getwd(), "/activity.zip", sep = "")
if(!file.exists(zip)){
    download.file(directory, zip, method="curl", mode="wb")
}
```

```
## Warning: running command 'curl "https://d396qusza40orc.cloudfront.net/
## repdata%2Fdata%2Factivity.zip" -o "C:/Users/507192/Documents/R/
## RepData_PeerAssessment1-master/activity.zip"' had status 127
```

```
## Warning in download.file(directory, zip, method = "curl", mode = "wb"):
## download had nonzero exit status
```

```r
archive <- paste(getwd(), "/activity.csv", sep = "")
if(!file.exists(archive)){
    unzip(zip, list = FALSE, overwrite = FALSE)
}

activity <- read.table(file = archive, header = TRUE, sep = ",")
```

##What is the mean total number of steps taken per day?

For this part of the assignment, you can ignore the missing values in the dataset.

Calculate the total number of steps taken per day
If you do not understand the difference between a histogram and a barplot, research the difference between them. Make a histogram of the total number of steps taken each day
Calculate and report the mean and median of the total number of steps taken per day


```r
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

hist(
    stepsPerDay$steps, 
      breaks=50, 
      main="Histogram of Steps Per Day",
      xlab = "Steps Per Day"
      )
```

![](PA1_template_files/figure-html/unnamed-chunk-2-1.png)\

```r
print(paste("Mean:", mean(stepsPerDay$steps)))
```

```
## [1] "Mean: 10766.1886792453"
```

```r
print(paste("Median:", median(stepsPerDay$steps)))
```

```
## [1] "Median: 10765"
```

##What is the average daily activity pattern?

Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```r
timeSeries <- aggregate(steps ~ interval, data = activity, FUN = mean)

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
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)\

```r
timeSeries [maximum, ]
```

```
##     interval    steps
## 104      835 206.1698
```

```r
print(paste(835, " = 8.667 hours, reached at 8:40 am"))
```

```
## [1] "835  = 8.667 hours, reached at 8:40 am"
```


##Imputing missing values

Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.

Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
Create a new dataset that is equal to the original dataset but with the missing data filled in.
Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?


```r
paste("Number of missing observations: ", sum(is.na(activity$steps)))
```

```
## [1] "Number of missing observations:  2304"
```

```r
## Missing values are replaced with the mean.

newDate <- activity
newDate[is.na(activity$steps), ]$steps <- mean(activity$steps, na.rm=TRUE)

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


hist(
    stepsPerDay2$steps, 
      breaks=50, 
      main="Histogram of Steps Per Day",
      xlab = "Steps Per Day"
      )
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png)\

```r
print(paste("The mean:", mean(stepsPerDay2$steps)))
```

```
## [1] "The mean: 10766.1886792453"
```

```r
print(paste("The median:", median(stepsPerDay2$steps)))
```

```
## [1] "The median: 10766.1886792453"
```

```r
print(paste("The means difference:", mean(stepsPerDay2$steps)-mean(stepsPerDay$steps)))
```

```
## [1] "The means difference: 0"
```

```r
print(paste("The medians difference:", median(stepsPerDay2$steps)-median(stepsPerDay$steps)))
```

```
## [1] "The medians difference: 1.1886792452824"
```

##Are there differences in activity patterns between weekdays and weekends?

For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.


```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.2.3
```

```r
str(newDate)
```

```
## 'data.frame':	17568 obs. of  4 variables:
##  $ steps      : num  37.4 37.4 37.4 37.4 37.4 ...
##  $ date       : Factor w/ 61 levels "2012-10-01","2012-10-02",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ interval   : int  0 5 10 15 20 25 30 35 40 45 ...
##  $ dateAndTime: POSIXct, format: "2012-10-01 00:00:00" "2012-10-01 00:05:00" ...
```

```r
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


print(
    qplot(
	    interval, 
	    steps, 
	    data=weekend, 
	    geom=c("line"), 
	    xlab="Intervals of 5 Minutes", 
	    ylab="Steps Means", 
	    main="") 
	    + facet_wrap(~ weekday, ncol=1) 
	    + geom_smooth(method="loess"
	    )
    )
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)\


