# Prediction Assignment Writeup

##Data 

###The training data for this project are available here: 
###https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

###The test data are available here: 
###https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

###The data for this project come from this source: http://groupware.les.inf.puc-rio.br/har.

##Preliminary analysis and data cleaning

###According to assignment objective it is intended to try different techniques(Decision Tree and Random Forest) to find best and decently descriptive predictive algoritm

###Therefore following libraries will be used:
library(caret)
library(rpart)
library(randomForest)

###Data loaded for analysis with following code:

###trainUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
###testUrl <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
###training <- read.csv(url(trainUrl), na.strings=c("NA","#DIV/0!",""))
###testing <- read.csv(url(testUrl), na.strings=c("NA","#DIV/0!",""))

###Note: at the stage of loading data is converted according to most common used NA strings

###First look at data indicates necesity for pre-processing to be able to use learning algoritms. Commands to view structure of loaded data:
###summary(training)
###str(training)

###Measurement features(columns) starting with "roll_belt"(8-th) are in different formats. To prepare data for analysis all columns are converted to numeric type:
###for(i in c(8:ncol(training)-1)) {
###	training[,i] = as.numeric(as.character(training [,i]))
###}

###First 7 features(columns) shold be deleted from training set as the names, timestamps and window info are not providing learning insight and may mislead to wrong relations:
###tidyTraining <- training[colnames(training[colSums(is.na(training)) == 0])[-(1:7)]]

###To provide reproducibility seed is set:
###set.seed(12321)

###Dividing training set into training and testing subset in 60/40 proportion
###inTrain <- createDataPartition(y=tidyTraining$classe, p=0.6, list=FALSE )
###training.training <- tidyTraining [inTrain ,]
###training.testing <- tidyTraining [-inTrain ,]

##Algorithms application and comparison

###Decision Tree:
###modelTree <- rpart(classe ~ ., data=training.training, method="class")
###predictionTree <- predict(modelTree , training.testing, type = "class")
###confusionMatrix(predictionTree, training.testing$classe)

```
###Confusion Matrix and Statistics

###          Reference
###Prediction    A    B    C    D    E
###         A 1977  220   42   76   18
###         B   92  968  183  133  173
###         C   62  193 1038  170  129
###         D   72  104  105  813   92
###         E   29   33    0   94 1030

###Overall Statistics
                                          
###               Accuracy : 0.7425          
###                 95% CI : (0.7327, 0.7522)
###    No Information Rate : 0.2845          
###    P-Value [Acc > NIR] : < 2.2e-16       
                                          
###                  Kappa : 0.6738          
### Mcnemar's Test P-Value : < 2.2e-16       

###Statistics by Class:

###                     Class: A Class: B Class: C Class: D Class: E
###Sensitivity            0.8858   0.6377   0.7588   0.6322   0.7143
###Specificity            0.9366   0.9082   0.9145   0.9431   0.9756
###Pos Pred Value         0.8474   0.6249   0.6520   0.6855   0.8685
###Neg Pred Value         0.9537   0.9127   0.9472   0.9290   0.9381
###Prevalence             0.2845   0.1935   0.1744   0.1639   0.1838
###Detection Rate         0.2520   0.1234   0.1323   0.1036   0.1313
###Detection Prevalence   0.2973   0.1974   0.2029   0.1512   0.1512
###Balanced Accuracy      0.9112   0.7729   0.8366   0.7877   0.8450
```

###Random Forests:
###modelForest <- randomForest(classe ~. , data=training.training)
###predictionForest <- predict(modelForest , training.testing, type = "class")
###confusionMatrix(predictionForest, training.testing$classe)

```###Confusion Matrix and Statistics

###          Reference
###Prediction    A    B    C    D    E
###         A 2231    6    0    0    0
###         B    1 1509   11    0    0
###         C    0    3 1355   20    2
###         D    0    0    2 1265    3
###         E    0    0    0    1 1437

###Overall Statistics
                                          
###               Accuracy : 0.9938          
###                 95% CI : (0.9918, 0.9954)
###    No Information Rate : 0.2845          
###    P-Value [Acc > NIR] : < 2.2e-16       
###                                          
###                  Kappa : 0.9921          
### Mcnemar's Test P-Value : NA              

###Statistics by Class:

###                     Class: A Class: B Class: C Class: D Class: E
###Sensitivity            0.9996   0.9941   0.9905   0.9837   0.9965
###Specificity            0.9989   0.9981   0.9961   0.9992   0.9998
###Pos Pred Value         0.9973   0.9921   0.9819   0.9961   0.9993
###Neg Pred Value         0.9998   0.9986   0.9980   0.9968   0.9992
###Prevalence             0.2845   0.1935   0.1744   0.1639   0.1838
###Detection Rate         0.2843   0.1923   0.1727   0.1612   0.1832
###Detection Prevalence   0.2851   0.1939   0.1759   0.1619   0.1833
###Balanced Accuracy      0.9992   0.9961   0.9933   0.9915   0.9982
```

###As supposed random forests provided higher and definitely good accuracy of 0.9938 in comparison with decision tree value of 0.7425

##Prediction and report files generation

###Applying random forest to initial testing data:

###predictionFinal <- predict(modelForest , testing, type = "class")

###Generation function:

###pml_write_files = function(x){
###  n = length(x)
###  for(i in 1:n){
###    filename = paste0("problem_id_",i,".txt")
###    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
###  }
###}

###pml_write_files(predictionFinal)
