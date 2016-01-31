Code Book for run_analysis.R script 
==================================================================
==================================================================
#### The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

#####For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### Analysis Steps
* Read the training and test data set from the specified location into tables using read.table .
  Assign the coloumn headers. Merge all the files row wise using rbind to create one data table (ADL_data)
* Using the grep command to extract the measurements on "mean and std" from the features table and store it in the variable "EntriesWithMeanstd". 
  Then subset the data with the entries selected from the ADL_data
* Merge the ADL_data dataset with activity labels by activity ID
* Appropiately labels the data set with descriptive variable names using gsub i.e to give meaningful names
* Now creating a dataset with average of each variable for each activity and each subject and sorted based on subject and activity
* Finally,writing the dataset to text file
