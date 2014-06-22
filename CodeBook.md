Run Analysis
Version 1.0
2014-06-22
CodeBook.md
==========================

Data
------------------------------
The Human Activity Recognition Using Smartphones Data Set was obtained through the following link:
[link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

General information
----------------------------
The script and its final product - clean data set, meets all the requirements of the course project,
altough the order of the steps performed in the script is not identical with the one mentioned in the project.


Parts of the analysis:
------------------------
1. DATA LOAD
2. DATA MERGE
3. DATA RESHAPING - DATA SET 1
4. DATA RESHAPING - DATA SET 2
5. DATA OUTPUT


1. DATA LOAD
-------------------------------------------------------------------------------------------
Purpose of this part is to load all the necessary data from txt files into R environment for further analysis.
The files are loaded one by one into data frames. Names of created data frames correspond to the content and names of the files. The "raw" suffix informs that the data is not modified in any way.
Created objects:
- df_X_test_raw - data from file "X_test.txt" containing all the observations from test sample
- df_y_test_raw - data from file "y_test.txt" containing activity IDs corresponding to the observations from "X_test.txt"
- df_subject_test_raw - data from file "subject_test.txt" containing subject IDs corresponding to the observations from "X_test.txt"
- df_X_train_raw - data from file "X_train.txt" containing all the observations from train sample
- df_y_train_raw - data from file "y_train.txt" containing activity IDs corresponding to the observations from "X_train.txt"
- df_subject_train_raw - data from file "subject_train.txt" containing subject IDs corresponding to the observations from "X_train.txt"
- df_activity_labels - data from "activity_labels.txt" containing activity ID and activity names
- df_features - data from "features.txt" containg names of the variables stored in X_test/X_train files


2. DATA MERGE
-------------------------------------------------------------------------------------------
In this part the files are merged step by step in order to create one data frame.

Firstly the df_X_test_raw, df_y_test_raw and df_subject_test_raw are merged together using cbind.
One additional column "sample_type" with the value = "TEST" in every row is added to keep track of the records coming from the test sample in the final data set. It was not mentioned in the project, but it's a modification that might come in handy during certain analysis.
Afterwards the same procedure is applied to the train files.
Objects created:
- df_test_raw - data frame containing cbinded data from df_X_test_raw, df_y_test_raw, df_subject_test_raw and an additional column "sample_type" with value "TEST"
- df_train_raw - data frame containing cbinded data from df_X_train_raw, df_y_train_raw, df_subject_train_raw and an additional column "sample_type" with value "TRAIN"

Secondly df_test_raw and df_train row are merged together using rbind.
Objects created:
- df_raw - data frame containg rbinded data from df_test_raw and df_train_raw


3. DATA RESHAPING - DATA SET 1
-------------------------------------------------------------------------------------------
In this part:
- all the activities and variables are named explicitly
- proper columns (mean and std) are selected

NAMING ACTIVITIES
Activities are named with the use of "merge"function (similar to SQL join).
Data from df_activity_labels and df_raw is merged (joined) on activity_id column.
The resulting data frame overwrites df_raw and contains an additional activity_name column.
Columns created:
- df_raw$activity_name - text name of the activity

NAMING VARIABLES
Variables are named using for loop and the data from the (earlier loaded) df_features data frame.
The loop goes through columns of df_raw named V1 to V561 and renames them with succeeding row values of df_features$feature_name.

CHOSING COLUMNS WITH MEAN AND STD
Two vectors with column IDs of df_raw that contain "-mean()" and "-std()" strings are created using grep.
Those vectors are used to subset parts of the df_raw data frame, next the subsets are combined together with first 4 columns of df_raw, using cbind.
Objects created: 
- v_mean_id - vector with ids of columns that contain "-mean()" in their name
- v_std_id - vector with ids of columns that contain "-std()" in their name
- df_clean_all - data frame containg data from df_raw for chosen columns only:
	* activity_id - id of the activity
	* activity_name - text name of the activity
	* subject_id - id of the subject
	* sample_type - info about TEST or TRAIN sample
	* 66 VARIABLE COLUMNS - columns with all the mean and std variables


4. DATA RESHAPING - DATA SET 2
-------------------------------------------------------------------------------------------
The result of this part is a final data set with column means for each variable and combination of activity and subject.

First a list named l_groups is created - it represents the columns of df_clean_all by which the data is going to be grouped in the next step.
Next, "aggregate" function is used to group the data by the columns given in the list and the fucntion used to group the data is "mean".
Finally, using a for loop, column names are given a prefix "avg_" to mark that they contain average values.
Objexts created:
- l_groups - a list of first four columns from df_clean_all by which the data will be grouped
- df_clean_final - a data frame created from df_clean_all by "agregate" function, containing 180 observations (30 subjects x 6 activities) of 70 variables (4 grouping levels and 66 average values of mean and std variables)

5. DATA OUTPUT
-------------------------------------------------------------------------------------------
The df_clean_final is written into "tidy_data.txt" in ./GACD_Project directory.

