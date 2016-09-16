# Getting and Cleaning Data Course Project

The datataset used is _Human Activity Recognition Using Smartphones Data Set._
[link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Files in the repo
* run_analysis.R

   1. R script which downloads dataset.
   2. Merges the training and the test sets to create one data set.
   3. Extracts only the measurements on the mean and standard deviation for each measurement.
   4. Uses descriptive activity names to name the activities in the data set
   5. Appropriately labels the data set with descriptive variable names.
   6. creates a second, independent tidy data set with the average of each variable for each activity and each subject.
   7. Makes tidy dataset using *gather()* in veriable-value format. It makes data in **long form** instead of wide form

* tidyDataSet.csv

   Required Tidy Data Set
*  CodeBook.md

   Code book that describes the variables, the data, and any transformations or work that performed to clean up the data

## Running the script
Load the script in R or Rstudio it will download and extract out Tidy Data Set to *tidyDataSet.csv*
