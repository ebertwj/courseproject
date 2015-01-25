
## read features.txt into table to get feature names 
featuresData <- read.table("C:/Users/bill/Data/UCI HAR Dataset/features.txt", col.names = c("line number", "feature name"), stringsAsFactors = FALSE)

## create vector of feature names
namedFeatures <- featuresData[, 2]

## function to change "BodyBody" to "Body" in feature names
f <- function(feature)
        sub("[B][o][d][y][B][o][d][y]", "Body", feature)

## apply function to feature names
result <- lapply(namedFeatures, f)

## function to remove unneeded parentheses from names
f2 <- function(feature)
        sub("[(][)]", " ", feature)

## remove parentheses from names
result2 <- lapply(result, f2)

## function to change "t" to "time" at beginning of names
f3 <- function(feature)
        sub("^t", "time ", feature)

## change "t" to "time" in feature names
result3 <- lapply(result2, f3)

## function to change "f" to "frequency" at beginning of names
f4 <- function(feature)
        sub("^f", "frequency ", feature)

## apply function to change "f" to "frequency" at beginning of names
result4 <- lapply(result3, f4)

## convert list of feature names back to vector of strings
cleanNames <- unlist(result4)

## read x_train data into table and use cleanNames for col names of features
xTrainData <- read.table("C:/Users/bill/Data/UCI HAR Dataset/train/X_train.txt", col.names = cleanNames, stringsAsFactors = FALSE)

## read y_train data into table
yTrainData <- read.table("C:/Users/bill/Data/UCI HAR Dataset/train/y_train.txt", col.names = c("activity code"), stringsAsFactors = TRUE)

## read x_test data into table and use cleanNames for col names of features
xTestData <- read.table("C:/Users/bill/Data/UCI HAR Dataset/test/X_test.txt", col.names = cleanNames, stringsAsFactors = FALSE)

## read y_test data into table
yTestData <- read.table("C:/Users/bill/Data/UCI HAR Dataset/test/y_test.txt", col.names = c("activity code"), stringsAsFactors = TRUE)

## read subjects_train data file into table
subjectsTrainData <- read.table("C:/Users/bill/Data/UCI HAR Dataset/train/subject_train.txt", col.names = c("subject id"), stringsAsFactors = TRUE)

## read subjects_test data file into table
subjectsTestData <- read.table("C:/Users/bill/Data/UCI HAR Dataset/test/subject_test.txt", col.names = c("subject id"), stringsAsFactors = TRUE)

## reduce names to those with mean or std in them
tidyNames <- grep("[Mm][e][a][n]|[Ss][t][d]", cleanNames, value = FALSE)

## reduce data in xTrain to columns with mean or std in them and discard last 7 columns
xTrainClean <- xTrainData[, tidyNames[1:79]]

## reduce data in xTest to columns with mean or std in them and discard last 7 columns
xTestClean <- xTestData[, tidyNames[1:79]]

## combine all "Test" data frames into a single data frame
xTestTidy <- cbind(xTestClean, yTestData, subjectsTestData)

## combine all "Train" data frames into a single data frame
xTrainTidy <- cbind(xTrainClean, yTrainData, subjectsTrainData)

## read activity_labels file into table
labels <- read.table("C:/Users/bill/Data/UCI HAR Dataset/activity_labels.txt", col.names = c("activity code", "activity name"), stringsAsFactors = FALSE)

## merge activity labels with xTest data
xTestMerged <- merge(xTestTidy, labels, by = "activity.code")

## merge activity labels with xTrain data
xTrainMerged <- merge(xTrainTidy, labels, by = "activity.code")

## merge xTest and xTrain data
data <- rbind(xTestMerged, xTrainMerged)

## eliminate unneeded activity code column
data$activity.code <- NULL

## load reshape2 library
library(reshape2)

## melt data with ids subject.id and activity
cdata <- melt(data, id = c("subject.id", "activity.name"), measure.vars = names(data)[1:79])

## recast data and calculate mean of all variables
tidyData <- dcast(cdata, subject.id + activity.name~variable, mean)

## write resulting table to disk
write.table(tidyData, "tidyData.csv", sep="\t")