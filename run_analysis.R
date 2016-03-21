##---------------- Read Train and Test data from the respective folders ------------------------##

X_train <- read.table("./train/X_train.txt",header = FALSE)
Y_train <- read.table("./train/Y_train.txt",header = FALSE)
X_test <- read.table("./test/X_test.txt",header = FALSE)
Y_test <- read.table("./test/Y_test.txt",header = FALSE)


##---------------- Read Features description from features.txt file ------------------------##
features <- read.table("./features.txt",header = FALSE)


##---------------- Create intermediate data frames with column names as features ------------------------##
X_train_act <- setNames(X_train[1:561],features$V2)
X_test_act <- setNames(X_test[1:561],features$V2)


##---------------- Read activity labels ------------------------##
activity_labels <- read.table("./activity_labels.txt",header = FALSE)


##---------------- Merge Y_train / Y_test with activity labels to pull activity description ------------------------##
Y_train_act <- merge(Y_train,activity_labels,by.x = "V1",by.y = "V1",all = TRUE,sort = FALSE)
Y_test_act <- merge(Y_test,activity_labels,by.x = "V1",by.y = "V1",all = TRUE,sort = FALSE)

##---------------- Pull activitycode and activityname into X_train_act and X_test_act data frames ------------------------##
X_test_act$activitycode <- Y_test_act$V1
X_test_act$activityname <- Y_test_act$V2

X_train_act$activitycode <- Y_train_act$V1
X_train_act$activityname <- Y_train_act$V2

##---------------- Read Subject data from the respective txt files ------------------------##
subject_train <- read.table("./train/subject_train.txt",header = FALSE)
subject_test <- read.table("./test/subject_test.txt",header = FALSE)


##---------------- Read Subject data into X_train_act and X_test_act data frames ------------------------##
X_train_act$subject <- subject_train$V1
X_test_act$subject <- subject_test$V1


##---------------- Merge train and test data sets ------------------------##
Merged_X_train_test <- rbind(X_train_act,X_test_act)


##---------------- Pull only columns with either mean or standard deviation data ------------------------##
Mean_Std <- cbind(Merged_X_train_test[,grep("mean|std",colnames(Merged_X_train_test)),],Merged_X_train_test[,562:564])



##---------------- Group by activityname and subject and get the averages and sort ------------------------##
Avg_All <- aggregate(Mean_Std[,1:79],list(Mean_Std$activityname,Mean_Std$subject),mean)

colnames(Avg_All)[1:2] <- c("activity","subject") 

install.packages("dplyr")
library("dplyr")

Avg_All <- arrange(Avg_All,activity)


##---------------- Write the data to txt file ------------------------##

write.table(Avg_All,"./Avg_All.txt",row.names = FALSE)