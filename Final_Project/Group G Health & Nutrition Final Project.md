---
title: "Group G Health & Nutrition Website"
author: "Moises Escobar, Justin Ko, Kexu Duan, Yiwei Li"
output: md_document
  prettydoc::html_pretty:
    theme: cayman
    toc: true
    sidebar: true
    collapsed: true

---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r, echo=FALSE, results = 'hide', message = FALSE, warning = FALSE, error = FALSE, message = FALSE}
# Load all packages
library(readxl)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(geojsonio)
library(leaflet)
library(DT)
library(shiny)
library(RColorBrewer)
library(readr)
library(leaflet.extras)
library(sf)
library(plotly)
library(tidyverse)
library(lubridate)
library(stringr)
library(wordcloud2)
library(countrycode)
library(ggimage)
library(htmltools)
library(hrbrthemes)
library(ggrepel)
library(tibble)
library(maps)
library(statebins)
library(datasets)
library(ggraph)
library(igraph)
library(scatterD3)
library(wordcloud2) 
```

```{r, echo=FALSE, results = 'hide', message = FALSE, warning = FALSE, error = FALSE, message = FALSE}
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

# U.S. Map 2011
states@data <- cbind(states@data, obesity_11)
states_11 <- states 

# U.S. Map 2012
states@data <- cbind(states@data, obesity_12)
states_12 <- states

# U.S. Map 2013
states@data <- cbind(states@data, obesity_13)
states_13 <- states

# U.S. Map 2014
states@data <- cbind(states@data, obesity_14)
states_14 <- states

# U.S. Map 2015
states@data <- cbind(states@data, obesity_15)
states_15 <- states

# U.S. Map 2016
states@data <- cbind(states@data, obesity_16)
states_16 <- states

# U.S. Map 2017
states@data <- cbind(states@data, obesity_17)
states_17 <- states

# U.S. Map 2018
states@data <- cbind(states@data, obesity_18)
states_18 <- states

# U.S. Map 2019
states@data <- cbind(states@data, obesity_19)
states_19 <- states

# U.S. Map 2020
states@data <- cbind(states@data, obesity_20)
states_20 <- states

# U.S. Map 2021
states@data <- cbind(states@data, obesity_21)
states_21 <- states
```
## Introduction

Welcome to our Data Visualization final project on health and nutrition in the United States! This is an important issue with consequences that impact every one of us and we are excited to shed some light on it. According to Harvard’s T.H. Chan School of Public Health, 69% of Americans are overweight or obese. This is a striking statistic and we believe that by raising awareness for this issue through our analysis, we can help to facilitate a conversation that will lead to actionable change.

This project is divided into three sections: (1) The Current Problem, (2) Challenges to Healthier Diets, and (3) Potential Solutions.

## Current Problem

![](/Users/justin/Downloads/Obesity_Heatmap.gif)

### Obesity Heat Maps
The Shiny interactive app below show heat maps of yearly obesity percentages by state across the country. Our heat maps show data from 2011 to 2021. Looking at these visuals side-by-side, it is clear that obesity is getting worse across the country over time–and it is already at very high levels, with every state having at least 20% obesity and some states actually having over 40% obesity rates. Additionally, we can see regional disparities in health: States in the South have far greater rates of obesity than states on the West coast or in New England. These visuals show the distribution and the severity of the issue across the country.

### Link to US Obesity Shiny App

Please visit [Obesity Heat app](http://127.0.0.1:3526) to explore the interactive visualization.


### BMI of Americans
To better understand the distribution of most Americans’ BMI, we used a survey of the U.S. population completed through the Centiment online survey service in April 2023. The data set included demographic information (including height and weight), knowledge-based questions, and consumption habit questions for 423 observations.

BMI or ‘Body Mass Index’ is a tool that healthcare providers use to estimate the amount of body fat by using height and weight measurements. It can help assess risk factors for certain health conditions. With the height and weight information provided by survey respondents, we calculated BMI for each of them and plotted the distribution. We find that less than a third of respondents are in the healthy range between 18.5 and 24.9 (29.5%), with the majority lying beyond the healthy range.


```{r, echo=FALSE, message = FALSE, warning = FALSE, error = FALSE, message=FALSE, fig.width=8, fig.height=6}
annotation <- data.frame(
   x = c(17),
   y = c(48),
   label = c("Healthy Range")
)

