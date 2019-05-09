rm(list = ls())
# setwd("D:/Institut@EBW/User/06_Dissertation/datascientist/[3] Getting and Cleaning Data/coding/week4")
# source("run_analysis.R")
#install.packages("dplyr")
#library(dplyr)

## Data download and unzip 
# definition of variabels for data collectionand data download & unzip

fileName <- "HARUS_data.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- "UCI HAR Dataset"

if(!file.exists(fileName)){
        download.file(url,fileName, mode = "wb") 
}

if(!file.exists(dir)){
        unzip("HARUS_data.zip", files = NULL, exdir=".")
}

## Data read-in

labels <- read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("activity.code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt",col.names = c("measurement.index","measurement")) 
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",col.names = features$measurement)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names = features$measurement)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",col.names = "measurement.index")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",col.names = "measurement.index")



## 1.) Data merging (training data, test data)

merged_data_x = rbind(x_train,x_test)
merged_data_y = rbind(y_train,y_test)
merged_data_subject = rbind(subject_train,subject_test)
merged_data <- cbind(merged_data_subject,merged_data_y,merged_data_x)

## 2.) Data extracting (mean(), std())

filtered_data <- merged_data[,which(grepl("mean|std|subject|measurement.index",names(merged_data)))]

## 3.) Name the activities within the merged data

filtered_data$measurement.index <- labels[filtered_data$measurement.index,2]

## 4.) Name the activities within the merged data

manipulated_names <- names(filtered_data)
manipulated_names <- gsub("^t", "TimeDomain_", manipulated_names)
manipulated_names <- gsub("_Body", "_Body_", manipulated_names)
manipulated_names <- gsub("Acc", "Accelerometer", manipulated_names)
manipulated_names <- gsub(".mean", "_Mean", manipulated_names)
manipulated_names <- gsub(".std", "_StandardDeviation", manipulated_names)
manipulated_names <- gsub("...X", "_[x]", manipulated_names)
manipulated_names <- gsub("...Y", "_[y]", manipulated_names)
manipulated_names <- gsub("...Z", "_[z]", manipulated_names)
manipulated_names <- gsub("Freq", "_Frequency", manipulated_names)
manipulated_names <- gsub("Mag", "_Magnitude", manipulated_names)
manipulated_names <- gsub("Gyro", "_Gyroscope", manipulated_names)
manipulated_names <- gsub("^f", "FrequencyDomain_", manipulated_names)
manipulated_names <- gsub("BodyBody", "Body", manipulated_names)
manipulated_names <- gsub("Gravity", "Gravity_", manipulated_names)
manipulated_names <- gsub("Body", "Body_", manipulated_names)
manipulated_names <- gsub("tBody", "_TimeBody", manipulated_names)
manipulated_names <- gsub("__", "_", manipulated_names)
names(filtered_data) <- manipulated_names

## 5.) Average data set

average_final_data <- filtered_data %>% group_by(subject, measurement.index) %>% summarise_all(funs(mean))
write.table(average_final_data, "Result.txt", row.name=FALSE)
