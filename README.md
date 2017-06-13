# Files in this repo  
README.md – This is the README.md  
CodeBook.md - Describes variables, data and the transformations performed  
run_analysis.R - actual R code 
 
## Purpose of run_analysis.R 
Create an R script called run_analysis.R that does the following:    
1. Merges the training and the test sets to create one data set.    
2. Extracts only the measurements on the mean and standard deviation for each measurement.    
3. Uses descriptive activity names to name the activities in the data set    
4. Appropriately labels the data set with descriptive activity names.  
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

It should run in a folder called getting_and_cleaning_data (ie I created a getting_and_cleaning_data folder in my working directory) The script assumes that the working directory has the following files(ie I moved these files form the zip folder into the getting_and_cleaning_data folder):
+    activity_labels.txt
+    features.txt
+    subject_test.txt
+    subject_train.txt
+    X_test.txt
+    X_train.txt
+    y_test.txt
+    y_train.txt

These files can be obtained from the following location - https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The output is created in working directory with the name mean_subject_activity.txt

## The Script    

Purpose step by step:

**Step 1:**
+ Read in all the test and training files: subject_test.txt, subject_train.txt, X_test.txt, X_train.txt, y_test.txt, y_train.txt
+ Combine the test and training sets. I interpreted this step as wanting us to create one data set for each of the file type. The “subject” data set contains the combined test and training set for the subjects. The “X” data set contains the combined test and training set for the measurements. The “y” data set contains the combined test and training set for the activities performed. 

**Step 2:**
+ Read the features from features.txt. Then assign the measurement names to the “X” data set.  
+ List out the measurements that contain either “meancols” or “stdcols”. For this assignment I included all mean and standard deviations for each measurement including meanFreq. 
+ Extract the desired mean and std columns and combine to create a data set for the desired measurements(meanstdX).

**Step 3:**
+ Read in the activity labels from activity_labels.txt and replace the activity numbers with the text.

**Step 4:**
+ Assign column names for “subject” and “y” data sets and combine with the “meanstdX” dataset to create the “meanstd” data set.
+ Tidy the colnames by removing all non-alphanumeric characters and converting the result to lowercase.

**Step 5:**
+ Create a new data frame by finding the mean for each variable for each activity and each subject.  This was done by using ddply. 
+ The plyr package needs to be loaded beforehand but the script accounts for this.

**Final step:**
+ Write the new data set into a text file called mean_subject_activity.txt. The final dimension for this dataset are 180 rows and 81 columns.
