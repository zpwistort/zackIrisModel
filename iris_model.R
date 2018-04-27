### Create a shiny application that hosts a multi-class classification model for the iris dataset (loaded in base R). The user should be able to modify the inputs (use a sliderInput or numericInput) and see what predictions the model is generating





# Version control
# 1. Create a github repo for your applications and push you changes up




# Model
# 1. Create a folder "inst" and add a model script that builds and saves a model
# 2. Build a multi-class classification model predicting the Species. I recommend using xgboost but you have the freedom to use whatever method you would like
# 3. If you use xgboost use objective = multi:softprob and eval_metric = mlogloss



# global.R
# 1. In the global file load up the model and prepare a function for generating a prediction table





# shiny app (ui.R and server.R)
# 1. add numericInputs and/or sliderInputs for your predictors (Sepal.Length, Sepal.Width, Petal.Length, and Petal.Width) and pass those values into your server to generate a table of probabilities of each Species. Sort this so the highest probability is on top
# 2.




# plots (This is a great reference - https://www.mailman.columbia.edu/sites/default/files/media/fdawg_ggplot2.html)
# 1. Scatterplot with Sepal Length and Sepal Width. Color based on the Species and add a red point on the plot that shows where the values are set for prediction
# 2. Create density plots for Sepal.Length, Sepal.Width, Petal.Length, and Petal.Width that have a vertical line demonstrating where the sliders are set. For these plots set the fill to Species to add additional context

# To complete the assignment push your changes up to github and submit the url for the repo to Canvas.



library(tidyverse)
library(xgboost)


#function to sample the iris dataset
random_sample<-
  function(x, df, colname, n=15){
    
    df%>%
      filter(df[[colname]] == x)%>%
      sample_n(n)
    
  }

# load data as a tibble
iris=as.tibble(iris)
iris$id<- seq(1,dim(iris)[1],1)


# Made a training dataset from random sample of 30% of iris data
labels<- levels(iris[['Species']])
Train<- rbind(
  random_sample(labels[1],iris,'Species'),
  random_sample(labels[2],iris,'Species'),
  random_sample(labels[3],iris,'Species')
)

Test=iris[-c(Train$id),]


# check to make sure everything worked right, Train = 45, Test = 105
dim(Train)
dim(Test)

###############################################################################################################



y1 <- Train$Species # pull Species column
var.levels <- levels(y1) # grab levels for later labeling
y = as.integer(y1)-1 # convert labels from factor to integer; set to 0,1,2

x = Train[,-c(5,6)] # grab training dataset and remove species column; this is what I are trying to predict
var.names <- names(x) # names of the explanitory variables
x <- as.matrix(x) # convert to matrix for xgboost

# set model parameters
params <- list(
   
   'objective' = "multi:softprob" # one vs. all method
  ,'eval_metric' = "mlogloss" # how to evaluate
  ,'num_class'= length(table(y))
  ,'eta' = .2 # volume knob
  ,'max_depth' = 5
  
)

# set round limit
cv.nround=4000


# run gradient model
bst.cv <- xgb.cv(param = params, data = x, label = y, nfold = 5, 
                 nrounds = cv.nround, missing = NA, prediction = TRUE)


# bounce around between the eta value and cv.nrounds to find bottom out




# look at logs, find model which minimized mlogloss, CROSS VALIDATION!!

bst.cv$evaluation_log

nrounds = which.min(bst.cv$evaluation_log$test_mlogloss_mean)

bst.cv$evaluation_log[nrounds] # determine which model bottoms it out


# builds the model at the round which was min mlogloss
IrisSpecies<- xgboost(param = params
               , data = x, label = y
               , nround = nrounds
               , missing = NA)





xgb.importance(var.names, model = IrisSpecies) # which variables were most important






# gather all predictions from boosted model

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
              mutate(predID = i)%>%
              spread(x, Preds)


    }
    return(PredTable)

}





P<-calculate_xgb_preds(var.levels,IrisSpecies,testData=Test[,-c(5,6)]) # test FUNCTION!!!!!!! You DINGDONG




# > row1<- as.matrix(Test[2,-c(5,6)])
# > Preds <- predict(IrisSpecies, newdata = row1) # calculate predictions
# > data.frame(
#   +     
#     +    Species = var.levels
#   +     ,Preds
#   +   )%>%
#   +   #arrange(desc(Preds))%>%
#   +   mutate(group = 1)%>%
#   +   spread(Species, Preds)



a<-
  data.frame(
    
    Sepal.Length = 5.3
    ,Sepal.Width = 3
    
  )


ggplot(iris, aes(x=iris[['Sepal.Length']], y=iris[['Sepal.Width']], color=Species))+
  geom_point(size=4)+
  geom_point(data=a, aes(x=a[['Sepal.Length']], y=a[['Sepal.Width']]), color='red',size=4)+
  ggtitle('Iris data')+
  theme_classic()+
  theme(
    text = element_text(size = 14,face='bold')
  )


















