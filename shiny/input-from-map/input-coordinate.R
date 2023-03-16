# Not working with projection! ie. click point not precise
# shinyUI() and shinyServer() are no longer required as of Shiny 0.10
ui <- fluidPage(
  column(
    width = 6,
    plotOutput("map", click = "clickMap", width = 430, height = 275)
  ),
  column(
    width = 6,
    plotOutput("mapProj", click = "clickMapProj", width = 430, height = 275),
    )
)

server <- function(input, output) {
  # these ggplot can be reused
  plotMap <- ggplot(usaMap, aes(x = long, y = lat)) +
    geom_polygon(aes(group = group), fill = "white", color = "black") +
    ggtitle("without map projection")
  plotMapProj <- ggplot(usaMap, aes(x = long, y = lat)) +
    geom_polygon(aes(group = group), fill = "white", color = "black") +
    coord_map() +
    ggtitle("with map projection")

  # intital plots with and without map projection
  output$map <- renderPlot({
    plotMap
  })
  output$mapProj <- renderPlot({
    plotMapProj
  })

  # plot after click the map without projection
  observeEvent(input$clickMap, {
    xClick <- input$clickMap$x
    yClick <- input$clickMap$y
    dfClick <- data.frame(long = xClick, lat = yClick)
    output$map <- renderPlot({
      plotMap +
        geom_point(data = dfClick, aes(long, lat), color = "blue", size = 5) +
        annotate("text", x = xClick, y = yClick - 1.5,
                 label = paste0(round(xClick, 1), ", ", round(yClick,1)),
                 color = "red")
    })
  })

  # plot after click the map with projection
  observeEvent(input$clickMapProj, {
    xClick <- input$clickMapProj$x
    yClick <- input$clickMapProj$y
    dfClick <- data.frame(long = xClick, lat = yClick)
    output$mapProj <- renderPlot({
      plotMapProj +
        geom_point(data = dfClick, aes(long, lat), color = "blue", size = 5) +
        annotate("text", x = xClick, y = yClick - 1.5,
                 label = paste0(round(xClick, 1), ", ", round(yClick,1)),
                 color = "red")
    })
  })
}

shinyApp(ui, server)
