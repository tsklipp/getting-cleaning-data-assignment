# This rscript contains the procedures to get and clean the Human Activity Recognition Using Smartphones Data Set
# The first main step is to load the necessary data from the data set txt files

# load data.table to use fread function
library(data.table)
library(dplyr)

# Reading activities and features 
activities <- fread("activity_labels.txt", header = FALSE, col.names = c("id", "activity"))
features <- fread("features.txt", header = FALSE, col.names = c("id", "features"))

# Reading performed acitivities labels carried out by each volunteer and the id of the volunteers
testVolunteerActions <- fread("./test/y_test.txt", header = FALSE, col.names = "activity")
testVolunteerIDs <- fread("./test/subject_test.txt", header = FALSE, col.names = "volunteerID")
testList <- dplyr::bind_cols(testVolunteerIDs, testVolunteerActions)
rm(testVolunteerIDs,testVolunteerActions)

trainVolunteerActions <- fread("./train/y_train.txt", header = FALSE, col.names = "activity")
trainVolunteerIDs <- fread("./train/subject_train.txt", header = FALSE, col.names = "volunteerID")
traintList = dplyr::bind_cols(trainVolunteerIDs, trainVolunteerActions)
rm(trainVolunteerIDs,trainVolunteerActions)

volunteersList = dplyr::bind_rows(testList, traintList)
