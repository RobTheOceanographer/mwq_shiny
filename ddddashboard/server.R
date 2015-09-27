
# load some libraries
library(shiny)
library(png)
library(leaflet)
library(ncdf4)
library(raster)

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
    #usr_year = 2015
    #usr_month = '07'
    #usr_day = 29
    usr_year = format(input$chl_date,"%Y")
    usr_month = format(input$chl_date,"%m")
    usr_day = format(input$chl_date,"%d")
    usr_base_url = "http://ereeftds.bom.gov.au/ereefs/tds/dodsC/ereef/mwq/P1D/"
    
    #usr_grid_url = file.path(usr_base_url, paste(usr_year, paste(usr_year,usr_month,usr_day,".P1D.ANN_MIM_RMP.nc",sep=""), sep="/"))
    usr_grid_url = paste(usr_base_url, paste(usr_year, paste('A', usr_year,usr_month,usr_day,".P1D.ANN_MIM_RMP.nc",sep=""), sep="/"), sep="")
    # usr_grid_url ="http://ereeftds.bom.gov.au/ereefs/tds/dodsC/ereef/mwq/P1D/2015/A20150730.P1D.ANN_MIM_RMP.nc"
    output$chl_url_Text  <- renderText({
      usr_grid_url
    })
    ## This is product selection - maybe this will be done elsewhere in the future when it is usr selectable ##
    var_string <- "Chl_MIM"
    
    # link to the data set... this is where it will fail if the url doen't form correctly of if the data is missing
    f<-nc_open(usr_grid_url)
    
    data_grid <- ncvar_get(f, var_string)
    lat_list <- ncvar_get(f, 'lat')
    lon_list <- ncvar_get(f, 'lon')
    
    # get some useful attributes:
    unit_string <- ncatt_get(f, var_string)$'units'
    long_name_string <- ncatt_get(f, var_string)$'long_name'
    valid_min <- ncatt_get(f, var_string)$'valid_min'
    valid_max <- ncatt_get(f, var_string)$'valid_max'
    fill_value <- ncatt_get(f, var_string)$'_FillValue'
    
    #convert it to a raster so that we can use it in the leaflet
    r_f <- raster(t(data_grid), xmn=min(lon_list), xmx=max(lon_list), ymn=min(lat_list), ymx=max(lat_list))
    # add some corrdinate system
    crs(r_f) <- sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
    
    
    
    ## This is the chlorophyll leaflet itself ##
    leaflet() %>% addTiles() %>% setView(150, -20, zoom = 5) %>% addRasterImage(r_f,  colors = chlpalfun, opacity = 0.8, attribution = "eReefs MWQ data © 2015 BOM")

    
    })
  
  
  
})




## useful functions:
chlpalfun<- function(chlVal)
{
  pal <- chl.pal(palette = TRUE)
  breaks = pal$breaks
  col = pal$cols
  
  nearestBrake <- nearest.vec(chlVal,breaks)
  
  chlCol <- col[nearestBrake]
  
  return(chlCol)
  
}


nearest.vec <- function(x, vec)
{
  smallCandidate <- findInterval(x, vec, all.inside=TRUE)
  largeCandidate <- smallCandidate + 1
  #nudge is TRUE if large candidate is nearer, FALSE otherwise
  nudge <- 2 * x > vec[smallCandidate] + vec[largeCandidate]
  return(smallCandidate + nudge)
}

###### Stole the ocean colour pallett from Mike Sumner!
##' chl <- readchla(xylim = c(100, 110, -50, -40))
##' ## just get a small number of evenly space colours
##' plot(chl, col = chl.pal(10))
##' ## store the full palette and work with values and colours
##' pal <- chl.pal()
##' ## the standard full palette
##' plot(chl, breaks = pal$breaks, col = pal$cols)
##' ## a custom set of values with matching colours
##' plot(chl, col = chl.pal(pal$breaks[seq(1, length(pal$breaks), length = 10)]))
##' ## any number of colours stored as a function
##' myfun <- chl.pal()
##' plot(chl, col = myfun(18))
##' ## just n colours
##' plot(chl, col = chl.pal(18))
##

