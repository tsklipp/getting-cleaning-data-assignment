# Dataset Source
 Human Activity Recognition Using Smartphones Dataset - Version 1.0  
 Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto  
 Smartlab - Non Linear Complex Systems Laboratory  
 DITEN - Università degli Studi di Genova  
 Via Opera Pia 11A, I-16145, Genoa, Italy  
 activityrecognition@smartlab.ws www.smartlab.ws 

# Data information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The original dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

# Original feature selection and tranformations 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

|					|					  |
|:-----------------:|:-------------------:|
|tBodyAcc-XYZ | tBodyAccMag|
|tBodyAccJerk-XYZ | tBodyAccJerkMag|
|tBodyGyro-XYZ | tBodyGyroMag|
|tBodyGyroJerk-XYZ | tBodyGyroJerkMag|
|tGravityAcc-XYZ | tGravityAccMag|
|fBodyAcc-XYZ | fBodyAccMag|
|fBodyAccJerk-XYZ | fBodyAccJerkMag|

|				 |				 |				   |
|:--------------:|:-------------:|:---------------:|
|fBodyGyro-XYZ | fBodyGyroMag | fBodyGyroJerkMag|

The set of variables that were estimated from these signals are: 

variable | description
:------------: | :----------------------------------------------------------------------:
mean() 		 | Mean value
std()		 | Standard deviation
mad()		 | Median absolute deviation 
max()		 | Largest value in array
min()		 | Smallest value in array
sma()		 | Signal magnitude area
energy()	 | Energy measure. Sum of the squares divided by the number of values. 
iqr()		 | Interquartile range 
entropy()    | Signal entropy
arCoeff()    | Autorregresion coefficients with Burg order equal to 4
correlation()| correlation coefficient between two signals
maxInds()	 | index of the frequency component with largest magnitude
meanFreq()   | Weighted average of the frequency components to obtain a mean frequency
skewness()   | skewness of the frequency domain signal 
kurtosis()   | kurtosis of the frequency domain signal 
bandsEnergy()| Energy of a frequency interval within the 64 bins of the FFT of each window.
angle()      | Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

|					|
|:-----------------:|
|gravityMean|
|tBodyAccMean|
|tBodyAccJerkMean|
|tBodyGyroMean|
|tBodyGyroJerkMean|

The complete list of variables of each feature vector is available in 'features.txt'

## Describing the variables, the data, and any transformations or work procedures done to modify and update available data

Work applied on the original data set with loading, cleaning and transform operations

Below are listed the libraries and functions used:

|Library	 |	Functions	           |
|:--------------:|:-----------------------------:|
|data.table |  fread, merge|
|dplyr |arrange, bind_rows, bind_cols, funs, group_by, select, summarise_each|
|base  |make.unique, mean, names, gsub, grepl, rm|

Below are listed all variables created to load data from files when executing run_analysis.R

 activities: created to store data loaded from  "activity_labels.txt" file
 
         ``` 
        str(activities)
        Classes ‘data.table’ and 'data.frame':	6 obs. of  2 variables:
         $ id      : int  1 2 3 4 5 6
         $ activity: chr  "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" ...
        ```          
        
 features: created to store data loaded from  "features.txt" file
 
         ``` 
        str(features)
        Classes ‘data.table’ and 'data.frame':	561 obs. of  2 variables:
         $ id     : int  1 2 3 4 5 6 7 8 9 10 ...
         $ feature: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...
         ```         
         
 trainVolunteerActions: created to store data loaded from  "y_train.txt" file
 
        ```  
        str(trainVolunteerActions)
        Classes ‘data.table’ and 'data.frame':	7352 obs. of  1 variable:
         $ action: int  5 5 5 5 5 5 5 5 5 5 ...
        ```          
        
 trainVolunteerIDs: created to store data loaded from  "subject_train.txt" file
 
        ```  
        str(trainVolunteerIDs)
        Classes ‘data.table’ and 'data.frame':	7352 obs. of  1 variable:
         $ volunteerID: int  1 1 1 1 1 1 1 1 1 1 ...
        ``` 
        
 testVolunteerActions: created to store data loaded from  "y_test.txt" file
 
         ```  
        str(testVolunteerActions)
        Classes ‘data.table’ and 'data.frame':	2947 obs. of  1 variable:
         $ action: int  5 5 5 5 5 5 5 5 5 5 ...
        ```  
 testVolunteerIDs: created to store data loaded from  "subject_test.txt" file
 
 
        ```  
        str(testVolunteerIDs)
        Classes ‘data.table’ and 'data.frame':	2947 obs. of  1 variable:
         $ volunteerID: int  2 2 2 2 2 2 2 2 2 2 ...         
         ``` 
         
  testSet: created to store data loaded from  "X_test.txt" file
  
        ```   
        str(testSet, list.len = 3)
        Classes ‘data.table’ and 'data.frame':	2947 obs. of  561 variables:
         $ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
         $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
         $ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
          [list output truncated]
        ``` 
        
  trainSet: created to store data loaded from  "X_train.txt" file
  
        ```   
        str(trainSet, list.len = 3)
        Classes ‘data.table’ and 'data.frame':	7352 obs. of  561 variables:
         $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
         $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
         $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
          [list output truncated]
        ```           
        
