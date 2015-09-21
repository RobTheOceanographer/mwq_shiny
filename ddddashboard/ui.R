



shinyUI(navbarPage("eReefs Ocean Colour Viewer",
    
    # Vis imagery panel.   
    tabPanel("Vis",
        sidebarPanel(
            dateInput('date', label = 'Date input: yyyy-mm-dd', value = Sys.Date()-1, max = Sys.Date()-1) 
        ),
        mainPanel(
            verbatimTextOutput("dateText"),
            verbatimTextOutput("urlText"),
            plotOutput('plot1', width = "100%", height = "400px",inline = FALSE)
        )
    ),
    
    
    # Data mapping panel
    tabPanel("Data",
             
             sidebarPanel(
               h5('set date'),
               dateInput(inputId = 'chl_date', label = 'Date',min = '2013-01-01',
                         max = Sys.Date()-3),
                         width = 3),
             
             mainPanel(
               plotOutput('legend', width = "100%", height = "80px",inline = FALSE),
               
               leafletOutput("mymap", height=800)
               
               
             )
    )
    
             
))
        
        
        
        
        