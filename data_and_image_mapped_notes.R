#png and data
# https://rstudio.github.io/leaflet/

library(leaflet)
library(raster)
library(png)
# library(rgdal)

usr_year = "2015"
usr_month = "07"
usr_day = "30"
usr_prod = "mwq"
usr_base_url = "http://ereeftds.bom.gov.au/ereefs/tds/fileServer/ereef/mwq/png_files"

#url_grid <-   "2015/07/20150710.png"
usr_png_url = file.path(usr_base_url, paste(usr_year, usr_month, paste(usr_year,usr_month,usr_day,".png",sep=""), sep="/"))
download.file(usr_png_url, "current_image.png", method = "auto", quiet = FALSE, mode="wb", cacheOK = TRUE)
usr_img <- readPNG('current_image.png')

# Convert imagedata to raster
rst.blue <- raster(usr_img[,,1])
rst.green <- raster(usr_img[,,2])
rst.red <- raster(usr_img[,,3])

plotRGB(brick(rst.blue, rst.green, rst.red),r=1,g=2,b=3, scale=800, stretch = "Lin")


####
r <- raster("output.tif")
# Convert imagedata to raster
rst.blue <- raster(r[,,1])
rst.green <- raster(r[,,2])
rst.red <- raster(r[,,3])

pal <- colorNumeric(c("blue", "green", "red"), ,
                    na.color = "transparent")

leaflet() %>% addTiles() %>%
  addRasterImage(r, colors = pal, opacity = 0.8)

# x <- "gdal_translate -of GTiff -a_ullr 142.0050048828125 -25.4950008392334 155.9949951171875 -9.505000114440918 -a_srs EPSG:4269 current_image.png output.tif"

# r <- matrix(runif(9, 0, 1), 3)
# g <- matrix(runif(9, 0, 1), 3)
# b <- matrix(runif(9, 0, 1), 3)

usr_png_url = file.path(usr_base_url, paste(usr_year, usr_month, paste(usr_year,usr_month,usr_day,".png",sep=""), sep="/"))
download.file(usr_png_url, "current_image.png", method = "auto", quiet = FALSE, mode="wb", cacheOK = TRUE)
usr_img <- readPNG('current_image.png')

usr_img <- raster('output.tif')
# Convert imagedata to raster
rst.blue <- matrix(usr_img[,,3])
rst.green <- matrix(usr_img[,,2])
rst.red <- matrix(usr_img[,,1])



col <- rgb(rst.red,rst.green, rst.blue)

col2 <- rgb2hsv(col)

dim(col) <- c(dim(usr_img)[1],dim(usr_img)[2])

library(grid)
grid.raster(col, interpolate=FALSE)

rasterImage(col, 142.0050048828125, -25.4950008392334, 155.9949951171875, -9.505000114440918, interpolate=FALSE)













## combined
leaflet() %>% addTiles() %>% setView(150, -20, zoom = 5) %>%
  addWMSTiles(
    "http://ereeftds.bom.gov.au/ereefs/tds/wms/ereefs/mwq_gridAgg_P1D?request=GetMap&service=WMS&version=1.3.0&time=2015-07-30T03:40:10.000Z&COLORSCALERANGE=0.1,10.0&BELOWMINCOLOR=transparent&ABOVEMAXCOLOR=extend",
    #"http://ereeftds.bom.gov.au/ereefs/tds/wms/ereefs/mwq_gridAgg_P1D?request=GetMap&service=WMS&version=1.3.0&time=2015-07-30Z&COLORSCALERANGE=0.1,10.0&BELOWMINCOLOR=transparent&ABOVEMAXCOLOR=extend&CRSEPSG:4326", 
    layers = "Chl_MIM",
    options = WMSTileOptions(format = "image/png", transparent = TRUE),
    #options = WMSTileOptions(format = "application/vnd.google-earth.kmz"),
    attribution = "eReefs MWQ data © 2015 BOM"
  ) 

## try to add a png under it...

usr_year = "2015"
usr_month = "07"
usr_day = "30"
usr_prod = "mwq"
usr_base_url = "http://ereeftds.bom.gov.au/ereefs/tds/fileServer/ereef/mwq/png_files"

#url_grid <-   "2015/07/20150710.png"
usr_png_url = file.path(usr_base_url, paste(usr_year, usr_month, paste(usr_year,usr_month,usr_day,".png",sep=""), sep="/"))

download.file(usr_png_url, "current_image.png", method = "auto", quiet = FALSE, mode="wb", cacheOK = TRUE)
usr_img <- readPNG('current_image.png')
grid::grid.raster(usr_img)


# http://ereeftds.bom.gov.au/ereefs/tds/dodsC/ereefs/mwq_areaSum_P1D.ascii?time[0:1:4739]
# units: seconds since 1970-01-01 00:00:00


