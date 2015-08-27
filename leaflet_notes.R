
# Using wms to pull in data from a thredds system.

# https://rstudio.github.io/leaflet/

library(leaflet)

leaflet() %>% addTiles() %>% setView(150, -20, zoom = 5) %>%
  addWMSTiles(
    "http://ereeftds.bom.gov.au/ereefs/tds/wms/ereefs/mwq_gridAgg_P1D?request=GetMap&service=WMS&version=1.3.0&time=2015-07-30T03:40:10.000Z&COLORSCALERANGE=0.1,10.0&BELOWMINCOLOR=transparent&ABOVEMAXCOLOR=extend",
    #"http://ereeftds.bom.gov.au/ereefs/tds/wms/ereefs/mwq_gridAgg_P1D?request=GetMap&service=WMS&version=1.3.0&time=2015-07-30Z&COLORSCALERANGE=0.1,10.0&BELOWMINCOLOR=transparent&ABOVEMAXCOLOR=extend&CRSEPSG:4326", 
    layers = "Chl_MIM",
    options = WMSTileOptions(format = "image/png", transparent = TRUE),
    #options = WMSTileOptions(format = "application/vnd.google-earth.kmz"),
    attribution = "eReefs MWQ data © 2015 BOM"
  )


# http://ereeftds.bom.gov.au/ereefs/tds/dodsC/ereefs/mwq_areaSum_P1D.ascii?time[0:1:4739]
# units: seconds since 1970-01-01 00:00:00


