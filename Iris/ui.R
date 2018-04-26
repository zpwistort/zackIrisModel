# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
                    # Application title
                    titlePanel("Iris Boosted Gradient Model"),
                    
                    # Sidebar with a slider input for number of bins 
                    sidebarLayout(
                                    sidebarPanel(

                                                   
                                                   selectInput('xcol', 
                                                               'X Variable', 
                                                               names(iris)[-length(names(iris))])
                                                   
                                                   ,selectInput('ycol', 
                                                                'Y Variable', 
                                                                names(iris)[-length(names(iris))],
                                                                selected=names(iris)[[2]]  # so they both dont start on the same variable
                                                               )
                                                   
                                                   ,sliderInput("Sepal.Length",
                                                                "Sepal.Length:",
                                                                min = min(round(iris$Sepal.Length,1)),
                                                                max = max(round(iris$Sepal.Length,1)),
                                                                value = median(round(iris$Sepal.Length,1)),
                                                                step = 0.1)
                                                   
                                                   ,sliderInput("Sepal.Width",
                                                                "Sepal.Width:",
                                                                min = min(round(iris$Sepal.Width,1)),
                                                                max = max(round(iris$Sepal.Width,1)),
                                                                value = median(round(iris$Sepal.Width,1)),
                                                                step = 0.1)
                                                   
                                                   ,sliderInput("Petal.Length",
                                                                "Petal.Length:",
                                                                min = min(round(iris$Petal.Length,1)),
                                                                max = max(round(iris$Petal.Length,1)),
                                                                value = median(round(iris$Petal.Length,1)),
                                                                step = 0.1)
                                                   
                                                   ,sliderInput("Petal.Width",
                                                                "Petal.Width:",
                                                                min = min(round(iris$Petal.Width,1)),
                                                                max = max(round(iris$Petal.Width,1)),
                                                                value = median(round(iris$Petal.Width,1)),
                                                                step = 0.1)
                                                   

                                    ),
                      
                      # Show a plot of the generated distribution
                                    mainPanel(
                                      
                                
                                        # Output: Tabset w/ plot, summary, and table ----
                                        tabsetPanel(type = "tabs",
                                                    tabPanel("Plot",plotOutput("irisPlot")),
                                                    tabPanel("Table")
                                        )
                                
                                    
                                    )
                    )

      )
)











