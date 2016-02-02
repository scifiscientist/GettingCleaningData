# Getting Cleaning Data Course Project Files
## This repo contains the files pertaining to the programming assignment for the 'Getting and Cleaning Data' course on Coursera

### The R script, run_analysis.R contains all the code to perform the analyses described in the steps below:

1) Downloads the dataset from the web and unzips it
2) Loads the activity and feature info into data tables
3) Loads both the training and test datasets, keeping only those columns which reflect mean & standard deviation
4) Loads the activity and subject data for each dataset, and merges those columns with the dataset
5) Merges the two datasets
6) Converts the activity and subject columns into factors
7) Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair

### The resulting tidy dataset is in the file "TidyDataset.txt"
It contains one row for each subject/activity pair and columns for subject, activity, and each feature 
that is a mean or standard deviation of the original dataset values.

### "CodeBook.md" describes the variables, the data, and any transformations or work that was performed to clean up the data
