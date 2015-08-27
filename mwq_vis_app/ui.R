



shinyUI(navbarPage("MWQ HUD",
       
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
    tabPanel("Summary",
        sidebarPanel(
            p('Sidebar Area')
        ),
        mainPanel(
            p('Main Plot Area')
        )
    )
))
        
        
        
        
        