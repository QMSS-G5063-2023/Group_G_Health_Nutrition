# Load packages ----------------------------------------------------------------
library(shiny)
library(readxl)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(geojsonio)
library(leaflet)

# Read in data -----------------------------------------------------------------
centiment <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/centiment_survey.xlsx")
analysis <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/survey_analysis.xlsx")
states <- geojsonio::geojson_read("https://rstudio.github.io/leaflet/json/us-states.geojson",
                                  what = "sp")
obesity_11 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_11.xlsx")
obesity_12 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_12.xlsx")
obesity_13 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_13.xlsx")
obesity_14 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_14.xlsx")
obesity_15 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_15.xlsx")
obesity_16 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_16.xlsx")
obesity_17 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_17.xlsx")
obesity_18 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_18.xlsx")
obesity_19 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_19.xlsx")
obesity_20 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_20.xlsx")
obesity_21 <- read_excel("/Users/justin/Downloads/drive-download-20230503T031622Z-001/state_obesity_21.xlsx")


# Process data -----------------------------------------------------------------
# EDA
lbs_to_kg <- 2.20462
in_to_ft <- 12
in_to_m <- 39.3701
cent_final <- centiment %>%
  mutate(weight_kg = `Weight (in pounds)` / lbs_to_kg,
         height_ft = as.numeric(`Height (in feet and inches) Feet`),
         height_in = as.numeric(`Height (in feet and inches) Inches`),
         height_m = (height_ft * in_to_ft + height_in) / in_to_m,
         bmi = weight_kg / height_m^2) %>%
  cbind(analysis)


states@data <- cbind(states@data, obesity_11, obesity_12 = obesity_12$obesity_12, 
                     obesity_13 = obesity_13$obesity_13, obesity_14 = 
                       obesity_14$obesity_14, obesity_15 = obesity_15$obesity_15, 
                     obesity_16 = obesity_16$obesity_16, obesity_17= 
                       obesity_17$obesity_17,obesity_18 = obesity_18$obesity_18, 
                     obesity_19 = obesity_19$obesity_19, obesity_20 = 
                       obesity_20$obesity_20, obesity_21 = obesity_21$obesity_21)

states_all <- states

# Add state abbreviations and centers to states_all@data
statenames <- data.frame(
  State = state.name,
  state.abb = state.abb,
  state.center.x = state.center$x,
  state.center.y = state.center$y
)

custom_coordinates <- data.frame(
  State = c("Alaska", "Hawaii"),
  custom_lat = c(61.370716, 20.593684),
  custom_lng = c(-152.404419, -157.643325)
)

states_all@data <- left_join(states_all@data, statenames, by = "State")

states_all@data$state.center.x <- ifelse(states_all@data$State == "Alaska", custom_coordinates$custom_lng[1], states_all@data$state.center.x)
states_all@data$state.center.y <- ifelse(states_all@data$State == "Alaska", custom_coordinates$custom_lat[1], states_all@data$state.center.y)

states_all@data$state.center.x <- ifelse(states_all@data$State == "Hawaii", custom_coordinates$custom_lng[2], states_all@data$state.center.x)
states_all@data$state.center.y <- ifelse(states_all@data$State == "Hawaii", custom_coordinates$custom_lat[2], states_all@data$state.center.y)



# Define UI --------------------------------------------------------------------

ui <- fluidPage(
  titlePanel("Nutrition Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("selected_year",
                  "Choose a Year:",
                  min = 2011,
                  max = 2021,
                  value = 2011,
                  step = 1,
                  round = TRUE)
    ),
    
    mainPanel(
      leafletOutput("heatmap_plot")
    )
  )
)


# Define server function --------------------------------------------------------
server <- function(input, output, session) {
  
  # Generate the plot based on the selected country
  output$heatmap_plot <- renderLeaflet({
    
    # Filter data for the selected country
    
    column_name <- paste0("obesity_", substr(input$selected_year, 3, 4))
    obesity_year <- states_all[[column_name]]
    
    bins <- c(20, 23, 26, 29, 32, 35, 38, 41, 44)
    pal <- colorBin("YlOrRd", domain = states_all[[column_name]], bins = bins)
    
    labels <- sprintf(
      "<strong>%s</strong><br/>%g percent",
      states_all@data$name, states_all@data[[column_name]]
    ) %>% lapply(htmltools::HTML)
    
    leaflet(states_all) %>%
      setView(-96, 37.8, 4) %>%
      addProviderTiles("MapBox", options = providerTileOptions(
        id = "mapbox.light",
        accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
      addPolygons(
        fillColor = ~pal(obesity_year),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      # Add state abbreviation labels
      addLabelOnlyMarkers(
        data = states_all@data,
        lng = ~state.center.x,
        lat = ~state.center.y,
        label = ~state.abb,
        labelOptions = labelOptions(
          noHide = TRUE,
          direction = 'middle',
          textOnly = TRUE,
          labelOffset = c(5, 0))
      ) %>%
      addLegend(pal = pal, values = ~obesity_year, opacity = 0.7, 
                title = "Percentage of Obesity (%)", position = "bottomright")
    
  })
}

# Create the Shiny app object --------------------------------------------------
shinyApp(ui = ui, server = server)