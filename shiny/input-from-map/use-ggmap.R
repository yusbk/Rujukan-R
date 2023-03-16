## ref https://gl-li.github.io/study-notes/shiny_click_on_a_map.html
## Package ggmap extracts maps from online maps such as Google Maps and Open Street
## Map and replot maps with function ggmap(), which is based on ggplot2. By default
## ggmap() uses the coord_map() projection, which distorts the coordinate. To get
## the correct clicked coordinate in Shiny, the map needs to be converted back to
## Cartesian coordinate. This can be done simply by adding coord_cartesian(). As
## coord_map() has been stripped, aspect ratio of the output map can be any. So you
## need to specify its width and height so that the map still looks like a nice
## map.

source("https://raw.githubusercontent.com/helseprofil/misc/main/utils.R")
kh_load(ggmap, osmdata, shiny)
## library(ggmap)
## library(osmdata) #needed to avoid the error with API key ggmap::register_google()
ggmap::register_google()

## map <- get_map(location = "san diego", maptype="roadmap", source = "osm",
##                scale=2, zoom =4)

# with osmdata
map <- get_map(getbb("san diego"), source = "stamen")

ui <- fluidPage(
  column(
    width = 6,
    plotOutput("mapProj", click = "clickMapProj")
  ),
  column(
    width = 6,
    plotOutput("map", click = "clickMap", width = 385, height = 400)
  )
)

server <- function(input, output) {
  # initial plot with and without projection
  output$mapProj <- renderPlot({
    ggmap(map) + ggtitle("with map projection")
  })
  output$map <- renderPlot({
    ggmap(map) + coord_cartesian() + ggtitle("without map projection")
  })

  # plot after clicking on map with projection
  observeEvent(input$clickMapProj, {
    x <- input$clickMapProj$x
    y <- input$clickMapProj$y
    df <- data.frame(long = x, lat = y)
    output$mapProj <- renderPlot({
      ggmap(map) + ggtitle("with map projection") +
        geom_point(data = df, aes(long, lat), size = 5)
    })
  })

  # plot after cliking on map without projection
  observeEvent(input$clickMap, {
    x <- input$clickMap$x
    y <- input$clickMap$y
    df <- data.frame(long = x, lat = y)
    output$map <- renderPlot({
      ggmap(map) + coord_cartesian() + ggtitle("without map projection") +
        geom_point(data = df, aes(long, lat), size = 5)
    })
  })
}

shinyApp(ui, server)
