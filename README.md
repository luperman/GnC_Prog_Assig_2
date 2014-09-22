#Coursera Data Science Specialisation
================

##Programming Assignment #2 (Course project)  

This repository was created as requested by the programming assignment of the course "Getting and Cleaning data" which is part of the data science specialisation from John Hopkins University hosted by Coursera.

The original dataset is part of the UC Irvine Machine Learning Repository which can be found on the UCI archive: http://archive.ics.uci.edu/ml/

The programming assignment required the student to create one R script called run_analysis.R that does the following:
 
1- Merges the training and the test sets to create one data set.
2- Extracts only the measurements on the mean and standard deviation for each measurement. 
3- Uses descriptive activity names to name the activities in the data set
4- Appropriately labels the data set with descriptive variable names. 
5- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Description of run_analysis.R  

- The script should be executed with the work directory pointing to the same directory where the UCI HAR dataset folder is located.

## List of objects used:  

training_data: loads X_train.txt from the UCI HAR Dataset and later is used to merge training_activity_number and training_subject.
training_activity_number: loads Y_train.txt from the UCI HAR Dataset.
training_subject: loads subject_train.txt from the UCI HAR Dataset.

testing_data: loads X_test.txt from the UCI HAR Dataset and later is used to merge training_activity_number and training_subject.
testing_activity_number: loads Y_test.txt from the UCI HAR Dataset.
testing_subject: loads subject_test.txt from the UCI HAR Dataset.

full_dataset:  Merges training_data and testing_data to create one dataset

feature_names: loads features.txt from the UCI HAR Dataset, later it is used to remove non-alphanumeric chars from the original variable names as requested by question #4 (Appropriately labels the data set with descriptive variable names).

cols_mean_std: Finds all the mean and standard deviation col numbers and serves as filter to remove unwanted variables from feature_names.

Question_5: variable used to generate the tidy dataset as required on question #5.

##Full code explained:
================

#### Load and merge data.

training_data <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)  
training_activity_number = read.csv("./UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)  
training_subject = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)  
training_data<-cbind(training_data, training_activity_number,training_subject)  

testing_data = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)  
testing_activity_number = read.csv("./UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)   
testing_subject = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)  
testing_data<-cbind(testing_data, testing_activity_number,testing_subject)  

#### Merge training_data and testing_data to create one dataset.  

full_dataset <- rbind(training_data, testing_data)  

#### Loading and cleaning feature names (remove non alphanumeric chars).  

feature_names <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)  
feature_names[,1]<-NULL  
feature_names[,1] = gsub("[*(*|*)*]", "", feature_names[,1])  
feature_names[,1] = gsub("-|,", "", feature_names[,1])  
feature_names<-rbind(feature_names,c("Activity"))  
feature_names<-rbind(feature_names,c("Subject"))  

#### Find all the mean and standard deviation col numbers.  

cols_mean_std <- grep(".*mean.*|.*std.*", feature_names[,1],ignore.case = TRUE)  
cols_mean_std  <- c(cols_mean_std, 562, 563)  

#### Remove all unwanted features using cols_mean_std.  

feature_names <- as.data.frame(feature_names[cols_mean_std,])  
feature_names<-cbind(cols_mean_std,feature_names)  

#### Set easy names on feature_names dataframe.  

colnames(feature_names)<-c("col_number", "feature_name")  

#### Remove unwanted columns from full_dataset.  

full_dataset <- full_dataset[,cols_mean_std]  

#### Label full_dataset with descriptive variable names (features).  

colnames(full_dataset) <- feature_names$feature_name  

#### Read activity names.  

activity_names <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)  

#### Replace activity number for activity name in full_dataset.  

for (i in 1:6) {  
        full_dataset$Activity <- gsub(i, activity_names$V2[i], full_dataset$Activity)  
}  
full_dataset$Activity <- as.factor(full_dataset$Activity)  
full_dataset$Subject <- as.factor(full_dataset$Subject)  

#### Calculating mean for Question 5.  

library(stats)  
Question_5 <- aggregate(full_dataset, by=list(Activity_name = full_dataset$Activity, Subject_number=full_dataset$Subject), mean)  

#### Removing factor columns (NA's).  

Question_5<-Question_5[1:88]  

#### Reordering  

Question_5<-Question_5[,c(2,1,3:88)]  

#### Writing the final dataset.  

write.table(Question_5, "Question_5.txt", sep="," ,row.names = FALSE)  


### Credits:  

Human Activity Recognition Using Smartphones Dataset  
Version 1.0  
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.  
Smartlab - Non Linear Complex Systems Laboratory  
DITEN - Università degli Studi di Genova.  
Via Opera Pia 11A, I-16145, Genoa, Italy.  
activityrecognition@smartlab.ws  
www.smartlab.ws  