---
title: "CodeBook.md"
author: "Bill"
date: "Sunday, January 25, 2015"
output: html_document
---

The raw data files in the script run_analysis.R, were combined into a single data table, then the mean of the variables for each activity-subject were calculated and a new data table was created resulting in a summary of the mean measurement for each activity-subject combination.

activity types are:
Laying
Sitting
Standing
Walking
Walking Downstairs
Walking Upstairs

There were 30 different subjects labeled 1 through 30

The accelerometer measurements are more fully described in the original data file in features_info.txt.

The R script requires the reshape2 package to run.

The R script first loads the feature names, removes unneccessary parentheses and extra text from the names. 

Next the data files are read in and merged along the appropriate axis.

Finally the mean is calculated using the reshape package by first using the melt function with the activiy.name and subject.id columns as id, then using the dcast function to calculate the average for each measurment by subject.id + activity.name

The resulting data table is written to disk
