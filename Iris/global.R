library(tidyverse)
library(xgboost)
library(shiny)
library(DT)


calculate_xgb_preds<-
function(x,var.levels,PredModel,testData){


    n = seq(1,length(testdata[,1]))

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

}










