---
title: "Prediction Assignment"
author: "d2i2k"
date: "Sunday, March 22, 2015"
<<<<<<< HEAD
output:
  pdf_document:
    toc: yes
  html_document:
    number_sections: yes
    toc: yes
=======
output: pdf_document
>>>>>>> 822572133d8e98fbaf5eb29a2e393fd4dab6b127
---
Question
How well did the six participants perform their weight lifting exercises based on pre-specified, qualitative activity recognition classification?

Training and Testing Data
pml_training<-read.csv("http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",na.strings=c("NA",""))
dim(pml_training) # 19622 rows, 160 cols

pml_testing<-read.csv("http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",na.strings=c("NA",""))
dim(pml_testing)  # 20 rows, 160 cols
Pre-Processing Steps
Step 1. Delete 100 columns with unavailable (NA) or missing ("") data.

non_missing <- apply(!is.na(pml_training),2,sum)>19621
pml_training1 <- pml_training[,non_missing]
dim(pml_training1)  # 19,622 rows, 60 cols

non_missing <- apply(!is.na(pml_testing),2,sum)>19
pml_testing2 <- pml_testing[,non_missing]
dim(pml_testing2)  # 20 rows, 60 cols
Step 2. Delete 406 rows in which the new_window variable equals "yes."

pml_training2 <- subset(pml_training1,new_window=="no")
dim(pml_training2)  # 19,216 rows, 60 cols 
Step 3. Delete index, timestamps and new_window variable (Columns 1, 3-6). The remaining columns include 54 predictors and the classe variable.

pml_training2_user_name <- pml_training2[,2]
pml_training2_predictors <- pml_training2[7:60]
pml_training3 <- cbind(pml_training2_user_name,pml_training2_predictors)
dim(pml_training3) # 19,216 rows, 55 cols 

pml_testing2_user_name <- pml_testing2[,2]
pml_testing2_predictors <- pml_testing2[,7:60]
pml_testing3 <- cbind(pml_testing2_user_name,pml_testing2_predictors)
dim(pml_testing3) # 20 rows, 55 cols 

library(caret)
InTrain = createDataPartition(pml_training3$classe,p=0.4)[[1]]
training <- pml_training3[InTrain,] # 7689 rows, 55 cols
dim(training)
Algorithm
A random forest (rf) model was fitted to training data using the train function with five-fold cross validation (cv).

set.seed(125)
modFit<-train(classe~.,data=training,method="rf", trControl=trainControl(method="cv",number=5), prox=TRUE,allowParallel=TRUE)
print(modFit)
print(modFit$finalModel)
Out-of-Sample Error

The random forest model should be highly accurate due to the large sample size of the training data and five-fold cross validation (k=5).

<<<<<<< HEAD

Prediction

Predicted values should nearly match the observed values because user_name and num_window are common factors in both training and test datasets.

predictions <- predict(modFit,newdata=pml_testing3)
predictions
[1] B A B A A E D B A A B C B A E E A B B B
Confusion matrix: A B C D E class.error A 2188 0 0 0 1 0.0004568296 B 5 1476 6 1 0 0.0080645161 C 0 8 1333 0 0 0.0059656972 D 0 0 9 1249 1 0.0079428118 E 0 0 0 5 1407 0.0035410765

The final random forest model is 99.5% accurate with 7,653 matches and 36 mismatches out of 7,689 training observations.

Predictions

Predicted values should match observed values, i.e., 20/20, because user_name and num_window are common factors in both training and test datasets.
