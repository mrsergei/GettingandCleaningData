##
##  Coursera - Johns Hopkins University "Getting and Cleaning Data" course projet
##
## (c) Sergei V Rousakov

## ensure reshape2 is installed and loaded 
if(!require(reshape2)) {install.packages("reshape2"); require(reshape2)}

## downlaod and unpack the raw data, if it has not been done yet
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("UCI_HAR_Dataset.zip")) download.file(fileUrl, destfile = "UCI_HAR_Dataset.zip", method = "curl")
if(!file.exists("UCI HAR Dataset")) unzip("UCI_HAR_Dataset.zip")

## indentify raw data files to load:
dataDir          <- "UCI HAR Dataset"
featDataFiles    <- paste(dataDir, c("test/X_test.txt", "train/X_train.txt"), sep = "/")
activityFiles    <- paste(dataDir, c("test/y_test.txt", "train/y_train.txt"), sep = "/")
subjectFiles     <- paste(dataDir, c("test/subject_test.txt", "train/subject_train.txt"), sep = "/")
featNameFile     <- paste(dataDir, "features.txt", sep = "/")
activityNameFile <- paste(dataDir, "activity_labels.txt", sep = "/")

## load feature labes and activities labels
featureLabel  <- read.table(featNameFile, col.names = c("ID", "Name"), stringsAsFactors = FALSE)
activityLabel <- read.table(activityNameFile, col.names = c("ID", "Name"), stringsAsFactors = FALSE)

## load and merge test and train data sets for features measurements, subjects and activities
subject <- do.call("rbind", lapply(subjectFiles, read.table, col.names = c("SubjectID")))

## load and merge test and train data sets for activities
activity <- do.call("rbind", lapply(activityFiles, read.table))

## add human readable activity names from activity labels data set by
## replacing activity IDs with activity labels from activity_labes.txt file
activity[[1]]   <- activityLabel$Name[activity[[1]]] 
activity[[1]]   <- factor(activity[[1]], levels = activityLabel$Name)
names(activity) <- c("ActivityLabel")

## load and merge test and train data sets for features measurements
featData <- do.call("rbind", lapply(featDataFiles, read.table, comment.char = ""))
colnames(featData) <- featureLabel$Name

## extract only the measurements on the mean and standard deviation for each measurement
featData <- featData[,grep("std\\(\\)|mean\\(\\)", featureLabel$Name)]

## add columns for subjects and activities
featData <- cbind(activity, subject, featData)

## create tidy data set with the average of the feature measurements for each activity and each subject
featDataLong <- melt(featData, id = names(featData[1:2]), measure.vars = names(featData[-(1:2)]))
featDataTidy <- dcast(featDataLong, ActivityLabel + SubjectID ~ variable, mean)

## write resulting data set into a file keeping the human readable column names
write.table(featDataTidy, file = "feature_averages.txt", row.names = FALSE, col.names = TRUE)
