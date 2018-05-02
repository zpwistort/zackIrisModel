library(tidyverse)
library(xgboost)


head(iris)
Train<-iris


y1 <- Train$Species # pull Species column
var.levels <- levels(y1) # grab levels for later labeling
y = as.integer(y1)-1 # convert labels from factor to integer; set to 0,1,2

x = Train[,-5] # grab training dataset and remove species column; this is what I are trying to predict
var.names <- names(x) # names of the explanitory variables
x <- as.matrix(x) # convert to matrix for xgboost

# set model parameters
params <- list(
  
  'objective' = "multi:softprob" # one vs. all method
  ,'eval_metric' = "mlogloss" # how to evaluate
  ,'num_class'= length(table(y))
  ,'eta' = .01 # volume knob
  ,'max_depth' = 5
  
)

# set round limit
cv.nround=2000


# run gradient model
bst.cv <- xgb.cv(param = params, data = x, label = y, nfold = 5, 
                 nrounds = cv.nround, missing = NA, prediction = TRUE)


# bounce around between the eta value and cv.nrounds to find bottom out




# look at logs, find model which minimized mlogloss, CROSS VALIDATION!!

#bst.cv$evaluation_log

nrounds = which.min(bst.cv$evaluation_log$test_mlogloss_mean)

bst.cv$evaluation_log[nrounds] # determine which model bottoms it out


# builds the model at the round which was min mlogloss
IrisSpecies<- xgboost(param = params
                      , data = x, label = y
                      , nround = nrounds
                      , missing = NA)



#xgb.importance(var.names, model = IrisSpecies)




xgb.save(IrisSpecies, 'Iris.model')














