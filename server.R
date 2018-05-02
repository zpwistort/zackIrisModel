

# Define server logic required to draw a histogram
shinyServer(function(input, output){
  

  
  slides<-reactive({
  
              data.frame(
                
                Sepal.Length = input$Sepal.Length
                ,Sepal.Width = input$Sepal.Width
                ,Petal.Length = input$Petal.Length
                ,Petal.Width = input$Petal.Width
                
              )
  })
  
  
  predTable<-reactive({
        
        
        Preds <- predict(Iris.model, newdata = as.matrix(slides())) # calculate prediction
        
        
           a<-        # build a table for predicted data
            data.frame(
                    
                x = var.levels
                ,Preds=round(Preds,3)
                    
              )%>%
              spread(x, Preds)
        
      return(a)
    

    
  })
  
  
  output$irisPlot <- renderPlot({
    
    cols<- c("#a6cee3", "#1f78b4", "#b2df8a")
    cols2<- c('#1b9e77','#d95f02','#1f78b4')
    
    # ggplot(iris)+
    #   geom_point(aes(x=Sepal.Length,y=Petal.Length,color=Species),size=3,alpha=0.8)+
    #   geom_point(aes(x=test[1],y=test[2],shape=factor(15)),color='black',size=4)+
    #   scale_shape_manual(values=15,labels=c('Slider Point'))+
    #   scale_color_manual(values=cols2)+
    #   theme(
    #     legend.title = element_blank()
    #   )

    ggplot(iris, aes(x=iris[[input$xcol]], y=iris[[input$ycol]], color=Species))+
      geom_point(data=slides(), aes(x=slides()[[input$xcol]], y=slides()[[input$ycol]],shape=factor('slider')),
                 color='black',alpha=0.4,size=7)+
      geom_point(size=4)+
      ggtitle('Iris data')+
      xlab(input$xcol)+
      ylab(input$ycol)+
      scale_shape_manual(name='Slider Input',values=15,labels=c('Values'))+
      scale_color_manual(values=cols,labels=c('Setosa','Verisicolor','Virginica'))+
      theme_classic()+
      theme(
        text = element_text(size = 14,face='bold')
      )
    
    
  })
  
  output$importancePlot <- renderPlot({
    
    
    Iris.model.important<-xgb.importance(feature_names = var.names, model=Iris.model)
    
    df<-as.data.frame(Iris.model.important)
    
    ggplot(df, aes(x=reorder(factor(Feature), -Gain),y=Gain))+
      geom_bar(stat='identity')+
      xlab('Feature')+
      ylab('Gain')+
      ggtitle('Importance of Variables')+
      theme_classic()+
      theme(
        text = element_text(size = 14, face='bold')
      )

  })
  
  
  
  output$data <- renderDT(iris, options = list(scrollX = TRUE))
  
  output$table <- renderDataTable(predTable(),
                                  class = 'cell-border stripe', 
                                  rownames = FALSE,
                                  colnames = c('Setosa' = 'setosa',
                                               'Virginica' = 'virginica',
                                               'Versicolor' = 'versicolor'),
                                  options = list(autoWidth=TRUE,
                                                 columnDefs = list(list(className = 'dt-center', targets = 0:2)),
                                                 paging = FALSE,
                                                 searching = FALSE))

  
  





  output$densityPlot1 <- renderPlot({
    
    ggplot(iris,aes(x=iris[[input$xcol]]))+
      geom_density(aes(fill=Species),alpha=0.5)+
      ggtitle('X Variable density plot')+
      ylab('Density')+
      xlab(input$xcol)+
      scale_fill_manual(values=cols,labels=c('Setosa','Verisicolor','Virginica'))+
      theme_classic()+
      theme(
        text = element_text(size = 14, face='bold')
      )
  
  })
  
  output$densityPlot2 <- renderPlot({
    
    ggplot(iris,aes(x=iris[[input$ycol]]))+
      geom_density(aes(fill=Species),alpha=0.5)+
      ggtitle('Y Variable density plot')+
      ylab('Density')+
      xlab(input$ycol)+
      scale_fill_manual(values=cols,labels=c('Setosa','Verisicolor','Virginica'))+
      theme_classic()+
      theme(
        text = element_text(size = 14, face='bold')
      )
    
  })


    
})   
    
    
    
    
    
    
    
    
    