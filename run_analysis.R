library(dplyr)
library(data.table)
library(tidyr)

if (!dir.exists("UCI HAR Dataset")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCIHARDataset.zip", method = "curl")
    unzip("UCIHARDataset.zip")
}

## There are duplicate col names in the data set
features <- read.table("UCI HAR Dataset/features.txt")
colnames <- make.unique(features$V2)

## combine training set and test set
trainDT <- fread("UCI HAR Dataset/train/X_train.txt", col.names = colnames)
testDT <- fread("UCI HAR Dataset/test/X_test.txt", col.names = colnames)
combinedDT <- rbind(trainDT, testDT)

## combine training set and test set
trainSubject <- fread("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
testSubject <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subjectDT <- rbind(trainSubject, testSubject)

## combine training set and test set
trainActivity <- fread("UCI HAR Dataset/train/y_train.txt", col.names = "activity-code")
testActivity <- fread("UCI HAR Dataset/test/y_test.txt", col.names = "activity-code")
activityDT <- rbind(trainActivity, testActivity)

## column bind together subject, activity and the data
DT <- cbind(subjectDT, activityDT, combinedDT)

## select those std and mean columns
DT <- DT %>% select(subject, "activity-code", grep("(-(std|mean)\\(\\)((-(X|Y|Z))*))$", names(DT), value = TRUE))
setnames(DT, tolower(gsub("[\\.]$", "", gsub("[\\.]{2,}", ".", make.names(colnames(DT))))))

## activity labels
activity_labels <- fread("UCI HAR Dataset/activity_labels.txt", key = "V1")
setkey(DT, "activity.code")
DT <- DT[activity_labels] %>% select(-activity.code) %>% rename(activity = V2)

summarized <- DT %>% group_by(subject, activity) %>% summarise_all(mean)
summarized <- summarized %>% gather(key = "measure", value = "mean", -c(subject, activity))


