a<-read.csv("activity.csv")

totalNumberOfStepsPerDay <- sum(a$steps, na.rm=TRUE)