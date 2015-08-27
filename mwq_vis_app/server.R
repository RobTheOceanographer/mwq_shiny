
require(png)

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
  
  
})

