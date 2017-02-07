# getting-cleaning-data-assignment

Instructions for the peer-graded assignment Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 

	1) a tidy data set as described below, 
	2) a link to a Github repository with your script for performing the analysis, and 
	3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 

You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

	1. Merges the training and the test sets to create one data set.
	2. Extracts only the measurements on the mean and standard deviation for each measurement.
	3. Uses descriptive activity names to name the activities in the data set
	4. Appropriately labels the data set with descriptive variable names.
	5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Review criteria:
 
	1. The submitted data set is tidy.
	2. The Github repo contains the required scripts.
	3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
	4. The README that explains the analysis files is clear and understandable.
	5. The work submitted for this project is the work of the student who submitted it.
	
# Explains how the scripts work and how they are connected

The run_analysis script contains the procedures to get and clean the Human Activity Recognition Data Set. The first step is to load the necessary data from from files. This is done through the data.table function (fread). Next, it is necessary to combine the data considering its dimensions. Each volunteer performed six actions which results on raw signals tAcc-XYZ and tGyro-XYZ. These raw signals are derived in various steps to reach 561 extracted features, thus each action performed has 561 extracted features. On the combined data set, each row should contain information of a volunteer, his action and the features extracted for that action. The variable names should be descriptive, as also the actions names. 
It is required that the trainning and test volunteer dataset are merged together, and to create a final tidy data set which includes the average values for all activities performed by each volunteer and only selected mean/std derived features. All steps performed to reach the final goal are described below:

First load libraries which will give especial functions to manipulate data 
```{r}
        # load data.table and dplyr to use some of its functions
        library(data.table)
        library(dplyr)
```

Load necessary data, activities and features names. The process is done faster using fread function and is not necessary to consider a delimiter character. There is no file header, so it is decided to give column names
```{r}
        # Reading activities and features data from Human Activity Recognition Data Set
        activities <- fread("activity_labels.txt", header = FALSE, col.names = c("id", "activity"))
        features <- fread("features.txt", header = FALSE, col.names = c("id", "feature"))
```

Load necessary data, activities performed by volunteers of training and test sets along volunteers id. The activities are identified by labels (id collumn content read from "activity_labels.txt")
```{r}
        # Reading performed acitivities labels of the training and test sets carried out by each volunteer and also, 
        # reading the id of the volunteers
        trainVolunteerActions <- fread("./train/y_train.txt", header = FALSE, col.names = "action")
        trainVolunteerIDs <- fread("./train/subject_train.txt", header = FALSE, col.names = "volunteerID")
        testVolunteerActions <- fread("./test/y_test.txt", header = FALSE, col.names = "action")
        testVolunteerIDs <- fread("./test/subject_test.txt", header = FALSE, col.names = "volunteerID")
```

Combining volunteerID and action collumns to adjust each volunteer along his performed actions. It is created only one data set by merging training and test data. Also, removed unnecessary variables to release memory
```{r}
        # Binding together volunteerID and action collumns for training and test sets, also binding the two sets rows to
        # form only one
        testList <- dplyr::bind_cols(testVolunteerIDs, testVolunteerActions)
        rm(testVolunteerIDs, testVolunteerActions)
        trainList = dplyr::bind_cols(trainVolunteerIDs, trainVolunteerActions)
        rm(trainVolunteerIDs, trainVolunteerActions)
        volunteerActionsList = dplyr::bind_rows(testList, trainList)
        rm(testList, trainList)
```

Whem reading X_test.txt and X_train.txt files it is possible to note that refers to the 561 extracted features for each activity, since the combined number of rows (10299 observations) match with  volunteerActionsList rows (data set with all volunteers and theirs performed actions). The volunteerFeatures will include the combined test and training features data. The merging process considers the necessary order to combine data at next steps, that is, first extracted test features and then extracted training features
```{r}
        # Reading the training and test sets and binding it to create one data set, also setting features names
        testSet <- fread("./test/X_test.txt", header = FALSE)
        trainSet <- fread("./train/X_train.txt", header = FALSE)
        volunteerFeatures = dplyr::bind_rows(testSet, trainSet)
        rm(testSet, trainSet)
```

Combine volunteerActionsList and volunteerFeatures to form a data set which includes each volunteer, his performed actions and extracted features for each action
```{r}
        # Using merged training and test data of correspondents volunteerActionsList and volunteerFeatures to create one data set 
        humamActivityRecognition <- dplyr::bind_cols(volunteerActionsList, volunteerFeatures)
        rm(volunteerActionsList, volunteerFeatures)

```
Sets names to features variables. Filter the data set collumns to include only features related with measures of mean and standard deviation using 'grepl' function. There are features with duplicated names which causes error when using 'select' function, thus it is used the 'make.unique' function to distintique name all features. 
```{r}
        # Extracts only the measurements on the mean and standard deviation for each measurement. 
        # First, resolve duplicated names to use select function to retriev  mean and standard deviation variables
        names(humamActivityRecognition)[3:length(humamActivityRecognition)] <- make.unique(features$feature)
        selectedMeasurement <- grepl("mean|std", names(humamActivityRecognition), ignore.case = T)
        humamActivityRecognition <- select(humamActivityRecognition, volunteerID, action, which(selectedMeasurement))
```

Merging data with activities labels and activities names. By doing so, it is possible to replace activities labels (in numbers) with activities names ( descriptive character names). The data set merged is sorted considering volunteerID collumn. Also, it is select only volunteerID and activity collumns along all features variables to form a new descriptive data set 
```{r}
        # Uses descriptive activity names to name the activities in the data set, so merge activities labels set with activities names set
        # select volunteerID and activity names collumns to form a new descriptive data set along all features variables
        humamActivityRecognition <- merge(humamActivityRecognition, activities, by.x = "action", by.y = "id")
        humamActivityRecognition <- arrange(humamActivityRecognition, volunteerID)
        selectedMeasurement <- grepl("mean|std", names(humamActivityRecognition), ignore.case = T)
        humamActivityRecognition <- dplyr::select(humamActivityRecognition, volunteerID, activity, which(selectedMeasurement))
```

Excluding character '-' and "()" to possible create  more descriptive variable names. This is done using 'gsub' function and regular expressions. Obs: Perhaps the characters "()" should be mantained because gives the idea of applyed functions, which is, in essence, how the extracted features observations values are acquired  
```{r}
        # Appropriately labels the data set with descriptive variable names
        names(humamActivityRecognition) <- gsub("-","", names(humamActivityRecognition))
        names(humamActivityRecognition) <- gsub("\\s*\\(+\\)","", names(humamActivityRecognition))
```

Use advanced functions to group volunteerID and his activities and sumarize the values to reach the average of features observations. This will produce for each volunteer action (six on total) the average values of features observations (86 average values for with action). Finally, the tidy data set is written to a csv file that can be rendered by git hub (use sep = ',')
```{r}
        # Creates a second, independent tidy data set with the average of each variable for each activity and each subject
        tidydataSet <- group_by(humamActivityRecognition, volunteerID, activity) %>% summarise_each(funs(mean))
        
        fwrite(tidydataSet, file = "tidydataset.csv", row.names = F, col.names = T, sep = ",")
```
