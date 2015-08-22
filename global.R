library(shiny)
library(dplyr)


data <- read.csv('col.csv')
cost <- tbl_df(data)