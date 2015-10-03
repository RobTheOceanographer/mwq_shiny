# load some libraries
#library(shiny)
library(png)
library(leaflet)
library(ncdf4)
library(raster)

shinyUI(navbarPage("eReefs Ocean Colour Viewer",
    
    # Vis imagery panel.   
    tabPanel("Vis",
        sidebarPanel(
            dateInput('date', label = 'Date input: yyyy-mm-dd', value = Sys.Date()-1, max = Sys.Date()-1),
            width = 2),
        mainPanel(
            verbatimTextOutput("dateText"),
            verbatimTextOutput("urlText"),
            plotOutput('plot1', width = "100%",inline = FALSE)
        )
    ),
    
    
    # Data mapping panel
    tabPanel("Data",
             
             sidebarPanel(
               h5('set date'),
               dateInput(inputId = 'chl_date', label = 'Date',min = '2002-01-01', value = Sys.Date()-1,
                         max = Sys.Date()-1),
                         width = 2),
             
             mainPanel(
               plotOutput('legend', width = "100%", height = "80px",inline = FALSE),
               verbatimTextOutput("chl_url_Text"),
               leafletOutput("mymap",width="100%")
               
               
             )
    )
    
             
))
        
        
        
        
        
