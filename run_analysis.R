##STEP 1 - Merges the training and the test sets to create one data set

#download data

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#unzip file
unzip(zipfile="./data/Dataset.zip",exdir="./data"
path_rf <- file.path("./data" , "UCI HAR Dataset")
files <-list.files(path_rf, recursive=TRUE)
files
      
##reading training tables 
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")


#reading testing tables 
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#reading feature vector 
features <- read.table('./data/UCI HAR Dataset/features.txt')

#reading activity labels 
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#assigning col names 
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#merging all data in one set

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

##STEP 2 - Extracts only the measurements on the mean and standard deviation for each measurement

#reading column names:

colNames <- colnames(setAllInOne)

#create vector for defining ID, mean and standard deviation:

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#creating subset

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

##STEP 3 - Uses descriptive activity names to name the activities in the data set
##STEP 4 - Appropriately labels the data set with descriptive variable names

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)


##STEP 5 -  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

#create tidy data set

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#write in txt file

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)