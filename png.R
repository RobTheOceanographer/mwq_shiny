

require(png)


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
