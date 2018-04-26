

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  
  
  
  predTable<-reactive({
    
        a<-
        data.frame(

                    Sepal.Length = input$Sepal.Length
                   ,Sepal.Width = input$Sepal.Width
                   ,Petal.Length = input$Petal.Length
                   ,Petal.Width = input$Petal.Width
                   
                 )
        
        
        Preds <- predict(Iris.model, newdata = as.matrix(a)) # calculate prediction
        
        
        PredTable<-            # build a table for predicted data
                  data.frame(
                    
                    x = var.levels
                    ,Preds=round(Preds,2)
                    
                  )%>%
                  spread(x, Preds)
        
        
        a<-cbind(a,PredTable)
    

    
  })
  
  
  output$irisPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    # x    <- faithful[, 2] 
    # bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    ggplot(iris, aes(x=iris[[input$xcol]], y=iris[[input$ycol]], color=Species))+
      geom_point(size=4)+
      # geom_point()
      ggtitle('Iris data')+
      xlab(input$xcol)+
      ylab(input$ycol)+
      theme_classic()+
      theme(
        text = element_text(size = 14,face='bold')
      )
    
  })
  
  output$data <- renderDT(iris)
  
  output$predTable <- renderDataTable(predTable(), options = list(autoWidth=TRUE,
                                                                  columnDefs = list(list(className = 'dt-center', targets = 0:7))))

  
  
    
})
