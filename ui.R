library(shiny)
library(dplyr)


statechoices <- as.character(unique(cost$StateOrDistrict))

shinyUI(navbarPage("Cost-Of-Living Adjustment Calculator (United States)", id="nav", 
                   
           tabPanel("Instructions",
                    headerPanel("Instructions"),
                    br(),
                    br(),
                    h4("On the 'Input Details' Tab:"),
                    br(),
                    h5("1 - Select the state or district where you presently reside from the pull-down menu in the sidebar panel."),
                    br(),
                    h5("2 - A new pull-down menu will now appear to allow you to choose only those urban areas within the state or district that you specifed in step 1. Choose the urban area nearest to where you presently live. In the main panel, the data table for your current location will populate."),
                    br(),
                    h5("3 - A new pull down menu will now appear to allow you to choose the state or district that contains your destination. Choose one."),
                    br(),
                    h5("4 - A new pull-down menu will now appear to allow you to choose only those urban areas within the destination state or district that you specifed in step 3. Choose the urban area nearest to where you might move. In the main panel, the data table for your destination will populate."),
                    br(),
                    h5("5 - A scrolling text box will now appear to allow you to specify your current or most recent annual income in US dollars. The default value is 50000. Scroll or overwrite within the box to change the value. Use only numbers, no commas."),
                    br(),
                    h5("6 - After you have entered all five inputs, proceed to the 'See Results' tab.")
           ),
           
                   
           tabPanel("Step 1: Input Details",
                    headerPanel("Input Details"),
                    sidebarPanel( 
                            fluidRow(
                              column(5,
                                     selectInput("currentstates", "Current State or District", c("Choose"="", statechoices), multiple=FALSE)
                                    ),
                              column(8,
                                     conditionalPanel("input.currentstates",
                                                      selectInput("currentcities", "Nearest Urban Area (Current)", c("Choose"=""), multiple=FALSE)
                                                     )
                                    ),
                              
                              column(5,
                                     conditionalPanel("input.currentcities",
                                                      selectInput("deststates", "Destination State or District", c("Choose"="", statechoices), multiple=FALSE)
                                                      )
                                    ),
                              column(8,
                                     conditionalPanel("input.deststates",
                                                      selectInput("destcities", "Nearest Urban Area (Destination)", c("Choose"=""), multiple=FALSE)
                                     )
                              ),
                              column(8,
                                     conditionalPanel("input.destcities",
                              numericInput('income', 'Overwrite or Scroll to Enter Current Annual Income (USD$/Year), No Commas', 50000, min = 0, max = 1000000, step = 100)
                                                      )
                              )
                            )
                    ),
                    
                    mainPanel(
                              h3("Current Location"),
                              dataTableOutput("currenttable"),  
                              h3("Destination"),
                              dataTableOutput("desttable")
                            )
                    ),
                 
           
           tabPanel("Step 2: See Results",
                    headerPanel("Results"),
                    
                    mainPanel(
                      tableOutput("values"),
                      h4('You will need'),
                      uiOutput("projection"),
                      h4('dollars to maintain an equivalent lifestyle at your new destination.'),
                      br(),
                      h4('This is'),
                      uiOutput("projpercent"),
                      h4('percent of your current baseline income.')
                      
                    )
           ),
           
           
           tabPanel("About",
                    headerPanel("About"),
                    br(),
                    br(),
                    h4("Sources and Methods:"),
                    h5("Data is taken from the 2012 Statistical Abstract of the United States, produced by the US Census Bureau:"),
                    br(),
                    h5("http://www.census.gov/compendia/statab/cats/prices/consumer_price_indexes_cost_of_living_index.html, Report 728."),
                    br(),
                    h5("Data are for a selected urban area within the larger metropolitan area shown. Measures relative price levels for consumer goods and services in participating areas for a mid-management standard of living."),
                    br(),
                    h5("The nationwide average equals 100 and each index is read as a percent of the national average."),
                    br(),
                    h5("The index does not measure inflation, but compares prices at a single point in time."),
                    br(),
                    h5("Excludes taxes."),
                    br(),
                    h5("Metropolitan areas as defined by the Office of Management and Budget."),
                    br(),
                    br(),
                    h4("Interpreting the Index:"), 															
                    br(),
                    h5("The ACCRA Cost of Living Index measures relative price levels for consumer goods and services in participating areas. The average for all participating places, both metropolitan and nonmetropolitan, equals	100, and each participant's index is read as a percentage of the average for all places."),															
                    br(),
                    h4("How to Use the ACCRA Cost of Living Index:"), 															
                    br(),
                    h5("Assume that City A has a composite index of 98.3 and City B has a composite index of 128.5. If you live in City A and are contemplating a job offer in City B, how much of an increase in your after-tax income is needed to maintain your present lifestyle?"),															
                    br(),
                    h5("100*[(City B - City A)/City A] = 100*(.3072) = 30.72% Increase"),															
                    br(),
                    h5("Conversely, if your are considering a move from City B to City A, how much of a cut in after-tax income can	you sustain without reducing your midmanagement lifestyle?"),															
                    br(),
                    h5("100*[(City A - City B)/City B] = 100*(-.2350) = 23.5% Decrease")															

                    )
           )
           
      )
