# https://pws3141.github.io/blog/posts/01-highcharter/
# Add accessibility
library(highcharter)
library(palmerpenguins)

data(penguins, package = "palmerpenguins")

hchart(
  penguins,
  "scatter",
  hcaes(x = flipper_length_mm, y = bill_length_mm, group = species)
)

## Add x and y axis labels;
## Add a title and subtitle;
## Add a source;
## Change the colours to the Government Analysis Function categorical data colour palette;
## Make the hover box specify ‘flipper length’ and ‘bill length’.

hc_penguins <- hchart(penguins,"scatter",
       hcaes(x = flipper_length_mm, y = bill_length_mm, group = species)) |>
  # x axis label
  hc_xAxis(title = list(text = "Flipper Length (mm)")) |>
  # y axis label
  hc_yAxis(title = list(text = "Bill Length (mm)")) |>
  # title and subtitle
  hc_title(text = "Gentoo's have <i>big</i> flippers!",
           margin = 20, # space between title (or subtitle) and plot [default = 15]
           align = "left",
           stlyle = list(useHTML = TRUE)) |>
  hc_subtitle(text = "A scatter graph showing the relationship between flipper length
              and bill length, for Adelie, Chinstrap and Gentoo penguins",
              align = "left") |>
  # a source
 hc_credits(
    text = "Chart created using R and highcharter",
    href = "http://jkunst.com/highcharter",
    enabled = TRUE
    ) |>
  # hover box options
  hc_tooltip(
    headerFormat = "<b>{series.name}</b><br>",
    pointFormat = "Flipper Length: {point.x} mm<br>Bill Length: {point.y} mm"
    #> valueSuffix applies globally but only when values are displayed individually
    #> here, displayed twice so hard-coded into 'pointFormat'
    #>valueSuffix = " mm"
  ) |>
  hc_colors(c("#12436D", "#28A197", "#801650"))

hc_penguins

## The ability to download the data;
## Keyboard navigation;
## Alt text, following guidance given by Amy Cesal in her blog post, “Writing Alt Text for Data Visualization”.

hc_penguins2 <- hc_penguins |>
  #hc_add_dependency(name = "modules/exporting.js") |>
  #hc_add_dependency(name = "modules/export-data.js") |>
  hc_exporting(
    enabled = TRUE,
    filename = "palmer_penguins"
  )

hc_penguins2


## Add accessibility after uncommenting 'highchart.yaml'
## in .libPaths ie. ...library/highcharter/htmlwidgets/highchart.yaml

hc_penguins3 <- hc_penguins |>
  hc_add_dependency(name = "modules/accessibility.js") |>
  hc_exporting(
    accessibility = list(
      enabled = TRUE # default value is TRUE
      ),
    enabled = TRUE,
    filename = "palmer_penguins"
  ) |>
  hc_plotOptions(
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
      )
    )

hc_penguins3


## In this section we add alt-text to the plot, to allow those using screen
## readers to understand the plot. )

## First, lets add accessible descriptions to the plot, by enabling the
## accessibility options in hc_xAxis and hc_yAxis.

hc_penguins4 <- hchart(penguins,"scatter",
       hcaes(x = flipper_length_mm, y = bill_length_mm, group = species)) |>
  hc_add_dependency(name = "modules/accessibility.js") |>
  # x axis label
  hc_xAxis(title = list(text = "Flipper Length (mm)"),
           accessibility = list(
                   enabled = TRUE,
                   description = "flipper length in millimeters"
           )) |>
  # y axis label
  hc_yAxis(title = list(text = "Bill Length (mm)"),
           accessibility = list(
                   enabled = TRUE,
                   description = "bill length in millimeters"
           )) |>
  # title and subtitle
  hc_title(text = "Gentoo's have <i>big</i> flippers!",
           margin = 20, # space between title (or subtitle) and plot [default = 15]
           align = "left",
           stlyle = list(useHTML = TRUE)) |>
  hc_subtitle(text = "A scatter graph showing the relationship between flipper length
              and bill length, for Adelie, Chinstrap and Gentoo penguins",
              align = "left") |>
  # a source
 hc_credits(
    text = "Chart created using R and highcharter",
    href = "http://jkunst.com/highcharter",
    enabled = TRUE
    ) |>
  # hover box options
  hc_tooltip(
    headerFormat = "<b>{series.name}</b><br>",
    pointFormat = "Flipper Length: {point.x} mm<br>Bill Length: {point.y} mm"
    #> valueSuffix applies globally but only when values are displayed individually
    #> here, displayed twice so hard-coded into 'pointFormat'
    #>valueSuffix = " mm"
  ) |>
  hc_colors(c("#12436D", "#28A197", "#801650")) |>
  hc_exporting(
    accessibility = list(
      enabled = TRUE # default value is TRUE
      ),
    enabled = TRUE,
    filename = "palmer_penguins"
  ) |>
  hc_plotOptions(
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
      )
    )

hc_penguins4
