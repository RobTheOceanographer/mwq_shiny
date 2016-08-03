# 
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#

# http://shiny.rstudio.com
##
#library(shinyIncubator)

# load some libraries
#library(shiny)
library(png)
library(leaflet)
library(ncdf4)
library(raster)
library(shiny)
library(shinyBS)
library(shinyjs)
library(shinythemes)

navbarPage(title="SST Climatology Viewer",id = 'main',theme = shinytheme("united"),
           # inverse=T,
           collapsible = T,
           tabPanel("Disclaimer", icon = icon("cog", lib = "glyphicon"),
                    mainPanel(
                      #h1(""),
                      h2("This webpage contains a set of climatologies of sea surface temperature (SST) around Tasmania."),
                      p("You are solely responsible for your use of this site (and any information or material available from it) and you accept all risks and consequences that might arise from your use of this site (and any information or material available from it)."),
                      hr(),
                      h3("If you proceed past this page you fully agree to and accept the disclaimer detailed at the following link:"),
                      a(href="http://www.bom.gov.au/other/disclaimer.shtml","http://www.bom.gov.au/other/disclaimer.shtml"),
                      hr(),
                      h4("To proceed to the maps of SST click on the Globe symbol next to the work 'Map' at the top of this page."),
                      width = 12)
           ),
           tabPanel("Map",icon = icon('globe'),
                    div(class="outer",
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css")
                        ),
                        leafletOutput('mymap',width="100%",height='100%'),
                        
                        #                         absolutePanel(#id = "controls",
                        #                           #class='modal',
                        #                           fixed=T,
                        #                           draggable = F,
                        #                           top = 'auto',
                        #                           left= 10,#'auto',
                        #                           right = 'auto',
                        #                           bottom=50,
                        #                           height='auto',
                        #                           width = 'auto',
                        #                           textOutput('mouselatlon')
                        #                         ),
                        #                         
                        absolutePanel(top = 10,
                                      left = 50,
                                      draggable = F,
                                      width=140,
                                      height='auto',
                                      #dateInput(inputId = 'chl_date', format = "MM",startview = "year", label = NULL,min = NULL, value = NULL, max =NULL),
                                      selectInput(
                                        inputId =  "phase", 
                                        label = "Select a phase:", 
                                        choices = c("Neutral" = "neutral",
                                                    "La Nina (cool)" = "la_nina",
                                                    "El Nino (warm)" = "el_nino")
                                      ),
                                      selectInput(
                                        inputId =  "month", 
                                        label = "Select a Month:", 
                                        choices = c("Jan" = "jan",
                                                    "Feb" = "feb",
                                                    "Mar" = "mar",
                                                    "Apr" = "apr",
                                                    "May" = "may",
                                                    "Jun" = "jun",
                                                    "Jul" = "jul",
                                                    "Aug" = "aug",
                                                    "Sep" = "sep",
                                                    "Oct" = "oct",
                                                    "Nov" = "nov",
                                                    "Dec" = "dec")
                                      ),
                                      uiOutput('plot_type')
                                      # bsProgressBar("TSpb", visible=FALSE, striped=TRUE),
#                                       bsTooltip('slt_date','Date of mapped layer'),
#                                       bsTooltip('btn_ext','Plot SST data at markers'),
#                                       bsTooltip('btn_clr','Clear Markers'),
#                                       bsTooltip('slt_ptype','Change plot type'),
#                                       bsAlert('a1')
                        ),
                        # absolutePanel(top = 10,
                        #               #left = 220,
                        #               right = 10,
                        #               draggable = TRUE,
                        #               width=300,
                        #               height='auto',
                        #               #                                       div(class='row-fluid',
                        #               #                                           div(class='span6',
                        #               plotOutput('legend', height = "80px", width = "100%"),
                        #               # ),
                        #               # div(class='span6',
                        #               #actionButton('btn_clr',label = icon('refresh'))
                        #               # )
                        #               # )
                        #               style = "opacity: 0.90; padding: 8px; background: #FFFFEE;"
                        # ),
                        absolutePanel(bottom = 20,
                                        right = 100,
                                      draggable = F,
                                      width='auto',
                                      height='auto',
                                      #a(content),
                                      a(),
                                      style = "opacity: 0.90; padding: 5px; background: #FFFFEE;"
                        ),

                        absolutePanel(bottom = 20,
                                      right = 10,
                                      draggable = F,
                                      width='auto',
                                      height='auto',
                                      a(icon('github fa-2x'),href='https://github.com/RobTheOceanographer',target='_blank'),
                                      a(icon('twitter fa-2x'),href='https://twitter.com/JohnsonRob',target='_blank')
                        ),
                        uiOutput('plot_UI')
                    )
           )
)