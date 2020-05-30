
library(dplyr)
library(tidyr)

############################################################################
## Question #1: Merges the training and the test sets to create one data set.
###########################################################################

## input: parent directory name (where `UCI HAR Dataset` is)
## This function first creates a `consolidated` directoryi as a sibling directory of `test` and 
## `train` directories if such directory does not already exist. This `consolidated` directory 
## is where all the combined files will live. 
##
## It then recurisively create all the subdirectories mirrored those under `test` (and `train`) 
##
## Lastly, it append all files from `train` to its counter parts under `test` and put the result
## file as similar location under `consolidated` directory
concatenate_files <- function(directory) {
    
    cdir <- paste0(directory, "consolidated")
    sdir <- paste0(directory, "test")
    
    ## create consolidated dir if not yet existing
    if (!file.exists(cdir)) {
        dir.create(cdir)
    }
    
    ## create all subdirectories under consolidated
    if (dir.exists(sdir)) {
        for (dir in list.dirs(sdir, recursive = TRUE)) {
            spath <- paste0(dirname(dir), "/", basename(dir))
            dpath <- sub("test", "consolidated", spath)
            if (!dir.exists(dpath)) {
                dir.create(dpath)
            }
        }
    }
    
    ## append all files and save under consolicated
    if (dir.exists(sdir)) {
        for (sfile in list.files(sdir, recursive = TRUE)) {
            spath1 <- normalizePath(file.path(sdir, sfile))     ## source file 1 from test
            spath2 <- gsub("test", "train", spath1)             ## source file 2 from train
            dpath <- gsub("test", "consolidated", spath1)
            
            if (!file.exists(dpath)) {
                file.create(dpath)
            }
            file.append(dpath, spath1)
            file.append(dpath, spath2)
        }
    }
}

## call above function from the root of the data directory
concatenate_files("UCI HAR Dataset/")

#################
## Question #2 ##
#################

## read in data (consolidated data set by appending `train`` data set to `test`` data set)
tb <- read.table("UCI HAR Dataset/consolidated/X_consolidated.txt")

## read subjects
subjects <- read.table("UCI HAR Dataset/consolidated/subject_consolidated.txt")

## read activities
activities <-  read.table("UCI HAR Dataset/consolidated/y_consolidated.txt")

## read in feature names (first into a table and then only use the feature names as a vector)
features <- read.table("UCI HAR Dataset/features.txt")
features <- as.vector(features$V2)

## set subjects table column (1) name
names(subjects) <- c("subject")
## set activities table column (1) name to "code". This column name later on will be used by join with activity labels
names(activities) <- c("code")
## give all columns (561) in data set proper names 
names(tb) <- features

## select those columns whose names end with `-std()`, `-mean()`, `-std()-XYZ` or `-mean()-XYZ` into a new table 
## named selected_tb
selected_vars <- features[grep("(-(std|mean)\\(\\)((-(X|Y|Z))*))$", features)]
selected_tb <- tb[,names(tb) %in% selected_vars]

## column bind subjects, activities and data tables together
selected_tb <- cbind(subjects, activities, selected_tb)

#################
## Question #3 ##
#################

## read activity labels, translate from activity code to activity name in selected_tb
activity_lables <- read.table("UCI HAR Dataset/activity_labels.txt")
## name column names to be used in join and later on in the result selected_tb table
names(activity_lables) <- c("code", "activity")
## join the 2 tables and drop the "code" column
selected_tb <- selected_tb %>% inner_join(activity_lables, by = "code") %>% select(-code)

#################
## Question #4 ##
#################

## variable_names will transform from variable names defined in features.txt into meaningful, more
## readable ones
transform_variable_names <- function(features) {
    result <- vector(length = 0)
    for (f in features) {
        ## translate starting t to time, f to frequency
        f <- sub("^t", "time_", f)
        f <- sub("^f", "frequency_", f)
        
        f <- sub("BodyAcc-", "body_accelation_", f)
        f <- sub("BodyAccJerk-", "body_accelation_jerk_", f)
        f <- sub("BodyAccMag-", "body_accelation_magnitude_", f)
        f <- sub("BodyAccJerkMag-", "body_accelation_jerk_magnitude_", f)

        f <- sub("BodyGyro-", "body_gyro_", f)
        f <- sub("BodyGyroJerk-", "body_gyro_jerk_", f)
        f <- sub("BodyGyroMag-", "body_gyro_magnitude_", f)
        f <- sub("BodyGyroJerkMag-", "body_gyro_jerk_magnitude_", f)
        
        f <- sub("GravityAcc-", "body_gravity_", f)
        f <- sub("GravityAccMag-", "body_gravity_magnitude_", f)
       
        f <- sub("_Body", "_body_", f)
        f <- sub("-", "_", f)
        f <- sub("\\(\\)", "", f)
    
        f <- tolower(f)
        
        result <- c(result, f)
    }
    result
}

## transform variable names into meaningful names
## the result will be table `selected_tb`
names(selected_tb) <- transform_variable_names(names(selected_tb))

#################
## Question #5 ##
#################

## group by `subject` and `activity` and get mean per subject and activity combination
summary_tb <- selected_tb %>% group_by(subject, activity)  %>% summarise_all(mean)

## tidy up data: in summary_tb, variables values are variable, use gather to transform
tidy_summary_tb <- gather(summary_tb, key = "measure", value = "mean", -c("subject", "activity"))
## format mean values in scientific notion
tidy_summary_tb$mean <- format(tidy_summary_tb$mean, scientific = TRUE) %>% trimws

## write above tidy data set to file 
filename <- "mean_by_subject_activity.txt"
if (!file.exists(filename)) {
    file.create(filename)
}
write.table(tidy_summary_tb, file = filename, sep = "\t", row.names = FALSE, col.names = TRUE)

