# Trial loading of tassie data from a local file system for Jamie's trial stuff.
# 20 Nov 2015
# Robert Johnson
# robtheoceanographer@gmail.com

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

# link to the data set... this is where it will fail if the url doen't form correctly of if the data is missing
nc_file <- "20130101-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc"
f<-nc_open(paste("/Users/rjohnson/Documents/2.CURRENT_PROJECTS/mwq_shiny/tassie_dashboard/local_data_store/sst",nc_file,sep="/"))

data_grid <- ncvar_get(f, "analysed_sst")
data_mask <- ncvar_get(f, "mask")
# 1=open-sea; 2=land; 3=coast/shore; 5=open-lake; 9=open-sea with ice in the grid; 11=coast/shore with ice in the grid; 13=open-lake with ice in the grid
data_grid[data_mask==2] <- NA
data_grid[data_mask==3] <- NA
#data_grid[data_mask==2] <- NA
lat_list <- ncvar_get(f, 'lat')
lon_list <- ncvar_get(f, 'lon')

#convert it to a raster so that we can use it in the leaflet
r_f <- raster(t(data_grid), xmn=min(lon_list), xmx=max(lon_list), ymn=min(lat_list), ymx=max(lat_list))
# add some corrdinate system
#crs(r_f) <- sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
crs(r_f) <- sp::CRS("+init=epsg:4326 +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")
#plot(r_f -273.15)
r_f.cel <- r_f - 273.15
# plot(r_f.cel)

r_f.cel.flipped <- flip(r_f.cel, direction='y')

newext <- c(130, 160, -50, -30)
r_f.cel.flipped.cropped <- crop(r_f.cel.flipped, newext)
#plot(r_f.cel.flipped.cropped)

leaflet() %>% addTiles() %>% setView(150, -40, zoom = 5) %>% addRasterImage(r_f.cel.flipped.cropped, color= sstpalfun, project= TRUE,opacity = 0.8, attribution = HTML(paste(a('GHRSST Level 4 MUR Global Foundation Sea Surface Temperature Analysis',target='_blank',href='http://podaac.jpl.nasa.gov/dataset/JPL-L4UHfnd-GLOB-MUR?ids=ProcessingLevel&values=*4*&search=GHRSST'))))

writeRaster(r_f.cel.flipped.cropped, filename = nc_file)






## useful functions:
sstpalfun<- function(sstVal)
{
  pal <- sst.pal(palette = TRUE)
  breaks = pal$breaks
  col = pal$cols
  
  nearestBrake <- nearest.vec(sstVal,breaks)
  
  sstCol <- col[nearestBrake]
  
  return(sstCol)
  
}


nearest.vec <- function(x, vec)
{
  smallCandidate <- findInterval(x, vec, all.inside=TRUE)
  largeCandidate <- smallCandidate + 1
  #nudge is TRUE if large candidate is nearer, FALSE otherwise
  nudge <- 2 * x > vec[smallCandidate] + vec[largeCandidate]
  return(smallCandidate + nudge)
}

