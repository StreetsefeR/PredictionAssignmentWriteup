library(caret)
library(rpart)
library(randomForest)
trainUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
training <- read.csv(url(trainUrl), na.strings=c("NA","#DIV/0!",""))
testing <- read.csv(url(testUrl), na.strings=c("NA","#DIV/0!",""))

#summary(training)
#str(training)

for(i in c(8:ncol(training)-1)) {
	training[,i] = as.numeric(as.character(training [,i]))
}

tidyTraining <- training[colnames(training[colSums(is.na(training)) == 0])[-(1:7)]]

set.seed(12321)

inTrain <- createDataPartition(y=tidyTraining$classe, p=0.6, list=FALSE )
training.training <- tidyTraining [inTrain ,]
training.testing <- tidyTraining [-inTrain ,]

#modelTree <- rpart(classe ~ ., data=training.training, method="class")
#predictionTree <- predict(modelTree , training.testing, type = "class")
#confusionMatrix(predictionTree, training.testing$classe)

modelForest <- randomForest(classe ~. , data=training.training)
predictionForest <- predict(modelForest , training.testing, type = "class")
confusionMatrix(predictionForest, training.testing$classe)

predictionFinal <- predict(modelForest , testing, type = "class")
pml_write_files(predictionFinal)