my_histogram <- ggplot(data=cent_final, aes(x = bmi)) +
  geom_histogram(fill='#848884', color='black', binwidth = 5) + # add color argument
  annotate("rect", fill = "darkgreen", alpha = 0.6, 
        xmin = 18.5, xmax = 24.9,
        ymin = 0, ymax = 124) + 
  geom_label(data = annotation, aes(x=x, y=y, label=label)) + 
  theme_minimal() + 
  labs(x = 'BMI', y='Count', title="Histogram of respondents' BMI") +
  scale_y_continuous(breaks = seq(0, max(hist(cent_final$bmi, plot = FALSE)$counts), by = 10), 
                     limits = c(0, 130)) +
  scale_x_continuous(breaks = seq(10, 60, by = 10)) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "gray")
  )

my_histogram




```

Data: Survey of the U.S. population completed through the Centiment online
survey service in April 2023. The data set includes demographic information,
knowledge-based questions, and consumption habit questions for 423 observations.

Below, we have added a table where you can follow the height and weight axes to estimate your BMI and see where you land on the distribution. Staying informed about your health is the first step to ensuring that you stay in good shape!

<center>

<img src="https://www.builtlean.com/wp-content/uploads/2013/06/Bmi-chart.jpg" alt="BMI Chart">

</center>


## Challenges to Healthier Diets 
### Fast Food Restaurants Across NYC

The following is an interactive leaflet map illustrating the distribution of franchised fast food establishments throughout the five boroughs of New York City. Although the demographic composition of each borough varies by socioeconomic status (SES), the density of these chain restaurants appears to be relatively uniform across the city. These fast food outlets prioritize cost efficiency and are strategically situated to maximize accessibility and convenience, effectively permeating every city block. Prominent examples, such as McDonald’s and Subway, exemplify strategic store placement in key Manhattan locations to optimize their reach. This high level of accessibility to fast food keeps it constantly in consumers’ minds and makes it an easy choice for a quick meal.


```{r, echo=FALSE, message = FALSE, warning = FALSE, error = FALSE, message=FALSE}
# Import dataset
FastFoodRestaurants <- read_csv("/Users/justin/Downloads/US_Fast_Food_Restaurants - Sheet1.csv")

# Filter data by specific state (e.g., New York) and latitude and longitude bounds
FastFoodRestaurants_NY <- FastFoodRestaurants %>% 
  filter(province == "NY" & 
         latitude >= 40.0 & latitude <= 41.0 &
         longitude >= -75.5 & longitude <= -73.5) %>%
 mutate(name = ifelse(name == "SUBWAY", "Subway", name))

# Define a color palette based on the unique restaurant names
color_palette <- colorFactor(palette = "viridis", domain = unique(FastFoodRestaurants_NY$name))

