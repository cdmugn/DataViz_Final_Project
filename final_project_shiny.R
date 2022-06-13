
library(tidyverse)
library(leaflet)
library(ggplot2)
library(shinythemes)

rating_df <- read_csv("data/stylereview.csv")
cities_df <- read_csv("data/uscities.csv")
beer_df <- read_csv("data/beer.csv")

beer_city <- left_join(beer_df, cities_df, by = c("City" = "city")) %>% filter(State == state_id) %>% select(1:11, 17:19)

beer_city <- left_join(beer_city, rating_df, by = c("Style" = "Style")) %>% select(1:13, 17, 18) %>% rename(Style_rating = review_avg)

style_df <- beer_city %>% group_by(Style) %>%
  summarise(meanABV = mean(ABV, na.rm = TRUE)) %>% 
  ungroup() %>%
  mutate(Style = fct_reorder(Style, meanABV))

beer_city$StyleColor <- cut(beer_city$Style_rating, 
                            c(2.1, 3.7,3.8,3.9,4.1), include.lowest = T,
                            labels = c('< 3.7', '3.7-3.8', '3.8-3.9', '3.9-4.1'), na.rm=TRUE)

StyleCol <- colorFactor(c("#BFD3E6", "#9EBCDA", "#8C96C6", "#88419D"), beer_city$StyleColor)

colScale <- scale_colour_manual("Style Rating", breaks = c('< 3.7', '3.7-3.8', '3.8-3.9', '3.9-4.1'),
                                values = c("#BFD3E6", "#9EBCDA", "#8C96C6", "#88419D"))

library(shiny)
ui <- fluidPage(theme = shinytheme("cyborg"),
                titlePanel("Breweries and Beers in U.S.A."),
                tabsetPanel(tabPanel("Beer Map", 
                                     sidebarLayout(sidebarPanel(
                                       strong("Welcome!", style = "color:darkorange"),
                                       p("- This data set is a compiled list of over 2,000 beers from various breweries spread around the U.S.A."), 
                                       p("- Enjoy navigating these tabs in the top left to compare locations, beer styles, and various breweries."), 
                                       p("- Select inputs from the selections on the left side of the screen and watch the right side change!"), 
                                       p("- The maps can be zoomed in and out further with mouse scrolling or the +/- buttons, and surprises might appear           if you click your mouse in certain places."),
                                       p("- Finally, scroll down on the pages to make sure you are not missing any cool content."), 
                                       p("Enjoy exploring!", style = "color:darkorange"),
                                       selectizeInput("citychoice",
                                                      label = "Choose a City", choices = levels(factor(beer_city$City)),
                                                      selected = "Austin"), width = 3),
                                       mainPanel(leafletOutput("leafplot"),
                                                 span(textOutput("tabletitle"), style = "font-size:150%"),
                                                 tableOutput("citybeer")),
                                     )
                ),
                tabPanel("Styles",
                         fluidRow(
                           column(selectizeInput("stylechoice",
                                                 label = "Choose a Style or Multiple", choice = levels(factor(beer_city$Style)),
                                                 selected = "Belgian IPA", multiple = TRUE), width = 2),
                           column(6,
                                  plotOutput("lollipop1"),
                                  plotOutput("lollipop2")),
                           column(4,
                                  leafletOutput("leafplot2"),
                                  tableOutput("stylerating")),
                         )),
                tabPanel("Breweries",
                         fluidRow(
                           column(selectizeInput("brewerychoice",
                                                 label = "Choose a Brewery", choice = levels(factor(beer_city$Name.y)),
                                                 selected = "NorthGate Brewing"),
                                  selectizeInput("brewerychoice2",
                                                 label = "Choose another Brewery", choice = levels(factor(beer_city$Name.y)),
                                                 selected = "Avery Brewing Company"), width = 2),
                           column(3,
                                  span(textOutput("tabletitle2"), style = "font-size:150%"),
                                  tableOutput("brewery1")),
                           column(3,
                                  span(textOutput("tabletitle3"), style = "font-size:150%"),
                                  tableOutput("brewery2")),
                           column(3,
                                  leafletOutput("leafplot3")),
                         ))
                ))
