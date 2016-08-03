
library(ncdf4)
library(raster)

usr_base_url = "/Users/rjohnson/Documents/2.CURRENT_PROJECTS/mwq_shiny/sst_clim/data/"

enso = 'neutral'
month = 'jan'

# file name looks like: neutral_jan_ave_clim.nc

usr_grid_url = paste(usr_base_url, paste(enso, month ,"ave_clim.nc",sep="_"), sep="")

var_string <- "bouy_depth_sst"

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

# Convert from Kelvin to Celcius
data_grid_C = kelvin_to_celsius(data_grid)

#convert it to a raster so that we can use it in the leaflet
r_f <- raster(t(data_grid_C), xmn=min(lon_list), xmx=max(lon_list), ymn=min(lat_list), ymx=max(lat_list))
# add some corrdinate system
crs(r_f) <- sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")


leaflet() %>% addTiles() %>% setView(147, -42, zoom = 8) %>% addRasterImage(r_f, colors = pal, opacity = 0.8, attribution = HTML(paste(a('GHRSST Bouy Depth SST',target='_blank', href='http:'),icon('copyright'),'Produced by the Me.')),)  %>% addLegend(pal = pal, values = values(r_f), title = "Surface temp")






library(plotly)

plot_ly(z = data_grid_C, type = "contour", hoverinfo = "z",  contours = list(coloring = 'heatmap', start = (floor(min(data_grid_C,na.rm = TRUE))-1), end = ceiling(max(data_grid_C,na.rm = TRUE)), size = 1), autocontour = FALSE, colorscale="jet")


plot_ly(z = data_grid_C, type = "surface")


plot_ly(z = data_grid_C, colorscale = "Greens", type = "heatmap")



#
ggplot(Statsrep, aes(x=X, y=Y, z=Zn)) + 
  geom_density2d()