library(dplyr)
library(data.table)

# Downloading the training and test sets 
###############################################################################

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,'HARDataset.zip')
unzip('HARDataset.zip')
path_rf <- file.path("./UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

# Reading the training and test sets
###############################################################################
# subject data

subtest <- read.table(file.path(path_rf, "test" , "subject_test.txt" ),header = FALSE)
subtrain <- read.table(file.path(path_rf, "train" , "subject_train.txt" ),header = FALSE)

# activity data

activitytest <- read.table(file.path(path_rf, "test" , "y_test.txt" ),header = FALSE)
activitytrain <- read.table(file.path(path_rf, "train" , "y_train.txt" ),header = FALSE)

# features data

featuretest <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
featuretrain <- read.table(file.path(path_rf, "train" , "X_train.txt" ),header = FALSE)

# Merge the training and test sets to create one data set
###############################################################################

#subj data
subjData <- rbind(subtrain,subtest) 
names(subjData) <- c("subject") # header

#activity data
activityData <- rbind(activitytrain,activitytest)
names(activityData) <- c("activityID") #header

#feature data
featuresData <- rbind(featuretrain,featuretest)
FeaturesNames <- tbl_df(read.table(file.path(path_rf, "features.txt"),head=FALSE))
#adding the headers to the features Data
setnames(FeaturesNames,names(FeaturesNames),c("featureID","featureName"))
colnames(featuresData) <- FeaturesNames$featureName

#activity labels
activityLabels <- read.table(file.path(path_rf,"activity_labels.txt"))
setnames(activityLabels, names(activityLabels), c("activityID","activityName"))


# combinging all to get data on (A)ctivities on (D)aily (L)iving
data = cbind(subjData,activityData)
ADL_data <- cbind(data,featuresData)



#Extracts only the measurements on  mean and standard deviation for each measurement.
###############################################################################
EntriesWithMeanstd <- grep("mean\\(\\)|std\\(\\)",FeaturesNames$featureName,value=TRUE) 
# adding subject and activity ID to the entries
EntriesWithMeanstd  <- union(c("subject","activityID"), EntriesWithMeanstd)  
ADL_data <- subset(ADL_data,select = EntriesWithMeanstd)


#Uses descriptive activity names to name the activities in the data set
###############################################################################
ADL_data <- merge(activityLabels, ADL_data , by="activityID", all.x=TRUE)
ADL_data$activityName <- as.character(ADL_data$activityName)

# 
#Appropriately labels the data set with descriptive variable names.
names(ADL_data)<-gsub("std()", "StdDev", names(ADL_data))
names(ADL_data)<-gsub("mean()", "Mean", names(ADL_data))
names(ADL_data)<-gsub("^t", "time", names(ADL_data))
names(ADL_data)<-gsub("^f", "frequency", names(ADL_data))
names(ADL_data)<-gsub("[Gg]ravity", "gravity", names(ADL_data))
names(ADL_data)<-gsub("Acc", "Accelerometer", names(ADL_data))
names(ADL_data)<-gsub("Gyro", "Gyroscope", names(ADL_data))
names(ADL_data)<-gsub("Mag", "Magnitude", names(ADL_data))
names(ADL_data)<-gsub("[Bb]odyaccjerkmag)","BodyAccJerkMagnitude", names(ADL_data))
names(ADL_data)<-gsub("JerkMag","JerkMagnitude", names(ADL_data))
names(ADL_data)<-gsub("BodyBody", "Body", names(ADL_data))




#average of each variable for each activity and each subject.
###############################################################################
datatmp<- aggregate(. ~ subject - activityName, data = ADL_data, mean) 
#sorting 
ADL_data<- tbl_df(arrange(datatmp,subject,activityName))


#writing an independent tidy dat set
###############################################################################
write.table(ADL_data, "ADL_tidydata.txt", row.name=FALSE)