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

navbarPage(title="Tassie Sat Data Viewer",id = 'main',theme = shinytheme("united"),
           # inverse=T,
           collapsible = T,
           tabPanel(title =icon("globe"),
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
#                         absolutePanel(top = 10,
#                                       left = 200,
#                                       draggable = F,
#                                       width='auto',
#                                       height='auto',
#                                       #                                       div(class='row-fluid',
#                                       #                                           div(class='span6',
#                                       selectInput("dataType", label = NULL,
#                                                   c("Chlorophyll" = "chl",
#                                                     "Sea Surface Temperature" = "sst"))
#                         ),
#                         
                        absolutePanel(top = 10,
                                      left = 50,
                                      draggable = F,
                                      width=140,
                                      height='auto',
                                      dateInput(inputId = 'chl_date', label = NULL,min = '2013-01-01', max='2013-02-28', value = '2013-02-04'),
                                      uiOutput('plot_type')
                        ),
                        absolutePanel(top = 10,
                                      #left = 220,
                                      right = 10,
                                      draggable = TRUE,
                                      width=300,
                                      height='auto',
                                      plotOutput('legend', height = "95px", width = "100%"),
                                      style = "opacity: 0.90; padding: 8px;"
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
           tabPanel(title = icon("info-sign", lib = "glyphicon"),
                    mainPanel(
                      h1("Welcome!"),
                      p("This is a demo dashboard for viewing ocean satellite data around Tasmania. It was build by Rob Johnson (robtheoceanographer[at]gmail.com) and is a prototype for future work."),
                      h2("Disclaimer"),
                      p("You are solely responsible for your use of this site (and any information or material available from it) and you accept all risks and consequences that might arise from your use of this site (and any information or material available from it)."),
                      p("This includes:"),
                      p("- any risk of your computer, software or data being damaged by any virus, disabling codes, worms or other devices and defects which might be transmitted or activated via the website, or your access to it or the downloading of files from the web site; and"),
                      p("- any risk of connections transmitted to and from this site being intercepted and modified by third parties."),
                      p(""),
                      p("The blokes who made this site (or the data shown) are not in any way liable for losses, damages, costs, expenses and liability of any kind that you or any other person may suffer or incur directly or indirectly from you using this site and any information or material available from it.")
                      
                    )
           )
           
           
)