# Set the image URLs to the hosted images
mcdonalds_logo_url <- "https://upload.wikimedia.org/wikipedia/commons/5/50/McDonald%27s_SVG_logo.svg"
subway_logo_url <- "https://1000logos.net/wp-content/uploads/2017/06/Subway-logo.png"
dunkin_donuts_logo_url <- "https://i.pinimg.com/originals/5a/f4/2b/5af42b2e31010a24ac46d2cb5a0e60a6.png"
burger_king_logo_url <- "https://upload.wikimedia.org/wikipedia/commons/8/85/Burger_King_logo_%281999%29.svg"
taco_bell_logo_url <- "https://1000logos.net/wp-content/uploads/2017/06/Taco-Bell-Logo-1024x640.png"
kfc_logo_url <- "https://1000logos.net/wp-content/uploads/2017/03/Kfc_logo-768x432.png"
# Set the image URLs for the new restaurants
boston_market_logo_url <- "https://cdn.freebiesupply.com/logos/large/2x/boston-market-2-logo-png-transparent.png"
fuku_logo_url <- "https://eatfuku.com/wp-content/themes/fuku-3/images/logo.svg"
dominos_pizza_logo_url <- "https://1000logos.net/wp-content/uploads/2023/04/Dominos-logo.png"
baskin_robbins_logo_url <- "https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Baskin-Robbins_logo_2022.svg/2880px-Baskin-Robbins_logo_2022.svg.png"
panera_bread_logo_url <- "https://logos-download.com/wp-content/uploads/2016/11/Panera_Bread_logo_symbol.png"
wendys_logo_url <- "https://www.mashed.com/img/gallery/dont-believe-this-myth-about-the-wendys-logo/intro-1611697081.jpg"
chipotle_mexican_grill_logo_url <- "https://upload.wikimedia.org/wikipedia/en/thumb/3/3b/Chipotle_Mexican_Grill_logo.svg/1200px-Chipotle_Mexican_Grill_logo.svg.png"
little_caesars_pizza_logo_url <- "https://www.gaylordmichigan.net/wp-content/uploads/2017/06/Untitled-design-2023-03-22T114407.307.png"
popeyes_logo_url <- "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Popeyes_logo.svg/1200px-Popeyes_logo.svg.png"
five_guys_logo_url <- "https://dynl.mktgcdn.com/p/FIoFKEm46-afGyd-Yl2FKX-ma356Q63KQxQ-4kDqcng/1001x1001.png"
sbarro_logo_url <- "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Sbarro_logo.svg/1200px-Sbarro_logo.svg.png"
git_it_n_git_logo_url <- "https://media-cdn.grubhub.com/image/upload/d_search:browse-images:default.jpg/w_80,q_80,fl_lossy,dpr_2.0,c_fit,f_auto,h_80/w8jzu4c4zofnvdof6ssi"
b_good_logo_url <- "https://mma.prnewswire.com/media/558745/BGOOD_Logo.jpg?p=twitter"
thirty_first_avenue_gyro_logo_url <- "https://media-cdn.grubhub.com/image/upload/d_search:browse-images:default.jpg/w_80,q_80,fl_lossy,dpr_2.0,c_fit,f_auto,h_80/wopcjumnf4dvzvyj8tej"
arbys_logo_url <- "https://upload.wikimedia.org/wikipedia/commons/f/f4/Arby%27s_logo.svg"
smashburger_logo_url <- "https://nmgprod.s3.amazonaws.com/media/files/79/8e/798ee36529dc2cdc121456549c0b0051/cover_image_1617194867.png.760x400_q85_crop_upscale.png"
white_castle_logo_url <- "https://logodownload.org/wp-content/uploads/2021/05/white-castle-logo.png"
kennedy_fried_chicken_pizza_logo_url <- "https://media-cdn.grubhub.com/image/upload/d_search:browse-images:default.jpg/w_300,q_100,fl_lossy,dpr_2.0,c_fit,f_auto,h_300/iu3ttxzx4yppjmzszpct"
dairy_queen_logo_url <- "https://cdn.lovesavingsgroup.com/logos/dq.png"
blimpie_logo_url <- "https://searchvectorlogo.com/wp-content/uploads/2021/02/blimpie-americas-sub-shop-logo-vector.png"
nathans_famous_logo_url <- "https://mms.businesswire.com/media/20221214005201/en/1663867/5/Nathan%27s_Famous_Logos-27.jpg"
pizza_hut_logo_url <- "https://upload.wikimedia.org/wikipedia/sco/thumb/d/d2/Pizza_Hut_logo.svg/2177px-Pizza_Hut_logo.svg.png"
wendys_logo_url <- "https://www.clipartmax.com/png/middle/157-1572782_wendys-wendys-logo-png.png"
papa_johns_logo_url <- "https://cdn.freebiesupply.com/logos/large/2x/papa-johns-pizza-1-logo-svg-vector.svg"
westchester_burger_logo_url <- "https://www.westchesterburger.com/stamford/images/logo.png"


