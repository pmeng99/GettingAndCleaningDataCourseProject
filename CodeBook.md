---
title: "Getting and Cleaning Data Course Project CodeBook"
author: "Peihuan Meng"
date: "5/29/2020"
fontsize: 10pt
output: pdf_document
---

```{r echo=FALSE, include=FALSE}
source("run_analysis.R")
```

This CodeBook describes the data, the variables, and the transformation that leads to the final tidy data set for the assignment. It is meant to be used together with _features.txt_ and _feature_info.txt_ from the downloaded data set.

#### **Data**

The original data sets were collected from the accelerometers of Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

**[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)**

The data can be downloaded from here:

**[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)**

For a complete description of the original data sets, refer to _README.txt_, _features.txt_ and _features_info.txt_ in the download for details.

The oberservations in the original data sets are randomly split into 2 sets, 2947 observations under _test_ and 7352 observations under _train_. For this assignment, the 2 sets of data are 
merged together which results in a data set with `r nrow(tb)` observations. 

For this assignment, each observation consists of the following:

1. An identifier of the subject who carried out the experiment (_subject_test.txt_ + _subject_train.txt_)
2. An activity code specifying which one of the six activities is carried in the observation (_y_test.txt_ + _y_train.txt_)
3. A `r length(features)`-feature vector with time and frequency domain variables. (_X_test.txt_ + _X_train.txt_)

Additionally, the following 2 files are used for variable names and transformation from activity code to activity name:

1. The variables names (_features.txt_) 
2. The mappings between activity codes and activity names (_activity_labels.txt_)

#### **Variables**

The variables for this assignment are the `r length(features)` features/variables in _features.txt_. Together with the subject that carries out the experiment and the activity that was carried out, it forms a `r nrow(tb)` by `r length(features) + 2` data set. This is the data set the assignment is built upon. 
 
#### **Transformations**

1. Transformation starts from combining the 2 data sets, _test_ and _train_, into one date set called _consolidated_. 

2. It then reads in the 3 tables, subjects (`r dim(subjects)`), activities (`r dim(activities)`) and a data set (`r dim(tb)`) for the `r ncol(tb)` features/variables.

3. Next proper names are given to the 3 tables. _subject_ for the subjects table, _activity_ for the activites table, and the 561 features for the data set. 

4. It then selects only those variables whose names end with _-std()_, _-mean()_, _-std()-XYZ_ or _-mean()-XYZ_ from the 3rd table. Total `r length(selected_vars)` variables selected

```{r selected_vars}
selected_vars
```

5. Column bind the 3 tables together

6. Transform the varialbe names into more readable format

```{r selected_tb}
names(selected_tb)
```
7. Group the data by _subject_ and _activity_

8. Call _summarise_all_ on the grouped data set to get the mean for each group

9. Call _gather_ on above data set with key as _measure_ and value as _mean_ on all columns other than _subject_ and _activity_. At this point, this data set is tidy data set.

```{r tidy_summary_tb}
head(tidy_summary_tb)
summary(tidy_summary_tb)
```
