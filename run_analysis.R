# This rscript contains the procedures to get and clean the Human Activity Recognition Using Smartphones Data Set
# The first step is to load the necessary data from from files. Next, it is necessary to combine the data considering 
# its dimensions. Each volunteer performed six actions which results on raw signals tAcc-XYZ and tGyro-XYZ. These raw
# signals are derived in various steps to reach 561 extracted features, so each action performed has 561 extracted features.
# It is required that the train and test volunteer dataset are merged together, and to create a final tidy data set which
# includes the average values for all activities performed by each volunteer and only selected mean/std derived features 

# load data.table and dplyr to use some of its functions
library(data.table)
library(dplyr)

# Reading activities and features data from Human Activity Recognition Data Set (use fread to speed up this process)
activities <- fread("activity_labels.txt", header = FALSE, col.names = c("id", "activity"))
features <- fread("features.txt", header = FALSE, col.names = c("id", "feature"))

# Reading performed acitivities labels of the training and test sets carried out by each volunteer and also, reading
# the id of the volunteers
trainVolunteerActions <- fread("./train/y_train.txt", header = FALSE, col.names = "action")
trainVolunteerIDs <- fread("./train/subject_train.txt", header = FALSE, col.names = "volunteerID")
testVolunteerActions <- fread("./test/y_test.txt", header = FALSE, col.names = "action")
testVolunteerIDs <- fread("./test/subject_test.txt", header = FALSE, col.names = "volunteerID")

# Binding together volunteerID and action collumns for training and the test sets, also binding the two sets rows to
# form only one
trainList = dplyr::bind_cols(trainVolunteerIDs, trainVolunteerActions)
rm(trainVolunteerIDs, trainVolunteerActions)
testList <- dplyr::bind_cols(testVolunteerIDs, testVolunteerActions)
rm(testVolunteerIDs, testVolunteerActions)
volunteerActionsList = dplyr::bind_rows(trainList, testList)
rm(trainList, testList)

# Uses descriptive activity names to name the activities in the data set, so merge activities labels set with activities
# names set and select only volunteerID and activity names collumns to form a new descriptive data set
volunteerActionsList <- merge(volunteerActionsList, activities, by.x = "action", by.y = "id")
volunteerActionsList <- arrange(volunteerActionsList, volunteerID)
volunteerActionsList <- dplyr::select(volunteerActionsList, volunteerID, activity)
        
# Reading the training and test sets and binding it to create one data set, also setting features names
testSet <- fread("./test/X_test.txt", header = FALSE)
trainSet <- fread("./train/X_train.txt", header = FALSE)
volunteerFeatures = dplyr::bind_rows(testSet, trainSet)
names(volunteerFeatures) <- features$feature
rm(trainSet, testSet)

# Merges the training and the test sets to create one data set
humamActivityRecognition <- dplyr::bind_cols(volunteerActionsList, volunteerFeatures)
rm(volunteerActionsList, volunteerFeatures)

# Extracts only the measurements on the mean and standard deviation for each measurement. First, resolve duplicated names
# to use select function to retriev  mean and standard deviation variables
names(humamActivityRecognition) <-  make.unique(names(humamActivityRecognition))
selectedMeasurement <- grepl("mean|std", names(humamActivityRecognition), ignore.case = T)
humamActivityRecognition <- select(humamActivityRecognition, volunteerID, activity, which(selectedMeasurement))

# Appropriately labels the data set with descriptive variable names
names(humamActivityRecognition) <- gsub("-","", names(humamActivityRecognition))
names(humamActivityRecognition) <- gsub("\\s*\\(+\\)","", names(humamActivityRecognition))

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidydataSet <- group_by(humamActivityRecognition, volunteerID, activity) %>% summarise_each(funs(mean))

fwrite(tidydataSet, file = "tidydataset.csv", row.names = F, col.names = T, sep = ",")
