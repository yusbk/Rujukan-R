## https://pws3141.github.io/blog/posts/03-highcharter_graphs/
## --------------------------------------------------------

library(highcharter)
library(paletteer) # colour palettes
library(tidyverse)
library(gapminder)

# medical data package
# use 'remotes::install_github("higgi13425/medicaldata")' to access the 'thiomon' dataset
## remotes::install_github("higgi13425/medicaldata")
library(medicaldata)

# obtaining MP information
## remotes::install_github("houseofcommonslibrary/clmnis")
library(clmnis)

library(fontawesome)
library(rsvg) # to use fa_png()

### BAR PLOT
### ---------

## Dataset
covid <- tibble(medicaldata::covid_testing)

covid <- covid |>
  mutate(across(c(gender, test_id, demo_group, drive_thru_ind, result, payor_group, patient_class), as_factor))

# look at levels of the factors
#sapply(covid[, c("gender", "test_id", "demo_group", "drive_thru_ind", "result", "payor_group", "patient_class")], levels)

covid

# Count positive, negative and invalid results
result_counts <- covid |>
  count(result) |>
  # capitalise first letter
  mutate(result = str_to_title(as.character(result))) |>
  arrange(desc(n))

# Create the bar chart
hchart(
    result_counts,
    type = "bar",
    hcaes(x = result, y = n),
    name = "Results"
  ) |>
  hc_title(text = "Results of Covid Tests") |>
  hc_xAxis(title = list(text = "Result")) |>
  hc_yAxis(title = list(text = "Count")) |>
  hc_colors("#003087") |>
  # a source
  hc_credits(
    text = "Data obtained from the {medicaldata} package",
    href = "https://higgi13425.github.io/medicaldata/",
    enabled = TRUE
    ) |>
  hc_exporting(
    accessibility = list(
      enabled = TRUE # default value is TRUE
      ),
    enabled = TRUE,
    filename = "covid_bar"
  ) |>
  hc_plotOptions(
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
      )
    )

# Group results by gender
result_counts_gender <- covid |>
  group_by(gender) |>
  count(result) |>
  # capitalise first letter
  mutate(result = str_to_title(as.character(result)))

# note {use.key} to get hover box to output the correct things
hchart(
  result_counts_gender,
  type = "bar",
  hcaes(x = result, y = n, group = gender)
  ) |>
  hc_colors(c("#003087", "#006747")) |>
  hc_title(text = "Lots of people don't have Covid",
           align = "left") |>
  hc_subtitle(text = "A bar chart showing Covid test results, split by gender.",
              align = "left") |>
  hc_xAxis(title = list(text = "Result")) |>
  hc_yAxis(title = list(text = "Count")) |>
  # a source
  hc_credits(
    text = "Data obtained from the {medicaldata} package",
    href = "https://higgi13425.github.io/medicaldata/",
    enabled = TRUE
    ) |>
   hc_tooltip(
      formatter = JS("function () {
       if (this.series.name == 'male') {
        return `<b>Male</b></br>${this.y} ${this.key} results`
      } else if (this.series.name == 'female') {
        return `<b>Female</b></br> ${this.y} ${this.key} results`
      }}")
   ) |>
  hc_exporting(
    accessibility = list(
      enabled = TRUE # default value is TRUE
      ),
    enabled = TRUE,
    filename = "covid_bar"
  ) |>
  hc_plotOptions(
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
      )
    )


### ICONS PLOT
### ---------

# Dataset
mps <- clmnis::fetch_mps(on_date = "2024-12-31")

mps

mps_gender <- mps |>
  count(gender) |>
  mutate(
    gender = case_match(
      gender,
      "M" ~ "Male MPs",
      "F" ~ "Female MPs"
    )
  ) |>
  add_column(col = c("#4477AA", "#EE6677"))

mps_gender

# Parliament view
hchart(
  mps_gender,
  "item",
  hcaes(
    name = gender,
    y = n,
    color = col
  ),
  name = "Number of MPs",
  showInLegend = TRUE,
  size = "100%",
  center = list("50%", "75%"),
  startAngle = -100,
  endAngle  = 100
) %>%
  hc_title(
    text = "Male MPs make up a significant majority of the House of Commons",
    align = "left"
    ) %>%
  hc_subtitle(
    text = "An item chart showing the proportion of male and femal MPs in the House of Commons, on 31st December 2024.",
    align = "left"
    ) |>
  hc_legend(labelFormat = '{name} <span style="opacity: 0.4">{y}</span>') |>
  hc_exporting(
    accessibility = list(
      enabled = TRUE # default value is TRUE
      ),
    enabled = TRUE,
    filename = "mp_icon_plot"
  ) |>
  hc_plotOptions(
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
      )
    )

