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

navbarPage(title="eReefs MWQ Chlorophyll Viewer",id = 'main',theme = shinytheme("united"),
           # inverse=T,
           collapsible = T,
           tabPanel(title = icon('globe'),
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
                                      dateInput(inputId = 'chl_date', label = NULL,min = '2002-01-01', value = Sys.Date()-1,max = Sys.Date()-1),
                                      uiOutput('plot_type')
                                      # bsProgressBar("TSpb", visible=FALSE, striped=TRUE),
#                                       bsTooltip('slt_date','Date of mapped layer'),
#                                       bsTooltip('btn_ext','Plot SST data at markers'),
#                                       bsTooltip('btn_clr','Clear Markers'),
#                                       bsTooltip('slt_ptype','Change plot type'),
#                                       bsAlert('a1')
                        ),
                        absolutePanel(top = 10,
                                      #left = 220,
                                      right = 10,
                                      draggable = TRUE,
                                      width=300,
                                      height='auto',
                                      #                                       div(class='row-fluid',
                                      #                                           div(class='span6',
                                      plotOutput('legend', height = "80px", width = "100%"),
                                      # ),
                                      # div(class='span6',
                                      #actionButton('btn_clr',label = icon('refresh'))
                                      # )
                                      # )
                                      style = "opacity: 0.90; padding: 8px; background: #FFFFEE;"
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
           ),
           tabPanel(title = icon('map-marker'),
                    dataTableOutput('table')
           )
           
           
)