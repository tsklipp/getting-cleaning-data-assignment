
# Reading activities and features 
activities <- fread("activity_labels.txt", header = FALSE, col.names = c("id", "activity"))
features <- fread("features.txt", header = FALSE, col.names = c("id", "features"))
