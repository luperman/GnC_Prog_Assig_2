#load train / test data and combine all in one dataset. 

training_data <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training_activity_number = read.csv("./UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training_subject = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
training_data<-cbind(training_data, training_activity_number,training_subject)

testing_data = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testing_activity_number = read.csv("./UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testing_subject = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
testing_data<-cbind(testing_data, testing_activity_number,testing_subject)

#Merge training_data and testing_data to create one dataset
full_dataset <- rbind(training_data, testing_data)

#Loading and cleaning feature names (remove non alphanumeric chars)
feature_names <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
feature_names[,1]<-NULL
feature_names[,1] = gsub("[*(*|*)*]", "", feature_names[,1])
feature_names[,1] = gsub("-|,", "", feature_names[,1])
feature_names<-rbind(feature_names,c("Activity"))
feature_names<-rbind(feature_names,c("Subject"))

# Find all the mean and standard deviation col numbers.
cols_mean_std <- grep(".*mean.*|.*std.*", feature_names[,1],ignore.case = TRUE)
cols_mean_std  <- c(cols_mean_std, 562, 563)

#Remove all unwanted features using cols_mean_std
feature_names <- as.data.frame(feature_names[cols_mean_std,])
feature_names<-cbind(cols_mean_std,feature_names)

#Set easy names on feature_names dataframe
colnames(feature_names)<-c("col_number", "feature_name")

#remove unwanted columns from full_dataset
full_dataset <- full_dataset[,cols_mean_std]

# label full_dataset with descriptive variable names (features).
colnames(full_dataset) <- feature_names$feature_name

#read activity names
activity_names <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

#Replace activity number for activity name in full_dataset
for (i in 1:6) {
        full_dataset$Activity <- gsub(i, activity_names$V2[i], full_dataset$Activity)
}
full_dataset$Activity <- as.factor(full_dataset$Activity)
full_dataset$Subject <- as.factor(full_dataset$Subject)

#Calculating mean for Question 5
library(stats)
Question_5 <- aggregate(full_dataset, by=list(Activity_name = full_dataset$Activity, Subject_number=full_dataset$Subject), mean)

#Removing factor columns (NA's)
Question_5<-Question_5[1:88]

#Reordering
Question_5<-Question_5[,c(2,1,3:88)]

#Writing the final dataset
write.table(Question_5, "Question_5.txt", sep="," ,row.names = FALSE)