# Define a function to conditionally display the logos
conditional_logo <- function(restaurant_name) {
  if (restaurant_name == "McDonald's") {
    return(paste0('<img src="', mcdonalds_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Subway") {
    return(paste0('<img src="', subway_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Dunkin' Donuts") {
    return(paste0('<img src="', dunkin_donuts_logo_url, '" width="90px" height="100px">'))
  } else if (restaurant_name == "Burger King") {
    return(paste0('<img src="', burger_king_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Taco Bell") {
    return(paste0('<img src="', taco_bell_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "KFC") {
    return(paste0('<img src="', kfc_logo_url, '" width="140px" height="100px">'))
  } else if (restaurant_name == "Boston Market") {
    return(paste0('<img src="', boston_market_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Fuku") {
    return(paste0('<img src="', fuku_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Domino's Pizza") {
    return(paste0('<img src="', dominos_pizza_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Baskin-Robbins") {
    return(paste0('<img src="', baskin_robbins_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Panera Bread") {
    return(paste0('<img src="', panera_bread_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Wendy's") {
    return(paste0('<img src="', wendys_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Westchester Burger Company") {
    return(paste0('<img src="', westchester_burger_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Papa John's Pizza") {
    return(paste0('<img src="', papa_johns_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Chipotle Mexican Grill") {
    return(paste0('<img src="', chipotle_mexican_grill_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Little Caesars Pizza") {
    return(paste0('<img src"', little_caesars_pizza_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Popeyes") {
    return(paste0('<img src="', popeyes_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Five Guys") {
    return(paste0('<img src="', five_guys_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Sbarro") {
    return(paste0('<img src="', sbarro_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Git-It-N-Git") {
    return(paste0('<img src="', git_it_n_git_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "B. Good") {
    return(paste0('<img src="', b_good_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "31st Avenue Gyro") {
    return(paste0('<img src="', thirty_first_avenue_gyro_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Arby's") {
    return(paste0('<img src="', arbys_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Smashburger") {
    return(paste0('<img src="', smashburger_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "White Castle") {
    return(paste0('<img src="', white_castle_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Kennedy Fried Chicken & Pizza") {
    return(paste0('<img src="', kennedy_fried_chicken_pizza_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Dairy Queen") {
    return(paste0('<img src="', dairy_queen_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Blimpie") {
    return(paste0('<img src="', blimpie_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Nathan's Famous") {
    return(paste0('<img src="', nathans_famous_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Pizza Hut") {
    return(paste0('<img src="', pizza_hut_logo_url, '" width="100px" height="100px">'))
  } else if (restaurant_name == "Wendy's") {
    return(paste0('<img src="', wendys_logo_url, '" width="410" height="100px">'))
  } else {
    return("")
  }
}

# Create Leaflet map with marker cluster option
FastFoodRestaurants_NY_map <- leaflet(FastFoodRestaurants_NY) %>%
  addTiles() %>%
  addAwesomeMarkers(lng = ~longitude, lat = ~latitude,
                    icon = ~awesomeIcons(
                      icon = 'star',  # Choose an icon shape
                      library = 'fa', # Choose an icon library
                      markerColor = color_palette(FastFoodRestaurants_NY$name) # Set marker color based on "name" column
                    ),
                    popup = paste("Name:", FastFoodRestaurants_NY$name, "<br>",
                                  "Address:", FastFoodRestaurants_NY$address, "<br>",
                                  "City:", FastFoodRestaurants_NY$city, "<br>",
                                  "Province:", FastFoodRestaurants_NY$province, "<br>",
                                  "Postal Code:", FastFoodRestaurants_NY$postalCode, "<br>",
                                  sapply(FastFoodRestaurants_NY$name, conditional_logo)), # Add hosted image to the popup
                    clusterOptions = markerClusterOptions()) %>%
  setView(lng = -74.0060, lat = 40.7128, zoom = 10)  # Set initial map view to the center of New York City

# Display the map
FastFoodRestaurants_NY_map

```

Data: Fast Food Restaurants Across NYC | Kaggle
https://www.kaggle.com/datasets/datafiniti/fast-food-restaurants

### Relationship between Healthcare Spending and Life Expectancy

In the visual below, we remade a commonly depicted chart which shows how US healthcare expenditures per capita are far higher than other nations, even at similar levels of development. However, life expectancy is actually lower than some comparable Western European countries, like France and the United Kingdom. This diagram illustrates the inefficiency of healthcare spending in the United States and shows how even though there is a lot of money going through the healthcare system, Americans are not receiving the benefits of these expenditures.


```{r, echo=FALSE, message = FALSE, warning = FALSE, error = FALSE, message=FALSE}
# Import dataset
life <- read_excel("/Users/justin/Downloads/812013161P1G003.XLS", 
                   sheet = "Data1.1.3", skip = 6)
life <- life[c(-4,-6)]
names(life) <- c("country","code","life_expectancy","Health_spending")
life <- na.omit(life)
life$country_name <- countrycode(life$code, "iso2c", "country.name")

# Create a vector of country codes to label
selected_countries <- c("US", "CN", "GB", "FR", "MX", "BR", "ZA")

# Create the ggplot object
p <- ggplot(life, aes(x = Health_spending, y = life_expectancy)) +
  geom_point(aes(size = Health_spending), color = "darkgreen", alpha = 0.7) +
  labs(title = "Relationship between Healthcare Spending and Life Expectancy",
       x = "Total Healthcare Expenditure",
       y = "Life Expectancy (years)") +
  theme_ipsum() +
  
  #Add flag icon to the selected countries
  geom_flag(data = life[life$code %in% selected_countries,], aes(image = code), size = 0.1) +

  # Add labels with ggrepel
  geom_text_repel(
    data = life[life$code %in% selected_countries,],
    aes(label = country_name),
    color = "black",
    size = 9/.pt, 
    point.padding = 0.1, 
    box.padding = 0.6,
    min.segment.length = unit(0.1, "lines"),
    max.overlaps = 1000,
    seed = 7654 
  ) +

  # Change legend title
  scale_size(name = "Healthcare spending (in millions)") 

# Display the plot
print(p)

```

## Potential Solutions
### National School Lunch By Year

Offering healthy school lunches is an excellent way to inculcate good eating habits in children at a young age. This is especially important since these are the habits that they will carry with them for the rest of their lives. This diagram shows a couple of key pieces of information. The first is that the total number of school lunches served has increased substantially since 1970 (2020 is an exception due to Covid-19). This shows the increased amount of funding going through school systems for nutrition and the opportunity that exists to set good habits at a young age. The second is that the percentage of lunches that are being offered at reduced prices, or that are entirely free, has also increased in this time period. Providing low-income students with access to the right food options is important since they are less likely to have access to healthy food options at home.

```{r, echo=FALSE, message = FALSE, warning = FALSE, error = FALSE, message=FALSE}
fruits_per_capita_availability <- read.csv('/Users/justin/Downloads/drive-download-20230503T032305Z-001/Fruits_Per capita availability adjusted for loss.csv')

vegetables_per_capita_availability <- read.csv('/Users/justin/Downloads/drive-download-20230503T032305Z-001/Vegetables_Per capita availability adjusted for loss.csv')

cheese_n_redmeat_per_capita_availability <- read.csv('/Users/justin/Downloads/drive-download-20230503T032305Z-001/Cheese_n_RedMeat_Per capita availability adjusted for loss.csv')

national_school_lunch <- read.csv("/Users/justin/Downloads/drive-download-20230503T032305Z-001/NATIONAL SCHOOL LUNCH PROGRAM.csv")

national_school_lunch_by_year <- read.csv("/Users/justin/Downloads/drive-download-20230503T032305Z-001/NATIONAL SCHOOL LUNCH PROGRAM By Year.csv")

child_n_adult_care_food <- read.csv("/Users/justin/Downloads/drive-download-20230503T032305Z-001/CHILD AND ADULT CARE FOOD PROGRAM.csv")

child_n_adult_care_food_by_year <- read.csv("/Users/justin/Downloads/drive-download-20230503T032305Z-001/CHILD AND ADULT CARE FOOD PROGRAM_by_year.csv")

national_school_lunch_by_year$Total.Lunches.Served..millions. <- as.numeric(national_school_lunch_by_year$Total.Lunches.Served..millions.)

national_school_lunch_by_year$Percent.Free.RP <- as.numeric(national_school_lunch_by_year$Percent.Free.RP)

national_school_lunch_by_year %>%
  ggplot(aes(x = Year)) +
  geom_col(data = . %>% filter(Year %% 5 == 0), # Filter data for every 5 years
           aes(y = Total.Lunches.Served..millions., fill = "Total Lunches")) +
  geom_line(aes(y = Percent.Free.RP*40, color = "Percent Free/Reduced"), size = 1.2) +
  xlab("Year") +
  ylab("Total Lunches Served (millions)") +
  scale_y_continuous(
    sec.axis = sec_axis(~ . / 40, name = "Percentage of Free or Reduced Cost School Lunch (%)")
  ) +
  ggtitle("Statistics on National School Lunch By Year") +
  scale_fill_manual(values = "darkgreen") +
  scale_color_manual(values = "orange") +
  theme(legend.title = element_blank()) +
  theme(
    panel.background = element_blank(),
    panel.grid.major = element_line(colour = "gray", size = 0.5),
    panel.grid.minor = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.title.y.right = element_text(size = 14, color = "orange"),
    axis.title.y.left = element_text(size = 14, color = "darkgreen")
  ) +
  scale_x_continuous(
    breaks = seq(1940, 2022, by = 5) # Set year axis to intervals of 5 years
  )


```


### Special Diets Among Adults Aged 20 and Over in the United States from 2007 to 2018

The subsequent interactive line graph highlights the prevalence of various specialized diets among adults aged 20 and over in the United States from 2007 to 2018. The diets include Weight Loss or Low Calorie Diet, Diabetic Diet, Low Carbohydrate Diet, and Low Fat or Low Cholesterol Diet. Notably, the Weight Loss or Low Calorie Diet, which is often linked with plant-based diets, experienced the most significant increase among the four diets. The proportion of U.S. adults following this diet escalated from 7.5 percent in 2007 to 10 percent in 2018. The Diabetic Diet remained relatively stable over time, fluctuating from 1.8 percent to 2.2 percent, as diabetic patients typically adhere to physician-prescribed diets rather than electing to adopt such diets independently. Conversely, the Low Carbohydrate Diet witnessed a substantial increase from 0.9 percent to 2.2 percent over the decade. This diet’s popularity can be attributed to its association with numerous health benefits, such as controlling blood sugar levels and bolstering overall metabolic health. The commonly discussed Ketogenic (Keto) Diet and the Atkins Diet serve as prime examples of low carbohydrate diet plans. Lastly, the Low Fat or Low Cholesterol Diet observed a decline in its share of dietary options. The percentage of U.S. adults adhering to a low-fat diet decreased from 2.7 percent in 2007 to 1.5 percent in 2018, suggesting that this dietary approach may have lost its appeal due to its perceived ineffectiveness in helping individuals achieve their health goals.

```{r, echo=FALSE, message = FALSE, warning = FALSE, error = FALSE, message=FALSE}

diet_data <- data.frame(
  SurveyPeriod = c("2007–2008", "2009–2010", "2011–2012", "2013–2014", "2015–2016", "2017–2018"),
  WeightLossDiet = c(7.5, 8.8, 8.8, 9.2, 8.7, 10),
  DiabeticDiet = c(1.8, 2.4, 1.9, 2, 2.1, 2.2),
  LowCarbDiet = c(0.9, 0.9, 0.9, 1.5, 1.7, 2.2),
  LowFatDiet = c(2.7, 1.9, 1.6, 2.1, 1.9, 1.5)
)

plot <- plot_ly(data = diet_data, x = ~SurveyPeriod, y = ~WeightLossDiet, type = "scatter", mode = "lines+markers", name = "Weight Loss or Low Calorie Diet", line = list(color = "red"))
plot <- plot %>% add_trace(y = ~DiabeticDiet, name = "Diabetic Diet", line = list(color = "darkgreen"))
plot <- plot %>% add_trace(y = ~LowCarbDiet, name = "Low Carbohydrate Diet", line = list(color = "royalblue"))
plot <- plot %>% add_trace(y = ~LowFatDiet, name = "Low Fat or Low Cholesterol Diet", line = list(color = "orange"))

plot <- plot %>% layout(title = "Special Diets Among Adults in the US from 2007 to 2018",
                         xaxis = list(title = "Survey Period"),
                         yaxis = list(title = "Percentage(%)"))

plot

```


Data: Special Diets Among Adults: United States, 2015–2018 | CDC
https://www.cdc.gov/nchs/products/databriefs/db389.htm

### Distribution of Dietary Habit Scores by Age Group

The data for the visual below was derived from the dietary habits questionnaire in the Centiment survey described above. These answers were scored in terms of health and it became immediately clear that older age groups tended to eat healthier than younger ones. This is important because it informs policy with regard to how to target healthy eating campaigns. Moreover, younger individuals will take the habits they develop at a young age through the rest of their lives. Perhaps it makes sense that older individuals tend to eat healthier since they may be dealing with health conditions that force them to follow certain diets. However, the message that should be shared with younger generations is that they should develop the right eating habits now and use them as a preventative measure, rather than waiting to be affected by a health condition before starting to follow healthier consumption patterns.

```{r, echo=FALSE, message = FALSE, warning = FALSE, error = FALSE, message=FALSE}

# Read the CSV file
df <- read.csv("/Users/justin/Downloads/df.csv")

# Define custom color palette
color_palette <- c('yellow','#B5E48C', '#52B69A', '#168AAD', '#184E77')

# Create the plot
p <- df |>
  group_by(age) |>
  mutate(med_d = round(median(d_number_total),2)) |>
  ggplot(aes(x=age, y= d_number_total)) +
  geom_boxplot(aes(fill = as.factor(age))) +  
  scale_fill_manual(values = color_palette) + 
  labs(fill = "Age Group") +  
  theme_minimal() +
  geom_text(aes(x = age, y = med_d, label= med_d),
            vjust = -0.5, size = 3) +
  labs(x = "Age Group", y= "Total Score", title = "Distribution of Dietary Habit
       Scores by Age Group") +
  scale_y_continuous(
    breaks = seq(0, 100, by = 20) 
  )

# Convert ggplot object to interactive plotly object
interactive_plot <- ggplotly(p)

interactive_plot


```
### Dietary Habits by Age Group

We decided to dig deeper into the dietary habits by age group questions in the Centiment survey to better understand where it was that older generations stood out in terms of their food consumption. It became clear that Processed Snack Food and Sweetened Beverages were relatively similar across age groups, but where the older generations really stood out was in their very low consumption of Fast Food / Take-out and Pre-Made Meals. Perhaps this makes sense as older individuals are more likely to be retired and so they have more time to cook homemade meals. Healthy eating campaigns should stress the benefits of cooking at home to younger generations to help them develop this habit and hopefully improve their health as a result. Note how the high level of fast food accessibility (see visual above) makes this a significant challenge, especially in big cities.

```{r, echo=FALSE, message = FALSE, warning = FALSE, error = FALSE, message=FALSE}
ppal <- c(
'#B5E48C',
'#52B69A',
'#168AAD',
'#184E77'
)

df |>
  select(age:household_income, d2:d5) |>
  rename("Sweetened Beverages"= d2, "Pre-made Meals"= d3, "Fast Food / Take-out"= d4,
         "Processed Snack Foods"= d5) |>
  pivot_longer(`Sweetened Beverages`: `Processed Snack Foods`, names_to = "question",
               values_to = "response") |>
  mutate(response = factor(response, levels=c('At least once daily', '3 to 5 times a week',
                                              '3 to 5 times a month', 'Once a month or less'))) |>
  ggplot(aes(x =age, fill = response)) +
  geom_bar(position='fill') + 
  facet_wrap(~question) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
  scale_fill_manual(values = ppal) + 
  scale_y_continuous(labels = scales::percent) + 
  labs(x = 'Age Group', y='Percentage', fill='Frequency',
       title = 'Dietary Habits by Age Group')
```

### Datatable of Nutritional Information of the Most Common Food
To emphasize the significance of health and nutrition literacy at an individual level, an interactive, searchable data table has been assembled, enabling users to identify and sort various food items based on their respective quantities, caloric content, protein, fat, saturated fat, fiber, carbohydrate levels, and other associated categories. Having comprehensive nutritional information is particularly beneficial to users adhering to specific fitness and dietary regimens tailored to their personal needs and preferences. The data frame also includes many ingredients that facilitate the creation of diverse and nutritious recipes. This resource serves as an invaluable tool for individuals hoping to make informed decisions in relation to personal dietary choices and overall health.

```{r, echo=FALSE, message = FALSE, warning = FALSE, error = FALSE, message=FALSE}


# Read the data
df <- read.csv("/Users/justin/Downloads/nutrients_new.csv", header = FALSE, skip = 2)

# Rename columns
colnames(df) <- c("Food Name", "Measure", "Grams", "Calories(kcal)", "Protein(g)", "Fat(g)", "Saturated Fat(g)", "Fiber(g)",
                 "Carbohydrates(g)", "Category")

# Format numeric columns
df_formatted <- df %>%
  mutate(across(where(is.numeric), round, 2))

# Create a color palette for the categories
unique_categories <- unique(df_formatted$Category)
color_palette <- colorRampPalette(brewer.pal(9, "Set1"))(length(unique_categories))
names(color_palette) <- unique_categories

# Apply the category colors to the dataframe
df_formatted$CategoryColor <- color_palette[df_formatted$Category]

# Create an interactive table using DT
datatable(df_formatted[, -which(names(df_formatted) == "CategoryColor")], # remove the "CategoryColor" column
          options = list(pageLength = 10, dom = 'Bfrtip', buttons = c('csv', 'excel', 'pdf', 'print')),
          rownames = FALSE,
          caption = tags$caption(tags$style(HTML("caption {font-size: 1.5em; font-weight: bold;}")),
                                 "Nutrient Data for Various Foods"),
          extensions = c('Buttons')) %>%
  formatStyle(names(df_formatted)[-which(names(df_formatted) == "CategoryColor")], # remove the "CategoryColor" column from names(df_formatted)
              fontWeight = styleEqual(names(df_formatted)[-which(names(df_formatted) == "CategoryColor")], "bold"),
              backgroundColor = styleEqual(names(df_formatted)[-which(names(df_formatted) == "CategoryColor")], "lightblue")) %>%
  formatStyle("Food Name",
              color = "black",
              fontWeight = "bold") %>%
  formatStyle(1:nrow(df_formatted), # color the entire row based on the "CategoryColor" column
              backgroundColor = styleEqual(df_formatted$CategoryColor, df_formatted$CategoryColor),
              include = TRUE)
```

Data: Nutritional Facts for most common foods | Kaggle
https://www.kaggle.com/datasets/niharika41298/nutrition-details-for-most-common-foods

## Process Codebook

## Authors

### Justin Ko 

Graduate School of Arts and Sciences - QMSS

jk3938@columbia.edu

<img src="/Users/justin/Downloads/justin.jpg" alt="Image caption" width="150" height="auto">

### Moises Escobar 
Graduate School of Arts and Sciences - QMSS

me2801@columbia.edu

<img src="/Users/justin/Downloads/moises.jpg" alt="Image caption" width="150" height="auto">

### Kexu Duan 
Graduate School of Arts and Sciences - QMSS

kd2865@columbia.edu

<img src="/Users/justin/Downloads/dora.jpg" alt="Image caption" width="150" height="auto">

### Yiwei Li
Graduate School of Arts and Sciences - QMSS

yl5063@columbia.edu

<img src="/Users/justin/Downloads/leo.jpg" alt="Image caption" width="150" height="auto">
