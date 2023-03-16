# source https://gl-li.github.io/study-notes/shiny_click_on_a_map.html
# ---------------
source("https://raw.githubusercontent.com/helseprofil/misc/main/utils.R")
kh_load(ggplot2, maps, MASS, shiny)
# create the data frame of the map. This data frame contains the longitude and latitude
# of state borders in the map
# library(ggplot2)
# library(maps)
usaMap <- map_data("state")

# get the arrest data,which has four columns: number of murder, rate, and assault per
# 100,000 population, and percent of population living in urban area, all shown in
# above plot. The row names are the state names.
# library(MASS)
data("USArrests")

# define a function which finds which state a point is in. This is the function
# that takes input from click and give the name of the state being clicked
which_state <- function(mapData, long, lat) {
  # This function decide the state being clicked.
  #
  # Args:
  #   mapData: The map data has a column "long" and a column "lat" to determine
  #       state borders.
  #   long, lat: longitude and latitude of the clicked point. They are actually
  #       input$clickMap$x and input$clickMap$y assuming click = "clickMap".
  #
  # Returns:
  #   The name of the state containing the point (long, lat).

  # calculate the difference in long and lat of the border with respect to this point
  mapData$long_diff <- mapData$long - long
  mapData$lat_diff <- mapData$lat - lat

  # only compare borders near the clicked point to save computing time
  mapData <- mapData[abs(mapData$long_diff) < 20 & abs(mapData$lat_diff) < 15, ]

  # calculate the angle between the vector from this clicked point to border and c(1, 0)
  vLong <- mapData$long_diff
  vLat <- mapData$lat_diff
  mapData$angle <- acos(vLong / sqrt(vLong^2 + vLat^2))

  # calculate range of the angle and select the state with largest range
  rangeAngle <- tapply(mapData$angle, mapData$region, function(x) max(x) - min(x))
  return(names(sort(rangeAngle, decreasing = TRUE))[1])
}


# build the app
# library(shiny)
plotMap <- ggplot(usaMap, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")
plotArrest <- ggplot(USArrests, aes(x = Murder, y = Rape)) +
  geom_point(aes(size = Assault, color = UrbanPop)) +
  scale_size(limits = c(1, 350))

ui <- shinyUI(fluidPage(
  column(
    width = 6,
    plotOutput("map", click = "clickMap", width = 430, height = 275)
  ),
  column(
    width = 6,
    plotOutput("arrest", width = 430, height = 275)
  )
))

server <- shinyServer(function(input, output) {
  # intital plots
  output$map <- renderPlot({
    plotMap
    # coord_map(), do not use it. More discussion next section.
  })
  output$arrest <- renderPlot({
    plotArrest
  })

  # plot after click
  observeEvent(input$clickMap, {
    xClick <- input$clickMap$x
    yClick <- input$clickMap$y
    state <- which_state(usaMap, xClick, yClick)
    output$map <- renderPlot(
      plotMap +
        geom_polygon(data = usaMap[usaMap$region == state,], fill = "yellow") +
        annotate("text", x = xClick, y = yClick, label = state, color = "red")
    )
    output$arrest <- renderPlot({
      plotArrest +
        geom_point(data = USArrests[tolower(rownames(USArrests)) == state,],
                   size = 6, shape = 1, color = "red")
    })
  })
})

shinyApp(ui, server)
