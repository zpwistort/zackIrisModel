library(tidyverse)
library(xgboost)
library(shiny)
library(DT)


calculate_xgb_preds<-
function(var.levels,PredModel,testData){


    n = seq(1,length(testData[,1]))

    for( i in n){

        row<- as.matrix(testData[i,]) # snag a row
        Preds <- predict(PredModel, newdata = row) # calculate prediction


        PredTable<-            # build a table for predicted data
              data.frame(

                 x = var.levels
                ,Preds

              )%>%
              spread(x, Preds)


    }

}

#function to sample the iris dataset
random_sample<-
  function(x, df, colname, n=15){
    
    df%>%
      filter(df[[colname]] == x)%>%
      sample_n(n)
    
  }



if(!exists("Iris.model")){
  
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
  Iris.model<- xgboost(param = params
                        , data = x, label = y
                        , nround = nrounds
                        , missing = NA)
  
    
}



# model <- xgb.load("Iris.model")
# 
# 
# a<-
# data.frame(
#   
#    Sepal.Length=5.1
#   ,Sepal.Width=3.5
#   ,Petal.Length=1.4
#   ,Petal.Width=0.2
#     
# )
# 
# 
# 
# predict(model,newdata=a)




















