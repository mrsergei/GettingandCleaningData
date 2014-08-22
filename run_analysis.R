##
##
## Testiment to my laziness

## Raw data files to load and process:
dataDir          <- "data"
featDataFiles    <- list.files(dataDir, pattern = "^X_", full.names = TRUE, recursive = TRUE)
activityFiles    <- list.files(dataDir, pattern = "^y_", full.names = TRUE, recursive = TRUE)
subjectFiles     <- list.files(dataDir, pattern = "^subject_", full.names = TRUE, recursive = TRUE)
featNameFile     <- paste0(dataDir, "/features.txt")
activityNameFile <- paste0(dataDir, "/activity_labels.txt")

## load features and activities labels
features   <- read.table(featNameFile, col.names = c("ID", "Name"), stringsAsFactors = FALSE)
activities <- read.table(activityNameFile, col.names = c("ID", "Name"), stringsAsFactors = FALSE)

## load and merge test and train data sets for features, subjects and activities
## I use do.call(), alternatively you can use rbind_all() from dplyr package 
## of dply from plyr package to combine these data sets
featData   <- do.call("rbind", lapply(featDataFiles, read.table, col.names = features$Name))
subjectID  <- do.call("rbind", lapply(subjectFiles, read.table, col.names = c("SubjectID")))
activityID <- do.call("rbind", lapply(activityFiles, read.table, col.names = c("ActivityID")))

## generate a list of human readable activity names
ActivityName <- sapply(activityID[[1]], function(id) activities$Name[id])

## Extracts only the measurements on the mean and standard deviation for each measurement
featSDmean <- cbind(subjectID, ActivityName, featData[,grep("std\\(\\)|mean\\(\\)", features$Name)])