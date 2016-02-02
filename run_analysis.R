#Getting and Cleaning Data Course Project

#download the dataset and unzip it
        setwd("/Users/madhavirk/Desktop/Data Science Class/Getting&CleaningData")
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
        unzip(zipfile="./data/Dataset.zip",exdir="./data")

#read the files in the dataset and create data tables
        UCIHARfilespath <- "/Users/madhavirk/Desktop/Data Science Class/Getting&CleaningData/data/UCI HAR Dataset"
        library(dplyr)
        # Read the subject files
                dataSubjTrain <- tbl_df(read.table(file.path(UCIHARfilespath, "train", "subject_train.txt")))
                dataSubjTest  <- tbl_df(read.table(file.path(UCIHARfilespath, "test" , "subject_test.txt" )))

        # Read the activity files
                dataActTrain <- tbl_df(read.table(file.path(UCIHARfilespath, "train", "Y_train.txt")))
                dataActTest  <- tbl_df(read.table(file.path(UCIHARfilespath, "test" , "Y_test.txt" )))

        #Read the data files
                dataTrain <- tbl_df(read.table(file.path(UCIHARfilespath, "train", "X_train.txt" )))
                dataTest  <- tbl_df(read.table(file.path(UCIHARfilespath, "test" , "X_test.txt" )))

#PART 1: Merge the training and the test sets to create one data set

        library(data.table)
        #merge the training and the test sets using row binding and rename the variables "subject" and "activityNum"
                dataSubjConsolidated <- rbind(dataSubjTrain, dataSubjTest)
                setnames(dataSubjConsolidated, "V1", "subject")

                dataActConsolidated<- rbind(dataActTrain, dataActTest)
                setnames(dataActConsolidated, "V1", "activityNum")

        #combine the DATA training and test files
                dataTable <- rbind(dataTrain, dataTest)

        # name the variables using their features e.g.(V1 = "tBodyAcc-mean()-X")
                namebyFeatures <- tbl_df(read.table(file.path(UCIHARfilespath, "features.txt")))
                setnames(namebyFeatures, names(namebyFeatures), c("featureNum", "featureName"))
                colnames(dataTable) <- namebyFeatures$featureName

        #set column names for activity labels
                activityLabelNames<- tbl_df(read.table(file.path(UCIHARfilespath, "activity_labels.txt")))
                setnames(activityLabelNames, names(activityLabelNames), c("activityNum","activityName"))

        # Merge the columns
                alldataSubjAct<- cbind(dataSubjConsolidated, dataActConsolidated)
                alldataTable <- cbind(alldataSubjAct, dataTable)

#PART2: Extract only the measurements on the mean and standard deviation for each measurement

        # Read "features.txt" and extract the mean and standard deviations
                dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",namebyFeatures$featureName,value=TRUE) #var name

        # Taking only those measurements for mean and standard deviation and add "subject","activityNum"
                dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
                dataTableMeanStd<- subset(alldataTable,select=dataFeaturesMeanStd)

#PART3: Use descriptive activity names to name the activities in the data set

        #enter activity names into dataTable
                dataTableMeanStd <- merge(activityLabelNames, dataTableMeanStd , by="activityNum", all.x=TRUE)
                dataTableMeanStd$activityName <- as.character(dataTableMeanStd$activityName)

        # create dataTableMeanStd with variable means sorted by subject and Activity
                dataTableMeanStd$activityName <- as.character(dataTableMeanStd$activityName)
                dataAggr<- aggregate(. ~ subject - activityName, data = dataTableMeanStd, mean) 
                dataTableSorted<- tbl_df(arrange(dataAggr,subject,activityName))

#PART4: Appropriately label the data set with descriptive variable names
        str(dataTableSorted)

        names(dataTableSorted)<-gsub("std()", "SD", names(dataTableSorted))
        names(dataTableSorted)<-gsub("mean()", "MEAN", names(dataTableSorted))
        names(dataTableSorted)<-gsub("^t", "time", names(dataTableSorted))
        names(dataTableSorted)<-gsub("^f", "frequency", names(dataTableSorted))
        names(dataTableSorted)<-gsub("Acc", "Accelerometer", names(dataTableSorted))
        names(dataTableSorted)<-gsub("Gyro", "Gyroscope", names(dataTableSorted))
        names(dataTableSorted)<-gsub("Mag", "Magnitude", names(dataTableSorted))
        names(dataTableSorted)<-gsub("BodyBody", "Body", names(dataTableSorted))

        str(dataTableSorted)

#PART5: From the data set in step 4, create an independent tidy data set with 
#the average of each variable for each activity and each subject
        write.table(dataTableSorted, "TidyDataset.txt", row.name=FALSE)