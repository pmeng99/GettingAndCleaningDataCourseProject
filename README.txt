===================================================================
Coursera: Data Science Certification - Getting and Cleaning Data 
          Peer-graded Assignment - Getting and Cleaning Data Course Project
Submitter: Peihuan Meng
==================================================================

The assignment is built on the data set collected from the accelerometers from 
the SamSung Galaxy S smartphones. The goal of this assignment is to demonstrate 
our abilities learned from the class to work with, transform and clean up data.

The submission of this assignment includes:

1. The original data set (living under `UCI HAR Dataset` directory)

2. A combined data set that merges `test` and `train` data set. This data set
   lives under a directory called `consolidated` under `UCI HAR Dataset` parallal 
   to `test` and `train`. 
    
   All sub-tasks for the assignment uses this combined data set.

3. A R script (run_analysis.R) that carries out the 5 sub-tasks specified in the 
   assignment 

4. This README file with deatiled explanation of the above processing script.

5. A code book that describes the variables, the data and any processing done on them 

The 5 sub-tasks are:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the i
   average of each variable for each activity and each subject.

*************
** Task #1 **
*************

For task 1, a function called `concatenate_files()` is created. The parameter to this function 
is the location where the `UCI HAR Dataset` lives in the original data set. 

`concatenate_files()` first creates a directory called `consolidated` as a sibling directroy to 
the `test` and `train` directory.  It then recursively creates all sub-directories `test` and 
`train` has under them. 

Lastly, it cocatenates each data file from `train` directory to its coiunterpart in `test` 
directory and put the combined file under `consolidated` directory. 

Files under `consolidated` become the data set all subsequent work is based on. 

*************
** Task #2 **
*************

For task #2, the script first reads the data set, subjects and activities into data 
tables. 

Next, it assigns variables names to to the 3 tables, "subject" to the single column 
subjects table, "code" to the single column activities table, and the feature names 
to the data table. 

