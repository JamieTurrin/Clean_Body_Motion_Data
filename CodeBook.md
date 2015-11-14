---
title: "CodeBook.md"
author: "James Turrin"
date: "November 14, 2015"
output: html_document
---

Code Book for run_analysis.R

run_analysis.R is a stand-alone program for processing body-motion data
provided by the UCI Machine Learning Laboratory:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


########## THE DATASET INCLUDES: ##############################################

activity_labels.txt, which lists the 6 activities measured:
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING    

features.txt lists the names of the 561 variables calculated using the data.

features_info.txt contains some info regarding the features,including the set
of variables (mean, stdev, etc.) that were computed for each.

README.txt: more complete info regarding dataset, including brief descriptions
of the files in the 'test' and 'train' folders.

'Test/Train' folders: Each contains subject_test, X_test, y_test files.

subject_test/train.txt: contains the ID of the human subject, an integer from
1-30 in a single row of data.

X_test/train.txt: Processed data to be analyzed by this program

y_test/train.txt: An integer from 1-6 that indicates the activity listed in
activity_labels.txt

Inertial Signals Folder: contains raw data produced by accelerometer and gyro,
not for use by this program.


############ run_analysis.R functioning ########################################

THE PROGRAM PERFORMS THE FOLLOWING TASKS:

1. Creates a folder called GetCleanDataProject in your working directory.
2. The body-motion data is then downloaded into this directory and unzipped.
3. The features.txt, subject_test.txt, x_test.txt and y_test.txt files are read
    into separate data.frames.
4. A variable called "activity" is created in the 'test_act_num' data.frame
    to hold a character string with the description of the activity.
5. test_ids, test_act_num, and X_test data.frames are merged into a single
    data.frame.
6. Steps 3,4, and 5 are repeated for the 'train' files.
7. The test_data and train_data data.frames are merged together to produce a
    single data.frame (called 'data') with all the variables, subjects, and
    activities. This data.frame is then sorted by ID and activity.
8. A list of variables that are 'means' and a list of variables that are
    standard deviations, 'std', are produced, combined, and then ordered.
9. The ordered list of variable 'means' and 'std's is used to subset the
    'data' data.frame so only variables that are means or standard deviations
    remain in the data.frame.
10. The 'data' data.frame is then split by ID and activity into a large list
    of 180 objects. Each object contain data for a single combination of
    ID/activity.
11. The mean of each variable in each object of the large list is computed
    using lapply() function and returned in a list called 'means'.
12. The 'means' list is converted into a data.frame and then transposed
    because the conversion from list to data.frame swapped rows and columns.
    Transposing the data.frame swaps rows and columns again, so that the
    measured body-motion variables are columns again, and the ID/activity
    are rows again.
13. The columns of data and the variable names are formatted to produce a tidy
    data table by determining which is longer, the variable name or the data
    values, and then using that length as the width for the output table
    columns.
14. The data.frame with the averages of all the 'mean' and 'std' variables 
    for each combination of ID/acitivity is then printed to a table in text
    format, called 'Body_Motion_Means.txt'.
    
##################### Description of output ####################################

The Body_Motion_Means.txt file contains 79 columns of data, 1 for each
    measured body-motion that is either a 'mean' or 'std'. Column names
    indicate the exact body-motion type as originally described in the
    features_info.txt file.
    
Each row in the Body_Motion_Means.txt file corresponds to a combination
    of subject_ID/Activity as indicated in the row name. For example,
    X16.LAYING indicates this row contains data for subject 16 while laying.
    There are 180 cominations of ID/Activity, hence 180 rows of data.



