#CodeBook
This code book describes the variables, data, and any transformations performed to clean up the smartphones data.

##The data source

+ Original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
+ Original description of the dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


##Experiment and data description

+ The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

+ The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

##Data

For each record it is provided:

+ Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.  
+ Triaxial Angular velocity from the gyroscope.  
+ A 561-feature vector with time and frequency domain variables.  
+ Its activity label.  
+ An identifier of the subject who carried out the experiment.

This dataset includes the following files:

+ README.txt
+ features_info.txt - Shows information about the variables used on the feature vector.
+ features.txt- List of all features.
+ activity_labels.txt - Links the class labels with their activity name.
+ train/X_train.txt - Training set.
+ train/y_train.txt - Training labels.
+ test/X_test.txt - Test set.
+ test/y_test.txt - Test labels.

The following files are available for the train and test data. Their descriptions are equivalent.

+ train/subject_train.txt - Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.  
+ train/Inertial Signals/total_acc_x_train.txt - The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.  
+ train/Inertial Signals/body_acc_x_train.txt - The body acceleration signal obtained by subtracting the gravity from the total acceleration.  
+ train/Inertial Signals/body_gyro_x_train.txt - The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.


##Variables

+ The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

+ Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

+ Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

+ These signals were used to estimate variables of the feature vector for each pattern -'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.


##Transformations

There are 5 parts to this project:

*1. Merges the training and the test sets to create one data set.*  
+ Read in all the test and training files: subject_test.txt, subject_train.txt, X_test.txt, X_train.txt, y_test.txt, y_train.txt. The Script assumes that the files have already been unzipped and placed in a folder called "getting_and_cleaning_data".It also assumes that the 6 text files listed above, features.txt & activities.txt files have been moved out of the UCI HAR Dataset folder into the main "getting_and_cleaning_data" folder. The working directory is set then files are read in using read.table.

```{r}
setwd(dir = ".")
subj_test = read.table("subject_test.txt",sep = "")
subj_train = read.table("subject_train.txt",sep="")
X_test = read.table("X_test.txt",sep="")
X_train = read.table("X_train.txt",sep="")
y_test = read.table("y_test.txt",sep="")
y_train = read.table("y_train.txt",sep="")

```

+ Combine the test and training sets. I interpreted this step as wanting us to create one data set for each of thefile type. The “subject” data set contains the combined test and training set for the subjects. The “X” data set contains the combined test and training set for the measurements. The “y” data set contains the combined test and training set for the activities performed. 

```{r}
subject = rbind(subj_test,subj_train)
X = rbind(X_test,X_train)
y = rbind(y_test,y_train)

```
*2. Extracts only the measurements on the mean and standard deviation for each measurement.*  
+ Read the features from features.txt. Then assign the measurement names to the “X” data set. List out the measurements that contain either “meancols” or “stdcols”. For this assignment I included all mean and standard deviations for each measurement including meanFreq. Extract the desired mean and std columns and combine to create a data set for the desired measurements(meanstdX).

```{r}
features = read.table("features.txt", sep="")
names = features$V2
colnames(X) = names
meancols = grep("mean",features$V2) # lists out the mean rows
stdcols = grep("std",features$V2) # lists out the std rows
# Extract mean and standard columns then combine
meanstdX = cbind(X[,meancols],X[,stdcols])

```

*3. Uses descriptive activity names to name the activities in the data set*  
+ Read in the activity labels from activity_labels.txt and replace the activity numbers with the text.

```{r}
activitylabels = read.table("activity_labels.txt", sep="")
y[["V1"]] = activitylabels[match(y[["V1"]],activitylabels[["V1"]]),'V2']

```


*4. Appropriately labels the data set with descriptive activity names.*  
+ Assign column names for “subject” and “y” data sets and combine with the “meanstdX” dataset to create the “meanstd” data set. Tidy the colnames by removing all non-alphanumeric characters and converting the result to lowercase.

```{r}
colnames(subject)= "subject"
colnames(y)= "activity"
# Merging subjects, activitys &  measurements
meanstd = cbind(subject,y,meanstdX)
names(meanstd) = tolower(names(meanstd)) #converting all col names to lower case
names(meanstd) = gsub("-"," ",names(meanstd)) ## removing all "-"
names(meanstd) = gsub("\\(|\\)","",names(meanstd)) ## removing all "()"

```
*5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.*  
+ Create a new data frame by finding the mean for each variable for each activity and each subject. This was done by using ddply. The plyr package needs to be loaded beforehand but the script accounts for this.

```{r}
library(plyr)
average = ddply(meanstd,.(subject,activity),numcolwise(mean))

```
*Final step:*  
+ Write the new data set into a text file called mean_subject_activity.txt. The final dimension for this dataset are 180 rows and 81 columns.

```{r}
write.table(average, file = "mean_subject_activity.txt")

```