###### Stole the pallett from Mike Sumner!
sst.pal <- function(x, palette = FALSE, alpha = 1) {
  ##pal <- read.table("http://oceancolor.gsfc.nasa.gov/DOCS/palette_sst.txt", header = TRUE, colClasses = "integer", comment.char = "")
  ##cols <- rgb(pal[,2], pal[,3], pal[,4], maxColorValue = 255)
  ##dput(cols)
  breaks <- seq(-2, 46, length = 256)
  cols <- c("#5B0A76", "#63098B", "#7007AB", "#7C07CA", "#8207DF", "#8007EA",
            "#7807EE", "#6E07EE", "#6407EF", "#5807EF", "#4907EF", "#3607EF",
            "#2208EE", "#1208EC", "#0B08E9", "#0808E4", "#0808E0", "#0808DD",
            "#0808D9", "#0808D4", "#0808CF", "#0808C9", "#0808C4", "#0808BF",
            "#0808B9", "#0808B3", "#0808AD", "#0808A6", "#08089F", "#080899",
            "#080B93", "#08108B", "#081782", "#081E79", "#082672", "#082E6D",
            "#08366A", "#083E68", "#084668", "#084E68", "#08566A", "#085D6B",
            "#08626D", "#086470", "#086372", "#086275", "#08617A", "#086282",
            "#08658B", "#086893", "#086C98", "#08719B", "#08769D", "#087B9E",
            "#08809F", "#08859F", "#0888A0", "#088CA2", "#0891A3", "#0896A5",
            "#089CA6", "#08A1A7", "#08A6A9", "#08ACAC", "#08B1B1", "#08B6B6",
            "#08BBBB", "#08C0C0", "#08C5C5", "#08C8C8", "#08CCCC", "#08D1D1",
            "#08D5D5", "#08D8D8", "#08DBDB", "#08DEDE", "#08E1E1", "#08E3E3",
            "#08E6E6", "#08E9E9", "#08EBEB", "#08EDEC", "#08EEEA", "#08EEE5",
            "#08EEDF", "#08EDD8", "#08EBD1", "#08EACA", "#08E8C0", "#08E7B2",
            "#08E6A2", "#08E593", "#08E385", "#08E27B", "#08E074", "#08DD72",
            "#08DB72", "#08D873", "#08D575", "#08D176", "#08CC76", "#08C775",
            "#08C173", "#08BC70", "#08B86B", "#08B563", "#08B25B", "#08AF54",
            "#08AC51", "#08A950", "#08A450", "#089F50", "#089950", "#08944F",
            "#088F4F", "#088A4F", "#08864E", "#08844B", "#088646", "#08893F",
            "#088C38", "#088C30", "#088B25", "#098A18", "#0E8B0E", "#188D09",
            "#259208", "#2F9708", "#349C08", "#37A108", "#39A608", "#3CAC08",
            "#41B108", "#46B608", "#4BBB08", "#50C008", "#55C408", "#59C708",
            "#5FC908", "#67CC08", "#6ECE08", "#76D108", "#7ED308", "#86D608",
            "#8ED908", "#97DB08", "#A0DE08", "#A9E108", "#B3E308", "#BBE508",
            "#C3E608", "#CDE608", "#D7E608", "#DFE508", "#E2E308", "#E1E008",
            "#E0DD08", "#E0D908", "#E0D308", "#E0CD08", "#E0C608", "#E0BF08",
            "#E0B908", "#E0B408", "#E0AE08", "#E0A608", "#E09F08", "#E09708",
            "#E08F08", "#E08708", "#E07F08", "#E07708", "#E06F08", "#E06708",
            "#E05F08", "#E05908", "#E05408", "#E04E08", "#DF4608", "#DF3F08",
            "#DF3708", "#DE2E08", "#DD2508", "#DB1C08", "#D81308", "#D50C08",
            "#D10908", "#CC0808", "#C80808", "#C40808", "#BE0808", "#B60808",
            "#AF0808", "#A70808", "#9F0808", "#970808", "#8F0808", "#870808",
            "#7F0808", "#780808", "#730808", "#6E0808", "#680808", "#6C0D0D",
            "#701313", "#721616", "#731A1A", "#761E1E", "#772221", "#792626",
            "#7B2929", "#7D2D2D", "#7F3131", "#803435", "#823838", "#843C3C",
            "#86403F", "#884343", "#8A4746", "#8C4B4A", "#8E4F4E", "#8F5252",
            "#915555", "#93595A", "#955D5D", "#966161", "#986464", "#9A6868",
            "#9C6B6C", "#9E706F", "#A07373", "#A27777", "#A47B7B", "#A57E7E",
            "#A88282", "#A98686", "#AA8A89", "#AD8D8D", "#AF9191", "#B09595",
            "#B29999", "#B59C9C", "#B69F9F", "#B7A3A3", "#B9A7A7", "#BCAAAB",
            "#BEAEAE", "#BFB2B2", "#C1B6B6", "#C3B9B9", "#C5BDBD", "#C7C0C1",
            "#C8C5C5", "#CAC8C9", "#CCCCCC", "#000000")
  
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




