library(dplyr)
library(tidyr)

## Downloading and unzipping dataset

if(!file.exists("./data")){
    dir.create("./data")
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile="./data/Dataset.zip")
    
    # Unzip dataSet to /data directory
    unzip(zipfile="./data/Dataset.zip",exdir="./data")
}

## Reading Files
subject_test <- read.csv("data/UCI HAR Dataset/test/subject_test.txt",sep = "",col.names = "subjectname",header = F)
x_test <- read.csv("data/UCI HAR Dataset/test/X_test.txt", sep = "",header = F)
y_test <- read.csv("data/UCI HAR Dataset/test/y_test.txt", sep = "",header = F,col.names = "activitylabel")

subject_train <- read.csv("data/UCI HAR Dataset/train/subject_train.txt", sep = "",col.names = "subjectname",header = F)
x_train <- read.csv("data/UCI HAR Dataset/train/X_train.txt", sep = "",header = F)
y_train <- read.csv("data/UCI HAR Dataset/train/y_train.txt", sep = "",header = F,col.names = "activitylabel")

features <- read.csv("data/UCI HAR Dataset/features.txt",sep = "",stringsAsFactors = F,colClasses=c("NULL",NA),header = F)
activity_labels <- read.csv("data/UCI HAR Dataset/activity_labels.txt", sep = "", col.names = c("activitylabel", "activityname"))

## setting headers to dataset
features <- t(features)
names(x_train) <- features
names(x_test) <- features

    ## mearge datasets 
X <- rbind(x_train,x_test)
Y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)
dataset <- cbind(subject,X,Y)

## Extracts only the measurements on the mean and standard deviation for each measurement
datasetextracted <- dataset[grepl(pattern = "mean\\(\\)|std\\(\\)|subjectname$|activitylabel$",names(dataset))]

## Uses descriptive activity names to name the activities in the data set
dataset <- merge(datasetextracted,activity_labels,by = "activitylabel");
dataset <- select(dataset, -activitylabel)

## Appropriately labels the data set with descriptive variable names.
names(dataset) <- tolower(names(dataset))
names(dataset) <- gsub("-","",names(dataset))
names(dataset) <- sub("\\(\\)","",names(dataset))
names(dataset) <- gsub("^t", "time", names(dataset))
names(dataset) <- gsub("^f", "frequency", names(dataset))
names(dataset) <- gsub("acc", "accelerometer", names(dataset))
names(dataset) <- gsub("gyro", "gyroscope", names(dataset))
names(dataset) <- gsub("mag", "magnitude", names(dataset))
names(dataset) <- gsub("bodybody", "body", names(dataset))

## creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tempData <- group_by(dataset,subjectname,activityname)
avgData <- summarise_each(tempData,funs(mean))

## tidying data with tidyr in variable-value format
finalData <- gather(avgData, variable,averagevalues, timebodyaccelerometermeanx:frequencybodygyroscopejerkmagnitudestd)

## creating csv file
write.table(finalData, file = "tidyDataSet.csv",row.names=FALSE, na="", sep=",")