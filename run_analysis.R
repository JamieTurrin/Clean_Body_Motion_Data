# James Turrin
# Getting and Cleaning Data, class project

# Program to load and clean a large dataset of accelerometer and gyro data
# produced from wearable Galaxy smartphones.
################################################################################
# UCI HAR Dataset folder contains:

# activity_labels.txt: with the activites labeled 1 thru 6

# features.txt: lists the 561 features calculated using the data, but does not
#               contain data, just the feature names

# features_info.txt: contains some info regarding the features,including the set
#               of variables (mean, stdev, etc.) that were computed for each.

# README.txt: more complete info regarding dataset, including brief descriptions
#               of the files in the 'test' and 'train' folders.

# 'Test/Train' folders: Each contains subject_test, X_test, y_test files.

# subject_test/train.txt: contains the ID of the human subject, an integer from
#                   1-30 in a single row of data.

# X_test/train.txt: Processed data to be analyzed by this program

# y_test/train.txt: An integer from 1-6 that indicates the activity. This is a
#                   single row of data.

# Inertial Signals Folder: contains raw data produced by accelerometer and gyro,
#                           not for use by this program.

###############################################################################
# THESE LINES CREATE WORKING DIRECTORY THEN DOWNLOAD AND UNZIP THE DATA

# create directory for project to hold data and output
if(!file.exists("./GetCleanDataProject")){dir.create("./GetCleanDataProject")}

setwd("./GetCleanDataProject")

# location of data
url<-"http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI HAR Dataset.zip"

# download zip file of data
download.file(url,destfile="project_data.zip")

unzip("project_data.zip")  # unzip the data file

################################################################################
# READ DATA FROM 'TEST' FOLDER AND COMBINE INTO SINGLE DATAFRAME

# read 'features' into dataframe
features<-read.table("UCI HAR Dataset/features.txt",col.names=c("number","feature"),
                     colClasses=c("integer","character"))

# read test subject_IDs into dataframe
test_ids<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names="ID") 

# read activity number into dataframe
test_act_num<-read.table("UCI HAR Dataset/test/y_test.txt",col.names="activity_number")

# create new variable in test_act_num dataframe to hold activity description
for(i in 1:nrow(test_act_num)){
    if(test_act_num$activity_number[i]==1) test_act_num$activity[i]<-"WALKING"
    if(test_act_num$activity_number[i]==2) test_act_num$activity[i]<-"WALKING_UPSTAIRS"
    if(test_act_num$activity_number[i]==3) test_act_num$activity[i]<-"WALKING_DOWNSTAIRS"
    if(test_act_num$activity_number[i]==4) test_act_num$activity[i]<-"SITTING"
    if(test_act_num$activity_number[i]==5) test_act_num$activity[i]<-"STANDING"
    if(test_act_num$activity_number[i]==6) test_act_num$activity[i]<-"LAYING"
}

library(data.table)  # load data.table package to use fread() function.
# fast-read processed data into dataframe 
# column names come from 'features' dataframe
X_test<-fread("UCI HAR Dataset/test/X_test.txt",col.names=features$feature)  

# merge subject_ID, activity_number, and test data into a single dataframe
test_data<-cbind(test_ids,test_act_num,X_test)

# delete extraneous dataframe objects to free memory:
rm(test_ids); rm(test_act_num); rm(X_test)

################################################################################
# READ DATA FROM 'TRAIN' FOLDER AND COMBINE INTO SINGLE DATAFRAME

# read training subject_IDs into dataframe
train_ids<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names="ID")

# read activity number into dataframe
train_act_num<-read.table("UCI HAR Dataset/train/y_train.txt",col.names="activity_number")

# create new variable in train_act_num dataframe to hold activity description
for(i in 1:nrow(train_act_num)){
    if(train_act_num$activity_number[i]==1) train_act_num$activity[i]<-"WALKING"
    if(train_act_num$activity_number[i]==2) train_act_num$activity[i]<-"WALKING_UPSTAIRS"
    if(train_act_num$activity_number[i]==3) train_act_num$activity[i]<-"WALKING_DOWNSTAIRS"
    if(train_act_num$activity_number[i]==4) train_act_num$activity[i]<-"SITTING"
    if(train_act_num$activity_number[i]==5) train_act_num$activity[i]<-"STANDING"
    if(train_act_num$activity_number[i]==6) train_act_num$activity[i]<-"LAYING"
}

# fast-read processed data into dataframe 
# column names come from 'features' dataframe
X_train<-fread("UCI HAR Dataset/train/X_train.txt",col.names=features$feature)  

# merge subject_ID, activity_number, and train data into a single dataframe
train_data<-cbind(train_ids,train_act_num,X_train)

# delete extraneous dataframe objects to free memory:
rm(train_ids); rm(train_act_num); rm(X_train)
###############################################################################
# MERGE AND ORDER THE DATA

# merge test dataframe and training dataframes into a single dataframe
data<-rbind(test_data,train_data)

# order the data by ID and activity number
data<-data[order(data$ID,data$activity_number),]

###############################################################################
# commands to limit data set to variable means and st. devs.

names_list<-names(data) # get list of all variable names

# get indices of variables that are 'means'
mean_indices<-grep("mean()",names_list)

# get indices of variables that are 'std'
std_indices<-grep("std()",names_list)

# combine indices of mean and std variable names into 1 vector 
# include columns 1,2,3 as well (ID,activity_number,activity)
mean_std_indices<-c(1,2,3,mean_indices,std_indices)

# order the vector of indices
mean_std_indices<-mean_std_indices[order(mean_std_indices)]

#subset data so only variables that are mean or std are present.
data<-data[,mean_std_indices] 

##############################################################################
# split data and compute averages of variables by ID and activity
# and transpose the dataframe, swapping rows and columns
# so data are oriented correctly in output.

# split data by Id and activity
s<-split(data,list(data$ID,data$activity))

# calc mean for each combination of Id and activity
means<-lapply(s, function(x) colMeans(x[4:82]))

# convert list to dataframe
means<-as.data.frame(means)

col_names<-names(means) #get column names
row_names<-row.names(means) # get row names

# transpose rows and columns, so variables are columns and ID/activity are rows
means<-transpose(means) 

# use as.data.frame() to name the rows with the old column names
means<-as.data.frame(means,row.names=col_names)

# column names become the old row names
names(means)<-row_names

###############################################################################
# commands to format data so it looks nice when written to table

col_names<-names(means) # get new column names

widths<-numeric(80) # create vector to hold column widths to format output
library(stringr)  # load package to use str_pad() function

for(i in 1:79){ # set width according to width of column name or data values
    if(nchar(col_names[i])>nchar(means[1,i])) 
        {widths[i+1]<-nchar(col_names[i])}
    else if(nchar(col_names[i])<=nchar(means[1,i])) 
        {widths[i+1]<-nchar(means[1,i])
        # pad column name with whitespace if necessary to match width of data
        col_names[i]<-str_pad(col_names[i],widths[i+1],side="left")}}

widths[1]<-22 # set first width to match width of longest variable name

# pad first variable name with extra whitespace for proper placement
# to the right of the row names
col_names[1]<-str_pad(col_names[1],40,side="left")

names(means)<-col_names # put new names back into dataframe


# write to fixed-width table
# Using rownames=TRUE in spite of instructions because the data
# make more sense this way!!
library(gdata) # load gdata package to use write.fwf() function
write.fwf(means,file="Body_Motion_Means.txt",
          width=widths,rownames=TRUE)