# Circle view set "startAngle = -180" and "endAngle = 180" and change the
# "center" arguement to get it circular
hchart(
  mps_gender,
  "item",
  hcaes(
    name = gender,
    y = n,
    color = col
  ),
  name = "Number of MPs",
  showInLegend = TRUE,
  size = "100%",
  center = list("50%", "50%"),
  startAngle = -180,
  endAngle  = 180
) %>%
  hc_title(
    text = "Male MPs make up a significant majority of the House of Commons",
    align = "left"
    ) %>%
  hc_subtitle(
    text = "An item chart showing the proportion of male and femal MPs in the House of Commons, on 31st December 2024.",
    align = "left"
    ) |>
  hc_legend(labelFormat = '{name} <span style="opacity: 0.4">{y}</span>') |>
  hc_exporting(
    accessibility = list(
      enabled = TRUE # default value is TRUE
      ),
    enabled = TRUE,
    filename = "mp_icon_plot"
  ) |>
  hc_plotOptions(
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
      )
    )

# Add symbols from fontawesome package
fa_to_png_to_datauri <- function(name, ...) {
  tmpfl <- tempfile(fileext = ".png")
  fontawesome::fa_png(name, file = tmpfl, ...)
  knitr::image_uri(tmpfl)
}

# Add "person" and "person-dress" symbols to the dataset
mps_gender_icon <- mps_gender |>
  add_column(faico = c("person-dress", "person"))

mps_gender_icon <- mps_gender_icon |>
  mutate(
    uri = map2_chr(faico, col, ~fa_to_png_to_datauri(.x, fill = .y)),
    marker = map(uri, ~ list(symbol = str_glue("url({data_uri})", data_uri = .x)))
  )

hchart(
  mps_gender_icon,
  "item",
  hcaes(
    name = gender,
    y = n,
    color = col
  ),
  name = "Number of MPs",
  showInLegend = TRUE,
  size = "100%"
) |>
  hc_title(
    text = "Male MPs make up a significant majority of the House of Commons",
    align = "left"
    ) |>
  hc_subtitle(
    text = "An item chart showing the proportion of male and femal MPs in the House of Commons, on 31st December 2024.",
    align = "left"
    ) |>
  hc_legend(labelFormat = '{name} <span style="opacity: 0.4">{y}</span>') |>
  hc_plotOptions(
    item = list(
      layout = "vertical",
      rows = 18 # Specify the number of rows here
    )
  ) |>
  hc_exporting(
    accessibility = list(
      enabled = TRUE # default value is TRUE
      ),
    enabled = TRUE,
    filename = "mp_icon_plot"
  ) |>
  hc_plotOptions(
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
      )
    )


### LINE GRAPHS
### -----------
gapminder_line <- gapminder |>
  filter(country %in% c("United Kingdom","France","Germany","Italy","Netherlands"))

hchart(gapminder_line,
       "line",
        hcaes(x = year, y = pop, group = country)) |>
  hc_title(
    text = "The Netherlands has a much smaller population than Germany.",
    align = "left"
    ) |>
  hc_subtitle(
    text = "A line chart showing changes in population between 1952 and 2007.",
    align = "left"
    ) |>
  hc_xAxis(title = list(text = "Year")) |>
  hc_yAxis(title = list(text = "Population")) |>
  # a source
  hc_credits(
    text = "Data obtained from the {gapminder} package",
    href = "https://www.gapminder.org/",
    enabled = TRUE
    ) |>
  hc_colors(colors = as.character(paletteer::paletteer_d("lisa::FridaKahlo"))) |>
  hc_exporting(
    accessibility = list(
      enabled = TRUE # default value is TRUE
      ),
    enabled = TRUE,
    filename = "population_line"
  ) |>
  hc_plotOptions(
    series = list(
   label = list(
        enabled = TRUE, # add labels to lines
        style = list(
          fontWeight = "bold",
          color = "#333"
        ),
        connectorAllowed = FALSE # include line connecting label to series?
      ),
      lineWidth = 2,
      marker = list(
        enabled = FALSE, # remove markers
        symbol = "circle",
        states = list(
          hover = list(
            enabled = TRUE # enable markers if hovered over
          )
        )
      )),
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
      )
    )


