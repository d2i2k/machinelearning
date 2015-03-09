---
title: "Prediction Assignment"
author: "d2i2k"
date: "Sunday, March 22, 2015"
output: pdf_document
---

# Question

## How well did the six participants perform their weight lifting exercises based on pre-specified, qualitative activity recognition classification? 

# Training and Testing Data

```{r}
pml_training<-read.csv("http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv",na.strings=c("NA",""))
dim(pml_training) # 19622 rows, 160 cols
pml_testing<-read.csv("http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv",na.strings=c("NA",""))
dim(pml_testing)  # 20 rows, 160 cols
```

# Pre-Processing Steps

Step 1. Delete 100 columns with unavailable (NA) or missing ("") data.

```{r}
non_missing <- apply(!is.na(pml_training),2,sum)>19621
pml_training1 <- pml_training[,non_missing]
dim(pml_training1)  # 19,622 rows, 60 cols
non_missing <- apply(!is.na(pml_testing),2,sum)>19
pml_testing2 <- pml_testing[,non_missing]
dim(pml_testing2)  # 20 rows, 60 cols
```

Step 2. Delete 406 rows in which the new_window variable equals "yes." 

```{r} 
pml_training2 <- subset(pml_training1,new_window=="no")
dim(pml_training2)  # 19,216 rows, 60 cols 
```

Step 3. Delete index, timestamps and new_window variable (Columns 1, 3-6). The remaining columns include 54 predictors and the classe variable.

```{r} 
pml_training2_user_name <- pml_training2[,2]
pml_training2_predictors <- pml_training2[7:60]
pml_training3 <- cbind(pml_training2_user_name,pml_training2_predictors)
dim(pml_training3) # 19,216 rows, 55 cols 
pml_testing2_user_name <- pml_testing2[,2]
pml_testing2_predictors <- pml_testing2[,7:60]
pml_testing3 <- cbind(pml_testing2_user_name,pml_testing2_predictors)
dim(pml_testing3) # 20 rows, 55 cols 
```

## Training Subset

```{r} 
library(caret)
InTrain = createDataPartition(pml_training3$classe,p=0.4)[[1]]
training <- pml_training3[InTrain,] # 7689 rows, 55 cols
dim(training)                        
```

# Algorithm

## Boosted Trees Model

A generalized boosted (gbm) regression model was fitted to training data using the train function.

```{r}
gbmModel <- train(classe~.,method="gbm",data=training,verbose=FALSE)
print(gbmModel$finalModel)
gbmPredictions <- predict(gbmModel,training)
confusionMatrix(training$classe,gbmPredictions)
```

## Random Forest Model

A random forest (rf) model was fitted to training data using the train function with five-fold cross validation (cv).

```{r}
rfModel <-train(classe~.,data=training,method="rf", trControl=trainControl(method="cv",number=5), prox=TRUE,allowParallel=TRUE)
print(rfModel$finalModel)  
```

### Out-of-Sample Error

The random forest model should be highly accurate due to the large sample size of the training data and five-fold cross validation, # i.e., OOB error < 0.5%.

### Predictions

Predicted values should match actual values because user name and window number are common factors in both training and test datasets, # i.e., 20 out of 20.

