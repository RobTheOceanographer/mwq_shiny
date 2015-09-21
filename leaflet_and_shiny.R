library(shiny)
library(leaflet)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage(
  leafletOutput("mymap", height = 900),
  p()#,
  #actionButton("recalc", "New points")
)

server <- function(input, output, session) {

#   points <- eventReactive(input$recalc, {
#     cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
#   }, ignoreNULL = FALSE)

  output$mymap <- renderLeaflet({
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
}

shinyApp(ui, server)