Below are listed all variables created to merge data from above variables
         
  testList: contains merged collumns (using bind_cols) of testVolunteerIDs and testVolunteerActions
  
        ```   
        str(testList)
        Classes ‘data.table’ and 'data.frame':	2947 obs. of  2 variables:
         $ volunteerID: int  2 2 2 2 2 2 2 2 2 2 ...
         $ action     : int  5 5 5 5 5 5 5 5 5 5 ...
        ```          
        
  trainList: contains merged collumns (using bind_cols) of trainVolunteerIDs and trainVolunteerActions
  
         ```  
        str(trainList)
        Classes ‘data.table’ and 'data.frame':	7352 obs. of  2 variables:
         $ volunteerID: int  1 1 1 1 1 1 1 1 1 1 ...
         $ action     : int  5 5 5 5 5 5 5 5 5 5 ...
        ```          
        
  volunteerActionsList: contains merged rows (using bind_rows) of trainList and testList
  
        ```   
        str(volunteerActionsList)
        Classes ‘data.table’ and 'data.frame':	10299 obs. of  2 variables:
         $ volunteerID: int  2 2 2 2 2 2 2 2 2 2 ...
         $ action     : int  5 5 5 5 5 5 5 5 5 5 ...       
        ```         
        
  volunteerFeatures: contains merged rows (using bind_rows) of testSet and trainSet
  
        ```   
        str(volunteerFeatures, list.len = 3)
        Classes ‘data.table’ and 'data.frame':	10299 obs. of  561 variables:
         $ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
         $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
         $ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
        ``` 
        
  humamActivityRecognition: contains merged columns (using bind_cols) of volunteerActionsList and volunteerFeatures
  
        ``` 
        str(humamActivityRecognition, list.len =3)
        Classes ‘data.table’ and 'data.frame':	10299 obs. of  563 variables:
         $ volunteerID: int  2 2 2 2 2 2 2 2 2 2 ...
         $ action     : int  5 5 5 5 5 5 5 5 5 5 ...
         $ V1         : num  0.257 0.286 0.275 0.27 0.275 ...
          [list output truncated]
        ```
        
Below are listed all operations realized on data from above variables

  * Sets names to features variables from stored names on features$feature. Obs: resolve duplicated names with make.unique function
  
        ```{r}
        names(humamActivityRecognition)[3:length(humamActivityRecognition)] <- make.unique(features$feature)
        ```
        
  * Select only the measurements on the mean and standard deviation for each feature measurement
  
        ```{r}
        selectedMeasurement <- grepl("mean|std", names(humamActivityRecognition), ignore.case = T)
        humamActivityRecognition <- select(humamActivityRecognition, volunteerID, action, which(selectedMeasurement))
         ```     
         
  * merge activities labels with activities names sets:
  
        ```{r}
        humamActivityRecognition <- merge(humamActivityRecognition, activities, by.x = "action", by.y = "id")
        ```     
        
  * sort humamActivityRecognition to correct arrange volunteers through id
  
        ```{r}
        humamActivityRecognition <- arrange(humamActivityRecognition, volunteerID)
        ```     
        
  * select only volunteerID, activity and all feature collumns to form a new descriptive data set:
        selectedMeasurement <- grepl("mean|std", names(humamActivityRecognition), ignore.case = T)
        
        ```{r}
        humamActivityRecognition <- dplyr::select(humamActivityRecognition, volunteerID, activity, which(selectedMeasurement))
        ```     
        
  * Appropriately labels the data set with descriptive variable names
  
        ```{r}
        names(humamActivityRecognition) <- gsub("-","", names(humamActivityRecognition))
        names(humamActivityRecognition) <- gsub("\\s*\\(+\\)","", names(humamActivityRecognition))
         ```     
         
  * humamActivityRecognition will become:
  
        ```
         str(humamActivityRecognition, list.len = 5)
        'data.frame':	10299 obs. of  88 variables:
         $ volunteerID                         : int  1 1 1 1 1 1 1 1 1 1 ...
         $ activity                            : chr  "WALKING" "WALKING" "WALKING" "WALKING" ...
         $ tBodyAccmeanX                       : num  0.282 0.256 0.255 0.343 0.276 ...
         $ tBodyAccmeanY                       : num  -0.0377 -0.06455 0.00381 -0.01445 -0.02964 ...
         $ tBodyAccmeanZ                       : num  -0.1349 -0.0952 -0.1237 -0.1674 -0.1426 ...
          [list output truncated]
         - attr(*, ".internal.selfref")=<externalptr> 
         - attr(*, "sorted")= chr "action"
        ```
        
 Creates a second, independent tidy data set with the average of each variable for each activity and each subject
 
        ```{r}
         tidydataSet <- group_by(humamActivityRecognition, volunteerID, activity) %>% summarise_each(funs(mean))        
        ```
        
# The final tidy data set description, genareted with 'prompt' function, it was as follows:


