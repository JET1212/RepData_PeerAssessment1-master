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
archive <- paste(getwd(), "/activity.csv", sep = "")
if(!file.exists(archive)){
    unzip(zip, list = FALSE, overwrite = FALSE)
}

activity <- read.table(file = archive, header = TRUE, sep = ",")