server <- function(input, output, session) {
  
  onecity_df <- reactive({beer_city %>% filter(City == input$citychoice) %>% rename("Beer name" = "Name.x", "Brewery" = "Name.y")
  })
  style <- reactive({beer_city %>% filter(Style %in% input$stylechoice)
  })
  style2 <- reactive({beer_city %>% filter(Style %in% input$stylechoice)%>% group_by(Style) %>%
      summarise(meanABV = mean(ABV, na.rm = TRUE)) %>% 
      ungroup() %>%
      mutate(Style = fct_reorder(Style, meanABV))
  })
  style3 <- reactive({beer_city %>% filter(Style %in% input$stylechoice)%>% group_by(Style) %>%
      summarise(meanIBU = mean(IBU, na.rm = TRUE)) %>% 
      ungroup() %>%
      mutate(Style = fct_reorder(Style, meanIBU))
  })
  style4 <- reactive({beer_city %>% filter(Style %in% input$stylechoice) %>% group_by(Style) %>% summarise(Mean_Rating = mean(Style_rating, na.rm = TRUE)) %>%
      mutate(Style = fct_reorder(Style, Mean_Rating))
  })
  onebrewery_df <- reactive({beer_city %>% filter(Name.y == input$brewerychoice) %>% rename("Beer name" = "Name.x", "Brewery" = "Name.y")
  })
  onebrewery_df2 <- reactive({beer_city %>% filter(Name.y == input$brewerychoice2) %>% rename("Beer name" = "Name.x", "Brewery" = "Name.y")
  })
  both_breweries <- reactive({full_join(onebrewery_df(), onebrewery_df2())
  })
  
  
  output$leafplot <- renderLeaflet({
    leaflet(beer_city) %>%
      flyTo(lng = -98.583, lat = 39.833, zoom = 6) %>% 
      addTiles() %>% 
      addProviderTiles(providers$Wikimedia) %>% 
      addCircleMarkers(lng = beer_city$lng, lat = beer_city$lat, clusterOptions = markerClusterOptions(singleMarkerMode = TRUE, color = "Lightpurple"), label = lapply(paste("<strong> Beer name: </strong>", beer_city$Name.x,"<br> <strong> Brewery name: </strong>", beer_city$Name.y), htmltools::HTML))
  })
  
  observe({
    city <- onecity_df()
    leafletProxy("leafplot") %>% fitBounds(min(city$lng), min(city$lat),
                                           max(city$lng+1/4), max(city$lat+1/4))
  })
  
  output$tabletitle <- renderText({
    (input$citychoice)
  })
  
  output$citybeer <- renderTable({ 
    onecity_df() %>% select(3,7,9)
  })
  
  output$lollipop1 <- renderPlot({
    ggplot(data = style(), aes(x = Style, y = ABV)) +
      geom_point(data = style2(), aes(y = meanABV), color = "Orange", size = 3) + 
      geom_point(aes(color = StyleColor), size = 2) + 
      colScale +
      geom_segment((aes(x=Style, xend=Style, y=0, yend=ABV))) + 
      coord_flip() + 
      labs(x = "Beer Style", y = "ABV content", title = "Average ABV content by Beer Style") + theme_gray() + theme(title=element_text(size=14,face="bold",color = "darkorange3"), axis.title = element_text(size = 12, face = "plain", color = "darkorange3"))
  })
  
  output$lollipop2 <- renderPlot({
    ggplot(data = style(), aes(x = Style, y = IBU)) +
      geom_point(data = style3(), aes(y = meanIBU), color = "Orange", size = 3) + 
      geom_point(aes(color = StyleColor), size = 2) + 
      colScale +
      geom_segment((aes(x=Style, xend=Style, y=0, yend=IBU))) + 
      coord_flip() + 
      labs(x = "Beer Style", y = "IBU content", title = "Average IBU content by Beer Style") + theme_gray()  + theme(title=element_text(size=14,face="bold", color = "darkorange3"), axis.title = element_text(size = 12, face = "plain", color = "darkorange3"))
  })
  
  output$leafplot2 <- renderLeaflet({
    leaflet(beer_city) %>%
      flyTo(lng = -98.583, lat = 39.833, zoom = 3) %>% 
      addTiles() %>% 
      addProviderTiles(providers$Wikimedia)
  })
  
  observe({
    style <- style()
    leafletProxy("leafplot2") %>% clearControls() %>% clearMarkerClusters() %>% addCircleMarkers(lng = style$lng, lat = style$lat, label = lapply(paste( "<strong> Beer name: </strong>", style$Name.x, "<br> <strong> Beer style: </strong>", style$Style, "<br> <strong> Brewery name: </strong>", style$Name.y), htmltools::HTML), color = StyleCol(style$StyleColor), clusterOptions = markerClusterOptions(singleMarkerMode = TRUE), opacity = 2, fillOpacity = .5) %>% 
      addLegend('bottomright', pal = StyleCol, values = beer_city$StyleColor, title = 'Style Rating', opacity = 1)
    
  })
  
  output$stylerating <- renderTable({ 
    style4()
  })
  
  output$tabletitle2 <- renderText({
    (input$brewerychoice)
  })
  
  output$brewery1 <- renderTable({
    onebrewery_df() %>% select(3,7,9)
  })
  
  output$tabletitle3 <- renderText({
    (input$brewerychoice2)
  })
  
  output$brewery2 <- renderTable({
    onebrewery_df2() %>% select(3,7,9)
  })
  
  output$leafplot3 <- renderLeaflet({
    leaflet(beer_city) %>%
      flyTo(lng = -98.583, lat = 39.833, zoom = 3) %>% 
      addTiles() %>% 
      addProviderTiles(providers$Wikimedia)
  })
  
  observe({
    brewery <- both_breweries()
    style <- style()
    leafletProxy("leafplot3") %>% clearControls() %>% clearMarkers() %>% clearMarkerClusters() %>% fitBounds(min(brewery$lng), min(brewery$lat), max(brewery$lng+1/2), max(brewery$lat-1/2)) %>% addCircleMarkers(lng = brewery$lng, lat = brewery$lat, label = lapply(paste( "<strong> Beer name: </strong>", brewery$`Beer name`, "<br> <strong> Beer style: </strong>", brewery$Style, "<br> <strong> Brewery name: </strong>", brewery$Brewery), htmltools::HTML), clusterOptions = markerClusterOptions(singleMarkerMode = TRUE), color = StyleCol(brewery$StyleColor), opacity = 2, fillOpacity = .5) %>% addLegend('topright', pal = StyleCol, values = beer_city$StyleColor, title = 'Style Rating', opacity = 1)
  })
}

shinyApp(ui, server)