Next, it selected all the columns whose name ends with `-std()`, `-mean()`, `-std()-XYZ` or 
`-mean()-XYZ`, total 66 columns selected.

 [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
 [3] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
 [5] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
 [7] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
 [9] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
[11] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
[13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"      
[15] "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
[17] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
[19] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
[21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"          
[23] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
[25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"     
[27] "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
[29] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
[31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
[33] "tGravityAccMag-mean()"       "tGravityAccMag-std()"       
[35] "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
[37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"         
[39] "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
[41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
[43] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
[45] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"           
[47] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
[49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
[51] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
[53] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
[55] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
[57] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
[59] "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
[61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"  
[63] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
[65] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 

At this moment, we are ready for assembling by using cbind to column bind the 3 tables together. 
This table is subsequent work is operated on. 

*************
** Task #3 **
*************

For task #3, the sctipt reads in activity_labels. It then used inner_join to join the table 
from task #3 with this activity_label table. Note, at this moment, both activity code and 
activity label are in the joined table. The column "code" will be dropped next.

*************
** Task #4 **
*************

Task #4 is about transform the variable names into more readable/descriptive forms. Here, 
the general naming guideline is the following:

(1) use lower case letters 
(2) use "_" to separate words 
(3) use the complete word as opposed to abbrevations, for an example, "time" for "t", 
    "frequency" for "f" and "magnitude" for "mag". 

A complete list of transformed variable names are the following:

 [1] "time_body_accelation_mean_x"                        "time_body_accelation_mean_y"                       
 [3] "time_body_accelation_mean_z"                        "time_body_accelation_std_x"                        
 [5] "time_body_accelation_std_y"                         "time_body_accelation_std_z"                        
 [7] "time_body_gravity_mean_x"                           "time_body_gravity_mean_y"                          
 [9] "time_body_gravity_mean_z"                           "time_body_gravity_std_x"                           
[11] "time_body_gravity_std_y"                            "time_body_gravity_std_z"                           
[13] "time_body_accelation_jerk_mean_x"                   "time_body_accelation_jerk_mean_y"                  
[15] "time_body_accelation_jerk_mean_z"                   "time_body_accelation_jerk_std_x"                   
[17] "time_body_accelation_jerk_std_y"                    "time_body_accelation_jerk_std_z"                   
[19] "time_body_gyro_mean_x"                              "time_body_gyro_mean_y"                             
[21] "time_body_gyro_mean_z"                              "time_body_gyro_std_x"                              
[23] "time_body_gyro_std_y"                               "time_body_gyro_std_z"                              
[25] "time_body_gyro_jerk_mean_x"                         "time_body_gyro_jerk_mean_y"                        
[27] "time_body_gyro_jerk_mean_z"                         "time_body_gyro_jerk_std_x"                         
[29] "time_body_gyro_jerk_std_y"                          "time_body_gyro_jerk_std_z"                         
[31] "time_body_accelation_magnitude_mean"                "time_body_accelation_magnitude_std"                
[33] "time_body_gravity_magnitude_mean"                   "time_body_gravity_magnitude_std"                   
[35] "time_body_accelation_jerk_magnitude_mean"           "time_body_accelation_jerk_magnitude_std"           
[37] "time_body_gyro_magnitude_mean"                      "time_body_gyro_magnitude_std"                      
[39] "time_body_gyro_jerk_magnitude_mean"                 "time_body_gyro_jerk_magnitude_std"                 
[41] "frequency_body_accelation_mean_x"                   "frequency_body_accelation_mean_y"                  
[43] "frequency_body_accelation_mean_z"                   "frequency_body_accelation_std_x"                   
[45] "frequency_body_accelation_std_y"                    "frequency_body_accelation_std_z"                   
[47] "frequency_body_accelation_jerk_mean_x"              "frequency_body_accelation_jerk_mean_y"             
[49] "frequency_body_accelation_jerk_mean_z"              "frequency_body_accelation_jerk_std_x"              
[51] "frequency_body_accelation_jerk_std_y"               "frequency_body_accelation_jerk_std_z"              
[53] "frequency_body_gyro_mean_x"                         "frequency_body_gyro_mean_y"                        
[55] "frequency_body_gyro_mean_z"                         "frequency_body_gyro_std_x"                         
[57] "frequency_body_gyro_std_y"                          "frequency_body_gyro_std_z"                         
[59] "frequency_body_accelation_magnitude_mean"           "frequency_body_accelation_magnitude_std"           
[61] "frequency_body_body_accelation_jerk_magnitude_mean" "frequency_body_body_accelation_jerk_magnitude_std" 
[63] "frequency_body_body_gyro_magnitude_mean"            "frequency_body_body_gyro_magnitude_std"            
[65] "frequency_body_body_gyro_jerk_magnitude_mean"       "frequency_body_body_gyro_jerk_magnitude_std"    

*************
** Task #5 **
*************

Tasks #5 is accomplished by first grouping the table by "subject" and "activity", then piped
to a call to summarise_all with single mean function. 

The resulting table from above operation is messy data in the sense that variable values are
column names. Next, the script calls function `gather` with `measure` as key and `mean` as value.
Lastly, the mean values are formated in scientific notion. 

At this moment, a tidy data table is set to `tidy_summary_tb`

This table looks like the following:

# A tibble: 11,880 x 4
# Groups:   subject [30]
   subject activity           measure                     mean        
     <int> <chr>              <chr>                       <chr>       
 1       1 LAYING             time_body_accelation_mean_x 2.215982e-01
 2       1 SITTING            time_body_accelation_mean_x 2.612376e-01
 3       1 STANDING           time_body_accelation_mean_x 2.789176e-01
 4       1 WALKING            time_body_accelation_mean_x 2.773308e-01
 5       1 WALKING_DOWNSTAIRS time_body_accelation_mean_x 2.891883e-01
 6       1 WALKING_UPSTAIRS   time_body_accelation_mean_x 2.554617e-01
 7       2 LAYING             time_body_accelation_mean_x 2.813734e-01
 8       2 SITTING            time_body_accelation_mean_x 2.770874e-01
 9       2 STANDING           time_body_accelation_mean_x 2.779115e-01
10       2 WALKING            time_body_accelation_mean_x 2.764266e-01
# … with 11,870 more rows

This data set is written out as tab separated txt file `mean_by_subject_activity.txt` 
under `UCI HAR Dataset`.

To read this data table back into R, use the following:

read.table("mean_by_subject_activity.txt", header = TRUE, sep = "\t")
