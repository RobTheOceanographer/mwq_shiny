# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
require(leaflet)
library(shiny)

shinyUI(fluidPage(
  
  titlePanel("eReefs Shiny Ocean Colour Viewer"),
  
  
    sidebarPanel(
      h5('set date'),
      dateInput(inputId = 'date',
                label = 'Date',min = '2013-01-01',
                max = Sys.Date()-3)
      ,width = 3),
    
    mainPanel(
      
        leafletOutput("mymap", height=800)
        
      
      )
    )
)

