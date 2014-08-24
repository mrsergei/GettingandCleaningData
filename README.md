#run_analysis.R  

#####Overview  

This README file describes what `run_analysis.R` script does and how to run it to generate **tidy dataset** from the original **raw** Human Activity Recognition Using Smartphones Data Set. Both are described in the [Codebook](https://github.com/mrsergei/GettingandCleaningData/blob/master/CodeBook.md). 

#####What run_analysis.R script does   

- First it checks to see if current directory where it is running contains directory `UCI HAR Dataset`. If not, it downloads the compressed data file into local directory and unzips it   
- Then loads the following files  
      - `features.txt`  
      - `activity_labels.txt`  
      - `train/X_train.txt`   
      - `train/y_train.txt`  
      - `train/subject_train.txt`  
      - `train/X_test.txt`   
      - `train/y_test.txt`  
      - `train/subject_test.txt`  
- Script combines `train` and `test` data for each set of files - measurements (`X_*.txt`), activity IDs (`y_*.txt`) and subject IDs (`subject_*.txt`)
- It replaces activity IDs with human readable activity labels in activity vector(`activity`)
- It adds human readable column names for activity vector(`activity`), subject vector (`subject`) and feature columns (`featData`)
- It selects only feature data columns that correspond to mean and standard deviation variables
- It combines activity, subject and reduced feature data set into one called `featData` for further processing:   
```
> head(featData[1:5])
  ActivityLabel SubjectID tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
1      STANDING         2         0.2571778       -0.02328523       -0.01465376
2      STANDING         2         0.2860267       -0.01316336       -0.11908252
3      STANDING         2         0.2754848       -0.02605042       -0.11815167
4      STANDING         2         0.2702982       -0.03261387       -0.11752018
5      STANDING         2         0.2748330       -0.02784779       -0.12952716
6      STANDING         2         0.2792199       -0.01862040       -0.11390197
```
- Using `reshape2` library function melt, it generates long data format with activity, subject, variable and value:   
```   
> head(featDataLong)
  ActivityLabel SubjectID          variable     value
1      STANDING         2 tBodyAcc-mean()-X 0.2571778
2      STANDING         2 tBodyAcc-mean()-X 0.2860267
3      STANDING         2 tBodyAcc-mean()-X 0.2754848
4      STANDING         2 tBodyAcc-mean()-X 0.2702982
5      STANDING         2 tBodyAcc-mean()-X 0.2748330
6      STANDING         2 tBodyAcc-mean()-X 0.2792199

```  
- Using `reshape2` library function dcast it calculates mean of each variable per subject per activity and generates long data format for the averages: 
```  
> head(featDataTidy[1:5])
  ActivityLabel SubjectID tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
1       WALKING         1         0.2773308       -0.01738382        -0.1111481
2       WALKING         2         0.2764266       -0.01859492        -0.1055004
3       WALKING         3         0.2755675       -0.01717678        -0.1126749
4       WALKING         4         0.2785820       -0.01483995        -0.1114031
5       WALKING         5         0.2778423       -0.01728503        -0.1077418
6       WALKING         6         0.2836589       -0.01689542        -0.1103032

```  
- `featDatsaTidy` gets written to the `feature_average.txt` file

- In addition, `run_analysis.R` genrates a number of `R` objects that you can use to do furtehr analysis:

```
> ls()
 [1] "activity"         "activityFiles"    "activityLabel"    "activityNameFile" "dataDir"         
 [6] "featData"         "featDataFiles"    "featDataLong"     "featDataTidy"     "featNameFile"    
[11] "featureLabel"     "fileUrl"          "subject"          "subjectFiles"    

```
#####How to run the script  

First, You have to sure `R` is instaled on yoru system. Copy the `run_analysis.R` script to the location wehre you have `UCI HAR Dataset` directory. Start R session.

```
> dir()  
[1] "UCI HAR Dataset"        "run_analysis.R" 
> source("run_analysis.R")
```
Scrpit will create file `feature_averages.txt` containing the tidy data set   

```
> dir()
[1] "feature_averages.txt" "UCI HAR Dataset"        "run_analysis.R" 
> ls()
 [1] "activity"         "activityFiles"    "activityLabel"    "activityNameFile" "dataDir"         
 [6] "featData"         "featDataFiles"    "featDataLong"     "featDataTidy"     "featNameFile"    
[11] "featureLabel"     "fileUrl"          "subject"          "subjectFiles"    

```
