#set working directory
setwd('E:/temp/datasciencecoursera/gctd-project/')

#load file in memory
subject_test = read.table('UCI HAR Dataset/test/subject_test.txt')
subject_train = read.table('UCI HAR Dataset/train/subject_train.txt')
X_train = read.table('UCI HAR Dataset/train/X_train.txt')
Y_train = read.table('UCI HAR Dataset/train/Y_train.txt')
X_test = read.table('UCI HAR Dataset/test/X_test.txt')
Y_test = read.table('UCI HAR Dataset/test/Y_test.txt')

#create IDS rows
train_ids = c(1:nrow(X_train))
test_ids = c(1:nrow(X_test))

#add ids columns to all dataset
X_test['ids'] <-test_ids
Y_test['ids'] <-test_ids
subject_test['ids'] <-test_ids

X_train['ids'] <-train_ids
Y_train['ids'] <-train_ids
subject_train['ids'] <-train_ids

#merge input, target and subject dataset (test and train)
dtTest <- merge(X_test,Y_test,by="ids")
dtTest <- merge(dtTest,subject_test,by="ids")
dtTrain <- merge(X_train,Y_train,by="ids")
dtTrain <- merge(dtTrain,subject_train,by="ids")

#append dataset
dt <- rbind(dtTest,dtTrain)
#recompute ids
dt['ids'] <- c(1:nrow(dt))

#compute mean (except activity and subject)
means <- colMeans(dt[,-563:-564])

#compute standard deviation
sd <- apply(dt[,-563:-564], 2, sd)

#change columns names
names(dt)[names(dt) == 'V1.y'] <- 'activity'
names(dt)[names(dt) == 'V1'] <- 'subject'

#change column names of subjecs datasets (test and train)
#colnames(subject_test) <- "subject"
#colnames(subject_train) <- "subject"

#compute mean aggregate for subject and activity
var = names(dt[,-563:-564])
dt2 <- aggregate(dt[var], by=list(dt$subject,dt$activity), FUN=mean)

#save dataset to file
write.table(dt2, "dataset.txt")

