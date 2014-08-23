##
## (c) Sergei V Rousakov

## ensure reshape2 is installed and loaded 
if(!require(reshape2)) {install.packages("reshape2"); require(reshape2)}

## downlaod and unpack the raw data, if it has not been done
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("UCI_HAR_Dataset.zip")) download.file(fileUrl, destfile = "UCI_HAR_Dataset.zip", method = "curl")
if(!file.exists("UCI HAR Dataset")) unzip("UCI_HAR_Dataset.zip")

## indentify raw data files to load and process
dataDir          <- "UCI HAR Dataset"
featDataFiles    <- list.files(dataDir, pattern = "^X_", full.names = TRUE, recursive = TRUE)
activityFiles    <- list.files(dataDir, pattern = "^y_", full.names = TRUE, recursive = TRUE)
subjectFiles     <- list.files(dataDir, pattern = "^subject_", full.names = TRUE, recursive = TRUE)
featNameFile     <- paste(dataDir, "features.txt", sep = "/")
activityNameFile <- paste(dataDir, "activity_labels.txt", sep = "/")

## load feature labes and activities labels
featureLabel  <- read.table(featNameFile, col.names = c("ID", "Name"), stringsAsFactors = FALSE)
activityLabel <- read.table(activityNameFile, col.names = c("ID", "Name"), stringsAsFactors = FALSE)

## load and merge test and train data sets for features measurements, subjects and activities
subject  <- do.call("rbind", lapply(subjectFiles, read.table, col.names = c("SubjectID")))

## load and merge test and train data sets for activities
activity <- do.call("rbind", lapply(activityFiles, read.table, col.names = c("ActivityID")))

## add human readable activity names from activity labels data set
activity$ActivityName <- activityLabel$Name[activity$ActivityID]

## load and merge test and train data sets for features measurements extracting
## only the measurements on the mean and standard deviation for each measurement
## add columns for subjects and activities
#featData <- do.call("rbind", lapply(featDataFiles, read.table, col.names = featureLabel$Name))
featData <- do.call("rbind", lapply(featDataFiles, read.table, comment.char = ""))
colnames(featData) <- featureLabel$Name
featData <- featData[,grep("std\\(\\)|mean\\(\\)", featureLabel$Name)]
featData <- cbind(activity, subject, featData)
featData <- featData[order(featData$ActivityID, featData$SubjectID),]

## create tidy data set with the average of the feature measurements for each activity and each subject
featDataLong <- melt(featData, id = names(featData[1:3]), measure.vars = names(featData[-(1:3)]))
featDataTidy <- dcast(featDataLong, ActivityID + ActivityName + SubjectID ~ variable, mean)

## write resulting data set into a file
write.table(featDataTidy, file = "feature_averages.txt", row.names = FALSE, col.names = TRUE)

