#Read in test-data. We need three files. 
# 1. y_test.txt for the activity id
# 2. subject_test.txt for the subject id
# 3. X_test.txt for the feature values

testActivityIds<-read.table('data/test/y_test.txt')
testSubjectIds<-read.table('data/test/subject_test.txt')
testFeatureValues<-read.table('data/test/X_test.txt')

#we filter out irrelevant features using dplyr
library(dplyr)
testFeatureValues<-select(testFeatureValues,c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,161,162,163,164,165,166,201,202,214,227,228,240,241,253,254,266,267,268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,516,517,529,530,542,543
))

#merge test data

testData<-data.frame(cbind(testActivityIds,testSubjectIds,testFeatureValues))

#applying variable names
columnNames<-c("activity","subject","tBodyAccmeanX","tBodyAccmeanY","tBodyAccmeanZ","tBodyAccstdX","tBodyAccstdY","tBodyAccstdZ","tGravityAccmeanX","tGravityAccmeanY","tGravityAccmeanZ","tGravityAccstdX","tGravityAccstdY","tGravityAccstdZ","tBodyAccJerkmeanX","tBodyAccJerkmeanY","tBodyAccJerkmeanZ","tBodyAccJerkstdX","tBodyAccJerkstdY","tBodyAccJerkstdZ","tBodyGyromeanX","tBodyGyromeanY","tBodyGyromeanZ","tBodyGyrostdX","tBodyGyrostdY","tBodyGyrostdZ","tBodyGyroJerkmeanX","tBodyGyroJerkmeanY","tBodyGyroJerkmeanZ","tBodyGyroJerkstdX","tBodyGyroJerkstdY","tBodyGyroJerkstdZ","tBodyAccMagmean","tBodyAccMagstd","tGravityAccMagmean","tBodyAccJerkMagmean","tBodyAccJerkMagstd","tBodyGyroMagmean","tBodyGyroMagstd","tBodyGyroJerkMagmean","tBodyGyroJerkMagstd","fBodyAccmeanX","fBodyAccmeanY","fBodyAccmeanZ","fBodyAccstdX","fBodyAccstdY","fBodyAccstdZ","fBodyAccJerkmeanX","fBodyAccJerkmeanY","fBodyAccJerkmeanZ","fBodyAccJerkstdX","fBodyAccJerkstdY","fBodyAccJerkstdZ","fBodyGyromeanX","fBodyGyromeanY","fBodyGyromeanZ","fBodyGyrostdX","fBodyGyrostdY","fBodyGyrostdZ","fBodyAccMagmean","fBodyAccMagstd","fBodyBodyAccJerkMagmean","fBodyBodyAccJerkMagstd","fBodyBodyGyroMagmean","fBodyBodyGyroMagstd","fBodyBodyGyroJerkMagmean","fBodyBodyGyroJerkMagstd")

colnames(testData)<-columnNames

#Read in training-data. We need three files. 
# 1. y_train.txt for the activity id
# 2. subject_train.txt for the subject id
# 3. X_train.txt for the feature values

trainingActivityIds<-read.table('data/training/y_train.txt')
trainingSubjectIds<-read.table('data/training/subject_train.txt')
trainingFeatureValues<-read.table('data/training/X_train.txt')

#we filter out irrelevant features using dplyr

trainingFeatureValues<-select(trainingFeatureValues,c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,161,162,163,164,165,166,201,202,214,227,228,240,241,253,254,266,267,268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,516,517,529,530,542,543
))

#merge training data

trainingData<-data.frame(cbind(trainingActivityIds,trainingSubjectIds,trainingFeatureValues))

#applying variable names
colnames(trainingData)<-columnNames

#appending test and trainign dataset

activityData<-data.frame(rbind(testData,trainingData))


#coerce activity and subject to factors

activityData$activity<-as.factor(activityData$activity)
activityData$subject<-as.factor(activityData$subject)

#revaluing the activity factors with plyr
library(plyr)
activityData$activity<-revalue(activityData$activity,c("1"="WALKING","2"="WALKING_UPSTAIRS","3"="WALKING_DOWNSTAIRS","4"="SITTING","5"="STANDING","6"="LAYING"))


#means
aggregatedData<-aggregate(activityData[,3]~ activity + subject, data = activityData, FUN= "mean" )

for(i in 4:67)
	{
	tempAggregatedData<-aggregate(activityData[,i]~ activity + subject, data = activityData, FUN= "mean" )
	newVarName<-NULL
	aggregatedData<-cbind(aggregatedData,tempAggregatedData[,3])
	}
	
#create new variable names and insert into data
cols<-paste('mean_',colnames(activityData[3:67]),sep="")
cols<-c('activity',"subject",cols)
colnames(aggregatedData)<-cols

#write table
write.table(aggregatedData, file = "aggregated_data.txt",  sep = " ", row.names = FALSE)