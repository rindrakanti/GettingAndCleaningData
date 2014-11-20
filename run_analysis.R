# This R script gets and performs cleaning of data collected from the accelerometers 
#from the Samsung Galaxy S smartphone.The full description of the data set is available at:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

library(plyr)

#Main function that invokes other functions to accomplish various steps
Main = function() {
  #Step 0 Download data
  download.data()
  # Step1 : Merges the training and test sets to create one data set.
  merged <- merge.datasets()
  # Step2 : Extract only the measurements of the mean and standard deviation for each measurement
  cx <- extract.mean.and.std(merged$x)
  # Step3 : Uses descriptive activity names to name the activities
  cy <- name.activities(merged$y)
  #Step4 : Appropriately labels the data set with descriptive variable names
  # Use descriptive column name for subjects
  colnames(merged$subject) <- c("subject")
  # Combine data frames into one
  combined <- bind.data(cx, cy, merged$subject) #check dim(combined) # 10299*68
  write.table(combined, "merged_data.txt", row.names = TRUE)
  # Step 5 : Create tidy dataset and Write as csv
  tidy <- create.tidy.dataset(combined)  #check dim(tidy) # 180 * 62
  #write.csv(tidy, "UCI_HAR_tidy_data.csv", row.names=FALSE)
  write.table(tidy, "tidy_data.txt", row.names = TRUE)
}

#Step 0 Download data
download.data = function() {
  #Checks for data directory and creates one if it doesn't exist
  if (!file.exists("data")) {
    dir.create("data")
  }
  if (!file.exists("data/UCI HAR Dataset")) {
    # download the data
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipfile="data/UCI_HAR_data.zip"
    download.file(fileURL, destfile=zipfile)
    unzip(zipfile, exdir="data")
  }
}

# Step1 : Read and Merge the training and test sets to create one data set.
#This function returns a list of three dataframes: X, y, and subject
merge.datasets = function() {
  # Read data
  training.x <- read.table("data/UCI HAR Dataset/train/X_train.txt") 
  training.y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
  training.subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
  test.x <- read.table("data/UCI HAR Dataset/test/X_test.txt") 
  test.y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
  test.subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
  #Merge
  merged.x <- rbind(training.x, test.x) 
  merged.y <- rbind(training.y, test.y) 
  merged.subject <- rbind(training.subject, test.subject) #Check dim(merged.subject) # 10299*1
  # merge train and test datasets and return
  list(x=merged.x, y=merged.y, subject=merged.subject)
}

# Step2 : Extract only the measurements of the mean and standard deviation for each measurement
# Given the dataset (x values), extract only the measurements on the mean
# and standard deviation for each measurement.
extract.mean.and.std = function(df) {
  
  # Read the feature list file
  features <- read.table("data/UCI HAR Dataset/features.txt")  #check dim(features) # 561*2
  # Find the mean and std columns
  mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
  std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
  # Extract them from the data
  edf <- df[, (mean.col | std.col)] 
  colnames(edf) <- features[(mean.col | std.col), 2]
  edf  #check dim(edf)  # 10299*66
}

# Step3 : Uses descriptive activity names to name the activities
name.activities = function(df) {
  colnames(df) <- "activity"
  df$activity[df$activity == 1] = "WALKING"
  df$activity[df$activity == 2] = "WALKING_UPSTAIRS"
  df$activity[df$activity == 3] = "WALKING_DOWNSTAIRS"
  df$activity[df$activity == 4] = "SITTING"
  df$activity[df$activity == 5] = "STANDING"
  df$activity[df$activity == 6] = "LAYING"
  df
}

#Step4 : label the data set with descriptive variable names
# Combine mean-std values (x), activities (y) and subjects into one data frame.
bind.data <- function(x, y, subjects) {
  cbind(x, y, subjects)
}

# Step 5 : Given X values, y values and subjects, create an independent tidy dataset
# with the average of each variable for each activity and each subject.
create.tidy.dataset = function(df) {
  tidy <- ddply(df, .(subject, activity), function(x) colMeans(x[,1:60]))
  tidy
}

setwd("~/CoursEra/GettingCleaningData/CourseProject")
Main()



