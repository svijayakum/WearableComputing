
## read in the 6 diff text file 
setwd(dir = "E:/DataScientistCertification/Getting and Cleaning Data/CourseProject")
subj_test = read.table("subject_test.txt",sep = "")
subj_train = read.table("subject_train.txt",sep="")
X_test = read.table("X_test.txt",sep="")
X_train = read.table("X_train.txt",sep="")
y_test = read.table("y_test.txt",sep="")
y_train = read.table("y_train.txt",sep="")

#1.	Merges the training and the test sets to create one data set.
subject = rbind(subj_test,subj_train)
X = rbind(X_test,X_train)
y = rbind(y_test,y_train)


#2.	Extracts only the measurements on the mean and standard deviation for each measurement.
features = read.table("features.txt", sep="")
names = features$V2
colnames(X) = names
meancols = grep("mean",features$V2) # lists out the mean rows
stdcols = grep("std",features$V2) # lists out the std rows
# Extract mean and standard columns then combine
meanstdX = cbind(X[,meancols],X[,stdcols])

# 3.	Uses descriptive activity names to name the activities in the data set.
activitylabels = read.table("activity_labels.txt", sep="")
y[["V1"]] = activitylabels[match(y[["V1"]],activitylabels[["V1"]]),'V2']

#4.	Appropriately labels the data set with descriptive variable names
colnames(subject)= "subject"
colnames(y)= "activity"
# Merging subjects, activitys &  measurements
meanstd = cbind(subject,y,meanstdX)
names(meanstd) = tolower(names(meanstd))
names(meanstd) = gsub("-"," ",names(meanstd))
names(meanstd) = gsub("\\(|\\)","",names(meanstd))


# 5.	From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.
library(plyr)
average = ddply(meanstd,.(subject,activity),numcolwise(mean)) 
write.table(average, file = "mean_subject_activity.txt", row.names = FALSE)
