Processing the Human Activity Recognition Using Smartphones Data Set Dataset
============================================================================


The raw-data and a description of the study can be found here

Davide *Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.*

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]

#Read in test-data. 

We need three files to consolidate the full testdataset in one table.

1. y_test.txt for the activity id
2. subject_test.txt for the subject id
3. X_test.txt for the feature values

Code:
*
testActivityIds<-read.table('data/test/y_test.txt')
testSubjectIds<-read.table('data/test/subject_test.txt')
testFeatureValues<-read.table('data/test/X_test.txt')
*

#Selecting the mean-and standard deviation values

As we are interested only in the mean - and standard deviation values we select only these relevant features. We use the dplyr-function select, and select the features via there column-index.

Code:
*
library(dplyr)
testFeatureValues<-select(testFeatureValues,c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,161,162,163,164,165,166,201,202,214,227,228,240,241,253,254,266,267,268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,516,517,529,530,542,543
))
*

#Merge test data

We merge the three files in one testdata-set

Code:
*
testData<-data.frame(cbind(testActivityIds,testSubjectIds,testFeatureValues))
*

#Applying variable names

To apply the speaking variable names we change the column names, to the original feature values. The new variables subject and activity are inserted.

Code:
*
columnNames<c("activity","subject","tBodyAccmeanX","tBodyAccmeanY","tBodyAccmeanZ","tBodyAccstdX","tBodyAccstdY","tBodyAccstdZ","tGravityAccmeanX","tGravityAccmeanY","tGravityAccmeanZ","tGravityAccstdX","tGravityAccstdY","tGravityAccstdZ","tBodyAccJerkmeanX","tBodyAccJerkmeanY","tBodyAccJerkmeanZ","tBodyAccJerkstdX","tBodyAccJerkstdY","tBodyAccJerkstdZ","tBodyGyromeanX","tBodyGyromeanY","tBodyGyromeanZ","tBodyGyrostdX","tBodyGyrostdY","tBodyGyrostdZ","tBodyGyroJerkmeanX","tBodyGyroJerkmeanY","tBodyGyroJerkmeanZ","tBodyGyroJerkstdX","tBodyGyroJerkstdY","tBodyGyroJerkstdZ","tBodyAccMagmean","tBodyAccMagstd","tGravityAccMagmean","tBodyAccJerkMagmean","tBodyAccJerkMagstd","tBodyGyroMagmean","tBodyGyroMagstd","tBodyGyroJerkMagmean","tBodyGyroJerkMagstd","fBodyAccmeanX","fBodyAccmeanY","fBodyAccmeanZ","fBodyAccstdX","fBodyAccstdY","fBodyAccstdZ","fBodyAccJerkmeanX","fBodyAccJerkmeanY","fBodyAccJerkmeanZ","fBodyAccJerkstdX","fBodyAccJerkstdY","fBodyAccJerkstdZ","fBodyGyromeanX","fBodyGyromeanY","fBodyGyromeanZ","fBodyGyrostdX","fBodyGyrostdY","fBodyGyrostdZ","fBodyAccMagmean","fBodyAccMagstd","fBodyBodyAccJerkMagmean","fBodyBodyAccJerkMagstd","fBodyBodyGyroMagmean","fBodyBodyGyroMagstd","fBodyBodyGyroJerkMagmean","fBodyBodyGyroJerkMagstd")
colnames(testData)<-columnNames
*


#Read in training-data

We need three files to consolidate the full trainingdataset in one table.

1. y_train.txt for the activity id
2. subject_train.txt for the subject id
3. X_train.txt for the feature values


Code:
*
trainingActivityIds<-read.table('data/training/y_train.txt')
trainingSubjectIds<-read.table('data/training/subject_train.txt')
trainingFeatureValues<-read.table('data/training/X_train.txt')
*

#Selecting the mean-and standard deviation values

As we are interested only in the mean - and standard deviation values we select only these relevant features. We use the dplyr-function select, and select the features via there column-index.

Code:
*
trainingFeatureValues<-select(trainingFeatureValues,c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,161,162,163,164,165,166,201,202,214,227,228,240,241,253,254,266,267,268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,516,517,529,530,542,543
))
*


#Merge training data

We merge the three files in one trainingdata-set

Code:
*
trainingData<-data.frame(cbind(trainingActivityIds,trainingSubjectIds,trainingFeatureValues))
*

#Applying variable names

As above, we speaking variable names to the original feature values. 

Code:
*
colnames(trainingData)<-columnNames
*


#Appending test and trainign dataset

We append the trainign and testdataset to finalize the merge.

Code:
*
activityData<-data.frame(rbind(testData,trainingData))
*

#Coerce activity and subject to factors

As we need the activity and subject variables as factorial variables, we will coerce them to factors.

Code:
*
activityData$activity<-as.factor(activityData$activity)
activityData$subject<-as.factor(activityData$subject)
*


'Revaluing the activity factors with plyr

The activity-labels are revalued to the original labels.

Code:
*
library(plyr)
activityData$activity<-revalue(activityData$activity,c("1"="WALKING","2"="WALKING_UPSTAIRS","3"="WALKING_DOWNSTAIRS","4"="SITTING","5"="STANDING","6"="LAYING"))
*

#Calculating the means per activity and subject

We aggregate the data on the basis activity per user and calculate the mean.

Code:
*
aggregatedData<-aggregate(activityData[,3]~ activity + subject, data = activityData, FUN= "mean" )
for(i in 4:67)
	{
	tempAggregatedData<-aggregate(activityData[,i]~ activity + subject, data = activityData, FUN= "mean" )
	newVarName<-NULL
	aggregatedData<-cbind(aggregatedData,tempAggregatedData[,3])
	}
*

#Create new variable names and insert into data

To make the data proccessable and readable we change the variable names according to their value.

Code:
*
cols<-paste('mean_',colnames(activityData[3:67]),sep="")
cols<-c('activity',"subject",cols)
colnames(aggregatedData)<-cols
*


#Write table

We save the table.

Code:
*
write.table(aggregatedData, file = "aggregated_data.txt",  sep = " ", row.names = FALSE)
*