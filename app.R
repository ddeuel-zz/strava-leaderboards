library(rjson)
library(tidyverse)
library(lubridate)
library(shiny)
library(data.table)
library(googleway)


google_api_key = "AIzaSyDdQiwustqK5psU4Qbemv7gNSysSrZa-gY"

# taking json file to an r list of lists
gal <- fromJSON(file = "leaderboards/galibier.json")

ven <- fromJSON(file = "leaderboards/ventoux.json")

loo <- fromJSON(file = "leaderboards/lookout.json")

mad <- fromJSON(file = "leaderboards/madone.json")

hue <- fromJSON(file = "leaderboards/huez.json")

hal <- fromJSON(file = "leaderboards/haleakala.json")

was <- fromJSON(file = "leaderboards/washington.json")

wil <- fromJSON(file = "leaderboards/willunga.json")

ui <- navbarPage("Strava Leaderboards",
                 tabPanel("Climbs",
                
                   verticalLayout(
                     # climb selection
                     selectInput("leaderboard", "Choose a climb:", 
                                 choices = c("Col du Galibier" = "gal",
                                             "Mont Ventoux" = "ven",
                                             "Lookout Mountain" = "loo",
                                             "Col de la Madone" = "mad",
                                             "Alpe d'Huez" = "hue",
                                             "Haleakala Volcano" = "hal",
                                             "Mount Washington" = "was",
                                             "Willunga Hill" = "wil")
                                 ),

                     google_mapOutput("map"),
                     tags$style("#distance {font-size:30px"),
                     textOutput(outputId = "distance"),
                     tags$style("#grade {font-size:30px"),
                     textOutput(outputId = "grade"),
                     tags$style("#elev {font-size:30px"),
                     textOutput(outputId = "elev"),
                     # slider input for rank range
                     sliderInput(inputId = "ranks",
                                 label = "Number of leaderboard entries:",
                                 min = 2,
                                 max = 50000,
                                 value = 500),
                     plotOutput(outputId = "plot")
                   )
                 ),
                 
                 tabPanel("About",
                          includeMarkdown("README.md")
                 )
)

server <- function(input, output, session) {
  
  # update slider range to match selected dataset
  observe({
    updateSliderInput(
      session,
      inputId = "ranks",
      max = length(get(input$leaderboard)$entries)
    )
  })

  # output some text based metadata
  output$distance <- renderText({
    paste0("Distance: ", round(get(input$leaderboard)$distance / 1000, 1), "km")
    })
  output$grade <- renderText({
    paste0("Average Grade: ", get(input$leaderboard)$average_grade, "%")
  })
  output$elev <- renderText({
    paste0("Elevation Difference: ", get(input$leaderboard)$elevation_high - get(input$leaderboard)$elevation_low, "m")
  })
  
  # google maps embedded output
  output$map <- renderGoogle_map({
    google_map(key = google_api_key) %>%
      add_polylines(data = data.frame(get(input$leaderboard)$map), polyline = "polyline")
  })
  
  # graph for rank vs time
  output$plot <- renderPlot({
    if(!is.null(input$ranks)) {
      rbindlist(get(input$leaderboard)$entries) %>% 
      select(-moving_time, -start_date_local) %>%
      mutate(start_date = ymd_hms(start_date)) %>%
      filter(rank < input$ranks) %>%
      ggplot(aes(x = rank, y = elapsed_time, alpha = 0.5, color = "orangered")) +
      labs(title = "Strava KOM Rank vs Time",
           x = "KOM ranking",
           y = "time (seconds)") +
      geom_point(show.legend = FALSE)
    }
  })
  
}
shinyApp(ui = ui, server = server)
