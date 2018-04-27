

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  
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
    

    ggplot(iris, aes(x=iris[[input$xcol]], y=iris[[input$ycol]], color=Species))+
      geom_point(size=4)+
      geom_point(data=slides(), aes(x=slides()[[input$xcol]], y=slides()[[input$ycol]]), color='red',size=4)+
      ggtitle('Iris data')+
      xlab(input$xcol)+
      ylab(input$ycol)+
      theme_classic()+
      theme(
        text = element_text(size = 14,face='bold')
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

  
  
    
})
















p<-
ggplot(iris, aes(x=Sepal.Length))+
  geom_density(aes(fill= Species))


ggsave('test',plot=p,device=pdf)









