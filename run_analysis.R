library(dplyr)
library(tidyr)

## Merge
subject_test <- read.csv("test/subject_test.txt",sep = "",col.names = "subjectname",header = F)
x_test <- read.csv("test/X_test.txt", sep = "",header = F)
y_test <- read.csv("test/y_test.txt", sep = "",header = F,col.names = "activitylabel")

subject_train <- read.csv("train/subject_train.txt", sep = "",col.names = "subjectname",header = F)
x_train <- read.csv("train/X_train.txt", sep = "",header = F)
y_train <- read.csv("train/y_train.txt", sep = "",header = F,col.names = "activitylabel")

features <- read.csv("features.txt",sep = "",stringsAsFactors = F,colClasses=c("NULL",NA),header = F)

features <- t(features)

names(x_train) <- features
names(x_test) <- features

X <- rbind(x_train,x_test)
Y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)

dataset <- cbind(subject,X,Y)

## Extracts only the measurements on the mean and standard deviation for each measurement

datasetextracted <- dataset[grepl(pattern = "mean\\(\\)|std\\(\\)|subjectname$|activitylabel$",names(dataset))]

## Uses descriptive activity names to name the activities in the data set

activity_labels <- read.csv("activity_labels.txt", sep = "", col.names = c("activitylabel", "activityname"))

dataset <- merge(datasetextracted,activity_labels,by = "activitylabel");
dataset <- select(dataset, -activitylabel)

## Appropriately labels the data set with descriptive variable names.
names(dataset) <- tolower(names(dataset))
names(dataset) <- gsub("-","",names(dataset))
names(dataset) <- sub("\\(\\)","",names(dataset))

names(dataset)<-gsub("^t", "time", names(dataset))
names(dataset)<-gsub("^f", "frequency", names(dataset))
names(dataset)<-gsub("acc", "accelerometer", names(dataset))
names(dataset)<-gsub("gyro", "gyroscope", names(dataset))
names(dataset)<-gsub("mag", "magnitude", names(dataset))
names(dataset)<-gsub("bodybody", "body", names(dataset))

## creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tempData <- group_by(dataset,subjectname,activityname)
avgData <- summarise_each(tempData,funs(mean))

## tidying data with tidyr
finalData <- gather(avgData, variable,avgValues, timebodyaccelerometermeanx:frequencybodygyroscopejerkmagnitudestd)

write.table(finalData, file = "tidy data/dataSet.csv",row.names=FALSE, na="", sep=",")