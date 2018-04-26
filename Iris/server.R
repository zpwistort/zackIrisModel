
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  
  
  output$irisPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    # x    <- faithful[, 2] 
    # bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    ggplot(iris, aes(x=iris[[input$xcol]], y=iris[[input$ycol]], color=Species))+
      geom_point(size=4)+
      ggtitle('Iris data')+
      xlab(input$xcol)+
      ylab(input$ycol)+
      theme_classic()+
      theme(
        text = element_text(size = 14,face='bold')
      )
    
  })
  
  output$text <- renderText({

  
    
  })

  
  
    
})