### STREAM GRAPHS
hchart(gapminder_line,
       "streamgraph", zoomType = "x",
        hcaes(x = year, y = pop, group = country)) |>
  hc_title(
    text = "The populations in these countries are relatively steady over time.",
    align = "left"
    ) |>
  hc_subtitle(
    text = "A line chart showing changes in population between 1952 and 2007.",
    align = "left"
    ) |>
  hc_xAxis(title = list(text = "Year")) |>
  hc_yAxis(visible = FALSE,
           startOnTick = FALSE, endOnTick = FALSE,
           title = list(text = "Population")) |>
  # a source
  hc_credits(
    text = "Data obtained from the {gapminder} package",
    href = "https://www.gapminder.org/",
    enabled = TRUE
    ) |>
  hc_colors(colors = as.character(paletteer::paletteer_d("lisa::FridaKahlo"))) |>
  hc_exporting(
    accessibility = list(
      enabled = TRUE # default value is TRUE
      ),
    enabled = TRUE,
    filename = "population_line"
  ) |>
  hc_plotOptions(
    series = list(
   label = list(
        enabled = TRUE, # add labels to lines
        style = list(
          fontWeight = "bold",
          color = "#555555"
        ),
        connectorAllowed = FALSE # include line connecting label to series?
      ),
      lineWidth = 2,
      marker = list(
        enabled = FALSE, # remove markers
        symbol = "circle",
        states = list(
          hover = list(
            enabled = FALSE # enable markers if hovered over
          )
        )
      )),
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
      )
    )


### Other charts
data(vaccines)

fntltp <- JS("function(){
  return this.point.x + ' ' +  this.series.yAxis.categories[this.point.y] + ': ' +
  Highcharts.numberFormat(this.point.value, 2);
}")

plotline <- list(
  color = "#fde725", value = 1963, width = 2, zIndex = 5,
  label = list(
    text = "Vaccine Intoduced", verticalAlign = "top",
    style = list(color = "#606060"), textAlign = "left",
    rotation = 0, y = -5
  )
)

hchart(
  vaccines,
  "heatmap",
  hcaes(
    x = year,
    y = state,
    value = count
    )
  ) |>
  hc_colorAxis(
    stops = color_stops(10, viridisLite::inferno(10, direction = -1)),
    type = "logarithmic"
  ) |>
  hc_yAxis(
    title = list(text = ""),
    reversed = TRUE,
    offset = -20,
    tickLength = 0,
    gridLineWidth = 0,
    minorGridLineWidth = 0,
    labels = list(style = list(fontSize = "9px"))
  ) |>
  hc_tooltip(
    formatter = fntltp
    ) |>
  hc_xAxis(
    plotLines = list(plotline)) |>
  hc_title(
    text = "Infectious Diseases and Vaccines"
    ) |>
  hc_subtitle(
    text = "Number of cases per 100,000 people"
  ) |>
  hc_legend(
    layout = "horizontal",
    verticalAlign = "top",
    align = "left",
    valueDecimals = 0
  ) |>
  hc_size(height = 900)  |>
  hc_exporting(
    accessibility = list(
      enabled = TRUE # default value is TRUE
      ),
    enabled = TRUE,
    filename = "vaccines"
  ) |>
  hc_plotOptions(
    accessibility = list(
      enabled = TRUE,
      keyboardNavigation = list(enabled = TRUE)
      )
    )


## Combine pie and bar charts
## ----------------------------
data(favorite_bars)
data(favorite_pies)

highchart() |>
  # Data
  hc_add_series(
    favorite_pies,
    "column",
    hcaes(
      x = pie,
      y = percent
      ),
    name = "Pie"
    ) |>
  hc_add_series(
    favorite_bars,
    "pie",
    hcaes(
      name = bar,
      y = percent
      ),
    name = "Bars"
    ) |>
  # Options for each type of series
  hc_plotOptions(
    series = list(
      showInLegend = FALSE,
      pointFormat = "{point.y}%",
      colorByPoint = TRUE
      ),
    pie = list(
      center = c('30%', '10%'),
      size = 120,
      dataLabels = list(enabled = FALSE)
      )
    ) |>
  # Axis
  hc_yAxis(
    title = list(text = "percentage of tastiness"),
    labels = list(format = "{value}%"),
    max = 100
  ) |>
  hc_xAxis(
    categories = favorite_pies$pie
    ) |>
  # Titles, subtitle, caption and credits
  hc_title(
    text = "How I Met Your Mother: Pie Chart Bar Graph"
  ) |>
  hc_subtitle(
    text = "This is a bar graph describing my favorite pies
    including a pie chart describing my favorite bars"
  ) |>
  hc_caption(
    text = "The values represented are in percentage of tastiness and awesomeness."
    ) |>
  hc_credits(
    enabled = TRUE, text = "Source: HIMYM",
    href = "https://www.youtube.com/watch?v=f_J8QU1m0Ng",
    style = list(fontSize = "12px")
  ) |>
  hc_size(
    height = 600
    )
