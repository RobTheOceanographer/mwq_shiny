
# load some libraries
library(shiny)
library(png)
library(leaflet)
library(ncdf4)

shinyServer(function(input, output, session) {
  
  # input$date and others are Date objects. When outputting
  # text, we need to convert to character; otherwise it will
  # print an integer rather than a date.
  output$dateText  <- renderText({
    paste("input$date is", as.character(format(input$date,"%Y%m%d")))
  })

  
  output$plot1 <- renderPlot({
    usr_year = format(input$date,"%Y")
    usr_month = format(input$date,"%m")
    usr_day = format(input$date,"%d")
    usr_prod = "mwq"
    usr_base_url = "http://ereeftds.bom.gov.au/ereefs/tds/fileServer/ereef/mwq/png_files"
    
    #url_grid <-   "2015/07/20150710.png"
    usr_png_url = file.path(usr_base_url, paste(usr_year, usr_month, paste(usr_year,usr_month,usr_day,".png",sep=""), sep="/"))
    output$urlText  <- renderText({
      file.path(usr_base_url, paste(usr_year, usr_month, paste(usr_year,usr_month,usr_day,".png",sep=""), sep="/"))
    })
    
    
    download.file(usr_png_url, "current_image.png", method = "auto", quiet = FALSE, mode="wb", cacheOK = TRUE)
    usr_img <- readPNG('current_image.png')
    grid::grid.raster(usr_img)
    
    },height = 800, res = 500)
  
  ####### chlorophyll legend loader #######
  output$legend <- renderPlot({
    legend_img <- readPNG("CHL_chlor_a_colorscale.png")
    grid::grid.raster(legend_img)
    }, res = 500)
  
  
  ####### chlorophyll data with Leaflet #######
  output$mymap <- renderLeaflet({
    
    ## this is where the date string manipipulation should go ##
    # at the moment i'm only implementing the one day data but i would like to do all composites and have a selector for usr choice.
    # url_grid <- "http://ereeftds.bom.gov.au/ereefs/tds/dodsC/ereef/mwq/P1D/2015/A20150730.P1D.ANN_MIM_RMP.nc"
    usr_year = 2015
    usr_month = 03
    usr_day = 10
    #usr_year = format(input$chl_date,"%Y")
    #usr_month = format(input$chl_date,"%m")
    #usr_day = format(input$chl_date,"%d")
    usr_base_url = "http://ereeftds.bom.gov.au/ereefs/tds/dodsC/ereef/mwq/P1D"
    
    usr_grid_url = file.path(usr_base_url, paste(usr_year, usr_month, paste(usr_year,usr_month,usr_day,"*.nc",sep=""), sep="/"))
    
    ## This is product selection - maybe this will be done elsewhere in the future when it is usr selectable ##
    var_string <- "Chl_MIM"
    
    
    ## This is the chlorophyll leaflet itself ##
    leaflet() %>% addTiles() %>% setView(150, -20, zoom = 5) %>%
      addWMSTiles(
        "http://ereeftds.bom.gov.au/ereefs/tds/wms/ereefs/mwq_gridAgg_P1D?request=GetMap&service=WMS&version=1.3.0&time=2015-08-02T04:15:09.000Z&COLORSCALERANGE=0.1,10.0&BELOWMINCOLOR=transparent&ABOVEMAXCOLOR=extend",
        #"http://ereeftds.bom.gov.au/ereefs/tds/wms/ereefs/mwq_gridAgg_P1D?request=GetMap&service=WMS&version=1.3.0&time=2015-07-30Z&COLORSCALERANGE=0.1,10.0&BELOWMINCOLOR=transparent&ABOVEMAXCOLOR=extend&CRSEPSG:4326", 
        layers = "Chl_MIM",
        options = WMSTileOptions(format = "image/png", transparent = TRUE),
        #options = WMSTileOptions(format = "application/vnd.google-earth.kmz"),
        attribution = "eReefs MWQ data © 2015 BOM"
      )
    
  })
  
  
  
})