##' }
chl.pal <- function(x, palette = FALSE, alpha = 1) {
  
  ##pal <- read.table("http://oceancolor.gsfc.nasa.gov/DOCS/palette_chl_etc.txt", header = TRUE, colClasses = "integer", comment.char = "")
  ##cols <- rgb(pal[,2], pal[,3], pal[,4], maxColorValue = 255)
  ##dput(cols)
  ##  breaks <-  c(0, exp(round(seq(-4.6, 4.1, length = 255), digits = 2)))
  breaks <- c(sqrt( .Machine$double.eps), 10^seq(-2, log10(20), length  = 254), 1000)
  
  
  cols <- c("#000000", "#90006F", "#8D0072", "#8A0075", "#870078", "#84007B",
            "#81007E", "#7E0081", "#7B0084", "#780087", "#75008A", "#72008D",
            "#6F0090", "#6C0093", "#690096", "#660099", "#63009C", "#60009F",
            "#5D00A2", "#5A00A5", "#5700A8", "#5400AB", "#5100AE", "#4E00B1",
            "#4B00B4", "#4800B7", "#4500BA", "#4200BD", "#3F00C0", "#3C00C3",
            "#3900C6", "#3600C9", "#3300CC", "#3000CF", "#2D00D2", "#2A00D5",
            "#2700D8", "#2400DB", "#2100DE", "#1E00E1", "#1B00E4", "#1800E7",
            "#1500EA", "#1200ED", "#0F00F0", "#0C00F3", "#0900F6", "#0600F9",
            "#0000FC", "#0000FF", "#0005FF", "#000AFF", "#0010FF", "#0015FF",
            "#001AFF", "#0020FF", "#0025FF", "#002AFF", "#0030FF", "#0035FF",
            "#003AFF", "#0040FF", "#0045FF", "#004AFF", "#0050FF", "#0055FF",
            "#005AFF", "#0060FF", "#0065FF", "#006AFF", "#0070FF", "#0075FF",
            "#007AFF", "#0080FF", "#0085FF", "#008AFF", "#0090FF", "#0095FF",
            "#009AFF", "#00A0FF", "#00A5FF", "#00AAFF", "#00B0FF", "#00B5FF",
            "#00BAFF", "#00C0FF", "#00C5FF", "#00CAFF", "#00D0FF", "#00D5FF",
            "#00DAFF", "#00E0FF", "#00E5FF", "#00EAFF", "#00F0FF", "#00F5FF",
            "#00FAFF", "#00FFFF", "#00FFF7", "#00FFEF", "#00FFE7", "#00FFDF",
            "#00FFD7", "#00FFCF", "#00FFC7", "#00FFBF", "#00FFB7", "#00FFAF",
            "#00FFA7", "#00FF9F", "#00FF97", "#00FF8F", "#00FF87", "#00FF7F",
            "#00FF77", "#00FF6F", "#00FF67", "#00FF5F", "#00FF57", "#00FF4F",
            "#00FF47", "#00FF3F", "#00FF37", "#00FF2F", "#00FF27", "#00FF1F",
            "#00FF17", "#00FF0F", "#00FF00", "#08FF00", "#10FF00", "#18FF00",
            "#20FF00", "#28FF00", "#30FF00", "#38FF00", "#40FF00", "#48FF00",
            "#50FF00", "#58FF00", "#60FF00", "#68FF00", "#70FF00", "#78FF00",
            "#80FF00", "#88FF00", "#90FF00", "#98FF00", "#A0FF00", "#A8FF00",
            "#B0FF00", "#B8FF00", "#C0FF00", "#C8FF00", "#D0FF00", "#D8FF00",
            "#E0FF00", "#E8FF00", "#F0FF00", "#F8FF00", "#FFFF00", "#FFFB00",
            "#FFF700", "#FFF300", "#FFEF00", "#FFEB00", "#FFE700", "#FFE300",
            "#FFDF00", "#FFDB00", "#FFD700", "#FFD300", "#FFCF00", "#FFCB00",
            "#FFC700", "#FFC300", "#FFBF00", "#FFBB00", "#FFB700", "#FFB300",
            "#FFAF00", "#FFAB00", "#FFA700", "#FFA300", "#FF9F00", "#FF9B00",
            "#FF9700", "#FF9300", "#FF8F00", "#FF8B00", "#FF8700", "#FF8300",
            "#FF7F00", "#FF7B00", "#FF7700", "#FF7300", "#FF6F00", "#FF6B00",
            "#FF6700", "#FF6300", "#FF5F00", "#FF5B00", "#FF5700", "#FF5300",
            "#FF4F00", "#FF4B00", "#FF4700", "#FF4300", "#FF3F00", "#FF3B00",
            "#FF3700", "#FF3300", "#FF2F00", "#FF2B00", "#FF2700", "#FF2300",
            "#FF1F00", "#FF1B00", "#FF1700", "#FF1300", "#FF0F00", "#FF0B00",
            "#FF0700", "#FF0300", "#FF0000", "#FA0000", "#F50000", "#F00000",
            "#EB0000", "#E60000", "#E10000", "#DC0000", "#D70000", "#D20000",
            "#CD0000", "#C80000", "#C30000", "#BE0000", "#B90000", "#B40000",
            "#AF0000", "#AA0000", "#A50000", "#A00000", "#9B0000", "#960000",
            "#910000", "#8C0000", "#870000", "#820000", "#7D0000", "#780000",
            "#730000", "#6E0000", "#690000", "#000000")
  
  hexalpha <- as.hexmode(round(255 * alpha))
  if (nchar(hexalpha) == 1L) hexalpha <- paste(rep(hexalpha, 2L), collapse = "")
  cols <- paste0(cols, hexalpha)
  
  if (palette) return(list(breaks = breaks, cols = cols))
  if (missing(x)) return(colorRampPalette(cols))
  
  if (length(x) == 1L) {
    return(paste0(colorRampPalette(cols)(x), hexalpha))
  } else {
    return(cols[findInterval(x, breaks)])
  }
  
}

