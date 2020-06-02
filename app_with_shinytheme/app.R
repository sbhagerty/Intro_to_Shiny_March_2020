#####
#Global 
library(shiny)
library(shinythemes)
library(tidyverse)

data<-read_csv("data.csv") %>% mutate(AGE= factor(AGE, c("<1","1-4","5-9","10-14","15-19","20-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79",
                                                         "80-84","85+")))

# Dataset is from CDC at https://gis.cdc.gov/Cancer/USCS/DataViz.html
######

ui <- fluidPage(theme= shinytheme("cyborg"),
titlePanel("Rate of New Cancers by Age Group"),
          sidebarLayout(
  
sidebarPanel(
selectInput("SITE", "Cancer Type", choices = unique(data$SITE)),
selectInput("YEAR", "Year", choices = unique(data$YEAR))   

), 

mainPanel(
plotOutput("plot")
)
))


server <- function(input, output) {

    output$plot<-renderPlot({
        ggplot(filter(data, SITE == input$SITE, YEAR==input$YEAR))+
            geom_bar(aes(x=AGE, y=as.numeric(RATE)), stat="identity")+
            ylab("Rate per 100,000 people")+
            xlab("Age Group (years)")+
            theme_classic()
    })

}

shinyApp(ui = ui, server = server)
