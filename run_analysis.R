##############################################################
# run_analysis.R
# 2014-06-22
##############################################################

# Setting wd - just in case of restoring R defaults
setwd("D:/Documents and Settings/Norbi/Moje dokumenty/R")

########## 1. DATA LOAD ##########

  ##### TEST FILES #####
  # Loading data files from TEST one by one      
  df_X_test_raw <- read.table("./GACD_Project/UCI HAR Dataset/test/X_test.txt")
  df_y_test_raw <- read.table("./GACD_Project/UCI HAR Dataset/test/y_test.txt", col.names="activity_id")
  df_subject_test_raw <- read.table("./GACD_Project/UCI HAR Dataset/test/subject_test.txt", col.names="subject_id")

  ######### TRAIN FILES #############
  # Loading data files from TRAIN one by one      
  df_X_train_raw <- read.table("./GACD_Project/UCI HAR Dataset/train/X_train.txt")
  df_y_train_raw <- read.table("./GACD_Project/UCI HAR Dataset/train/y_train.txt", col.names="activity_id")
  df_subject_train_raw <- read.table("./GACD_Project/UCI HAR Dataset/train/subject_train.txt", col.names="subject_id")

  ##### ADDITIONAL DATA #####
  # Loading additional data for further use in DATA RESHAPING part
  df_activity_labels <- read.table("./GACD_Project/UCI HAR Dataset/activity_labels.txt", col.names=c("activity_id", "activity_name"))
  df_features <- read.table("./GACD_Project/UCI HAR Dataset/features.txt", col.names=c("feature_id", "feature_name"), stringsAsFactors=FALSE)


##### 2. DATA MERGE #####

  ##### MERGING DATA TO 1 DATA FRAME #####
  # Merging 3 TEST files to 1 data frame (df_test_raw) and 3 TRAIN files to 1 data frame (df_train_raw)
  ###### IMPORTANT!!!
    ##### column1: subject_id
    ##### column2: activity_id
    ##### column3: sample_type - added to be able to distinct TRAIN and TEST data rows after merging (just in case)
    ##### column4 to 565: v1 to v561 (values from X)
  df_test_raw <- cbind(df_subject_test_raw, df_y_test_raw, sample_type="TEST", df_X_test_raw)
  df_train_raw <- cbind(df_subject_train_raw, df_y_train_raw, sample_type="TRAIN", df_X_train_raw)
  # Merging df_test_raw and df_train_raw into 1 data frame with TEST and TRAIN data
  df_raw <- rbind(df_test_raw, df_train_raw)


##### 3. DATA RESHAPING - DATA SET 1 #####
# This part of the script will prepare a clean data set with all necessary variable names, columns, etc.
# Then it will be used to prepare a second data set with column averages that will meet the requirement of the project

  ##### NAMING ACTIVITIES #####
  # Joining data frame with activity labels with df_raw on activity_id column
  df_raw <- merge(df_activity_labels, df_raw)
  # Overwritten data frame df_raw has an additional column with activity name

  ##### RENAMING COLUMNS CONTAINING VARIABLES FROM X_DATA FILE #####
  # Using for loop to change column names (V1 to V561) of df_raw with
  # names of matching features stored in rows of df_features
  for (i in 1:length(df_features$feature_id))
    {
    names(df_raw)[names(df_raw)==paste("V",i,sep="")] <- df_features[i,2]  
    }

  ##### CHOSING COLUMNS WITH MEAN AND STD #####
  # Using grep to find column id's with "mean" and "std"
  v_mean_id <- grep("-mean\\(\\)", names(df_raw))
  v_std_id <- grep("-std\\(\\)", names(df_raw))
  # Binding first 4 columns of df_raw (activity_id, activity_name, subject_id, sample_type)
  # with chosen 66 mean and std columns
  df_clean_all <- cbind(df_raw[,1:4], df_raw[,v_mean_id], df_raw[,v_std_id])
  # Resulting data frame df_clean_all contains a tidy set of data


##### 4. DATA RESHAPING - DATA SET 2 #####
# This part prepares a clean data set with column means grouped by subject_id and activity_name.
# I deliberately two additional grouping columns (activity_id and sample_type) 

  ##### COUNTING VARIABLE AVERAGES #####
  # Creating a list containing 4 grouping levels to be used with "aggregate" function in the next step
  l_groups <- list(activity_id=df_clean_all$activity_id,
              activity_name=df_clean_all$activity_name,
              subject_id=df_clean_all$subject_id,
              sample_type=df_clean_all$sample_type)
  # Using "aggregate" to calculate means of 66 columns with variables and group them by first 4 columns
  df_clean_final <- aggregate(df_clean_all[,5:70], by=l_groups, FUN=mean)
  # Adding "avg_" prefix to variable names in the df_clean_final
  for (i in 5:length(names(df_clean_final)))
  {
    names(df_clean_final)[i] <- paste("avg_",names(df_clean_final)[i],sep="")  
  }


##### 5. DATA OUTPUT #####
  # Saving the df_clean_final data frame to a csv file in ./GACD_Project directory.
  write.table(df_clean_final, "./GACD_Project/tidy_data.txt")
  










    