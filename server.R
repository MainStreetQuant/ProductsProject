library(shiny)
library(dplyr)

shinyServer(function(input, output, session) {
  

  
  ## Current Location ###########################################
  
  observe({
    currentcities <- if (is.null(input$currentstates)) character(0) else {
      filter(cost, StateOrDistrict %in% input$currentstates) %>%
        `$`('UrbanArea') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$currentcities[input$currentcities %in% currentcities])
    updateSelectInput(session, "currentcities", choices = as.character(currentcities),
                      selected = stillSelected)
  })
  

  output$currenttable <- renderDataTable({
    cost %>%
      filter(
        is.null(input$currentstates) | StateOrDistrict %in% input$currentstates,
        is.null(input$currentcities) | UrbanArea %in% input$currentcities
      ) 
  }, options = list(lengthMenu = FALSE, pageLength = 1, escape = FALSE, searching = FALSE))

  

  ## Destination ###########################################

observe({
  destcities <- if (is.null(input$deststates)) character(0) else {
    filter(cost, StateOrDistrict %in% input$deststates) %>%
      `$`('UrbanArea') %>%
      unique() %>%
      sort()
  }
  stillSelected <- isolate(input$destcities[input$destcities %in% destcities])
  updateSelectInput(session, "destcities", choices = as.character(destcities),
                    selected = stillSelected)
})


output$desttable <- renderDataTable({
  cost %>%
    filter(
      is.null(input$deststates) | StateOrDistrict %in% input$deststates,
      is.null(input$destcities) | UrbanArea %in% input$destcities
    ) 
}, options = list(lengthMenu = FALSE, pageLength = 1, escape = FALSE, searching = FALSE))



  ## Compose Data Frame and Calculate ###########################################


Values <- reactive({
  
  # Compose data frame
  data.frame(
    Name = c("CurrentState", "CurrentCity", "DestinationState", "DestinationCity", "BaseIncome"),
    
    Value = c(input$currentstates,input$currentcities,input$deststates,input$destcities,input$income),
    
    stringsAsFactors=FALSE)
})


projection <- function(CurrentState, CurrentCity, DestState, DestCity, BaseIncome){
  currentdata <- filter(cost,CurrentState == cost$StateOrDistrict, CurrentCity == cost$UrbanArea)
  currentindex <- as.numeric(currentdata[3])
  destdata <- filter(cost,DestState == cost$StateOrDistrict, DestCity == cost$UrbanArea)
  destindex <- as.numeric(destdata[3])
  proj <- sprintf("%.2f",round((BaseIncome/currentindex)*(destindex),2)) 
  proj
} 

projpercent <- function(CurrentState, CurrentCity, DestState, DestCity, BaseIncome) {
  currentdata <- filter(cost,CurrentState == cost$StateOrDistrict, CurrentCity == cost$UrbanArea)
  currentindex <- as.numeric(currentdata[3])
  destdata <- filter(cost,DestState == cost$StateOrDistrict, DestCity == cost$UrbanArea)
  destindex <- as.numeric(destdata[3])
  proj <- (BaseIncome/currentindex)*(destindex)
  projper <- sprintf("%.2f",round((proj/BaseIncome)*100,2))
  projper
  
} 


output$projection <- renderText(
  {projection(input$currentstates,input$currentcities,input$deststates,input$destcities,input$income)}
)
  

output$projpercent <- renderText(
  {projpercent(input$currentstates,input$currentcities,input$deststates,input$destcities,input$income)}
)

})
