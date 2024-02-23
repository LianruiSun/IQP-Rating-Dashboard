library(shiny)
library(ggplot2)
library(lubridate)
library(dplyr)



server <- function(input, output, session) {
  
  
  observeEvent(input$dateInput_AK116, {
    
    # Define the path to the temporary file
    temp_file_path <- "www/AK116_temp.csv"
    
    # Check if the file exists, and delete it if it does
    if (file.exists(temp_file_path)) {
      file.remove(temp_file_path)
    }
      # Read the uploaded CSV file
      data <- read.csv("www/AK116_16023.csv")
      
      # Filter the data based on the selected date
      selected_date <- format(as.Date(input$dateInput_AK116), "%Y-%m-%d")
      filtered_data <- data %>%
        filter(substr(timestamp, 1, 10) == selected_date)
      
      # Write the filtered data to a new CSV file
      write.csv(filtered_data, "www/AK116_temp.csv", row.names = FALSE)
    
    AK116_file_path <- "www/AK116_temp.csv"
    AK233_file_path <- "www/AK116_16023.csv"
    OH107_file_path <- "www/AK116_16023.csv"
    OH109_file_path <- "www/AK116_16023.csv"
    UH520_file_path <- "www/AK116_16023.csv"
    UH500_file_path <- "www/AK116_16023.csv"
    SL105_file_path <- "www/AK116_16023.csv"
    SL104_file_path <- "www/AK116_16023.csv"
    FLPL_file_path  <- "www/AK116_16023.csv"
    FLPU_file_path  <- "www/AK116_16023.csv"
    
    # Reading the CSV files
    AK116_data <- read.csv(AK116_file_path, stringsAsFactors = FALSE)
    AK233_data <- read.csv(AK233_file_path, stringsAsFactors = FALSE)
    OH107_data <- read.csv(OH107_file_path, stringsAsFactors = FALSE)
    OH109_data <- read.csv(OH109_file_path, stringsAsFactors = FALSE)
    UH520_data <- read.csv(UH520_file_path, stringsAsFactors = FALSE)
    UH500_data <- read.csv(UH500_file_path, stringsAsFactors = FALSE)
    SL105_data <- read.csv(SL105_file_path, stringsAsFactors = FALSE)
    SL104_data <- read.csv(SL104_file_path, stringsAsFactors = FALSE)
    FLPL_data  <- read.csv(FLPL_file_path, stringsAsFactors = FALSE)
    FLPU_data  <- read.csv(FLPU_file_path, stringsAsFactors = FALSE)
    
    # Setting column names
    names(AK116_data) <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    names(AK233_data) <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    names(OH107_data) <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    names(OH109_data) <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    names(UH520_data) <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    names(UH500_data) <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    names(SL105_data) <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    names(SL104_data) <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    names(FLPL_data)  <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    names(FLPU_data)  <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    
  # Convert Timestamp from UTC to Eastern Time
  AK116_data <- AK116_data %>%
    mutate(Timestamp = ymd_hms(Timestamp, tz = "UTC"), # Parse as UTC
           Timestamp = with_tz(Timestamp, "America/New_York")) # Convert to Eastern Time  
  
  # if (any(is.na(AK116_data$Timestamp))) {
  #   stop("Timestamp conversion failed. Check the format.")
  # }
  
  AK116_data_reactive <- reactive({
    source("AK116_API.R", local = TRUE)
    AK116_data_real
  })
  AK233_data_reactive <- reactive({
    source("room_data.R", local = TRUE)
    AK233_data_real
  })
  OH107_data_reactive <- reactive({
    source("room_data.R", local = TRUE)
    OH107_data_real
  })
  OH109_data_reactive <- reactive({
    source("room_data.R", local = TRUE)
    OH109_data_real
  })
  UH520_data_reactive <- reactive({
    source("room_data.R", local = TRUE)
    UH520_data_real
  })
  UH500_data_reactive <- reactive({
    source("room_data.R", local = TRUE)
    UH500_data_real
  })
  SL105_data_reactive <- reactive({
    source("room_data.R", local = TRUE)
    SL105_data_real
  })
  SL104_data_reactive <- reactive({
    source("room_data.R", local = TRUE)
    SL104_data_real
  })
  phLower_data_reactive <- reactive({
    source("room_data.R", local = TRUE)
    phLower_data_real
  })
  phUpper_data_reactive <- reactive({
    source("room_data.R", local = TRUE)
    phUpper_data_real
  })
  
  # Function to generate UI for each room
  generateRoomUI <- function(roomName, roomPrefix, roomData, environmentData) {
    
    # Stop Shiny when close the window
    session$onSessionEnded(function() {
      stopApp()
    })
    
    fluidPage(
      tags$head(tags$style(
        HTML(
          "
        .room-title {
          font-weight: bold;
        }
        .color-square {
          padding: 20px;
          padding-top: 50px; /* Increase top padding */
          padding-bottom: 50px; /* Increase bottom padding */
          color: white;
          text-align: center;
          margin-top: 10px;
          border-radius: 15px; /* Rounded corners */
        }
        .score {
          background-color: #5DADE2; /* Blue */
        }
        .student-rating {
          background-color: #58D68D; /* Green */
        }
        .description {
          background-color: #F5B041; /* Orange */
        }
      "
        )
      )),
      
      tags$head(tags$style(
        HTML(".responsive-size { width: 100%; height: auto; }")
      )),
      
      h1(roomName, class = "room-title"),
      fluidRow(
        tags$style(
          HTML("
      .custom-color h3,
      .custom-color .fa {
        color: #AC2B37;
      }
    ")
        ),
        div(
          class = "equal-height-row",
          # Add this class to your fluidRow
          
          # Image of classroom
          column(4,
                 tags$img(
                   src = paste0(roomPrefix, ".jpg"), class = "responsive-size"
                 ),
                 class = "equal-height-col"),
          
          
          # Environment data
          column(4,
                 div(
                   class = "custom-color",
                   div(
                     class = "box card",
                     div(h3(
                       tags$i(class = "fas fa-thermometer-half"), " Temperature"
                     ), roomData$temp, " °C"),
                     div(h3(
                       tags$i(class = "fas fa-tint"), " Humidity"
                     ), roomData$humidity, " %"),
                     div(h3(tags$i(class = "fas fa-cloud"), " CO2:"), roomData$co2, " ppm"),
                     div(h3(tags$i(class = "fas fa-wind"), " TVOCs"), roomData$tvocs, " ppb"),
                     div(h3(tags$i(class = "fas fa-smog"), " PM2.5"), roomData$pm25, " µg/m³"),
                     div(h3(
                       tags$i(class = "fas fa-volume-up"), " Noise"
                     ), roomData$noise, " dB"),
                     div(h3(
                       tags$i(class = "fas fa-lightbulb"), " Light"
                     ), roomData$light, " lx")
                   )
                 )),
          
          # Detail
          column(4,
                 div(
                   class = "custom-color",
                   div(
                     class = "box card",
                     h2("Details"),
                     h3(tags$i(class = "fas fa-fw fa-building"), " Building"),
                     p(
                       id = "building-common",
                       a(href = roomData$building_hef, roomData$building)
                     ),
                     h3(tags$i(class = "fas fa-fw fa-layer-group"), " Room Type"),
                     p("classroom"),
                     
                     h3(tags$i(class = "fas fa-fw fa-map-marker"), " Room"),
                     p(roomPrefix),
                     
                     h3(tags$i(class = "fas fa-fw fa-users"), " Seats"),
                     p(roomData$seats),
                     
                     h3(tags$i(class = "fas fa-fw fa-desktop"), " Computers"),
                     p(roomData$computer),
                     
                     h3(tags$i(class = "fas fa-fw fa-clock"), " Last Updated"),
                     p(roomData$updated)
                   )
                 ))
        )
      ),
      selectInput(
        "plot",
        "Plot choose",
        choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
      ),
      
      renderPlot({
        if (input$plot %in% c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")) {
          # Calculate the average of the y-values
          avg_y <- mean(AK116_data[[input$plot]], na.rm = TRUE)
          
          # Determine the range values based on the selected input
          if (input$plot == "Score") {
            range_start <- 80
            range_end <- 100
            bad_range_start <- 0
            bad_range_end <- 60
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(AK116_data[[input$plot]], na.rm = TRUE), 50)
            y_limit_upper <- max(max(AK116_data[[input$plot]], na.rm = TRUE), 100)
          } 
          else if (input$plot == "Temp") {
            range_start <- 19
            range_end <- 23
            bad_range_start <- 18
            bad_range_end <- 25
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(AK116_data[[input$plot]], na.rm = TRUE), 15)
            y_limit_upper <- max(max(AK116_data[[input$plot]], na.rm = TRUE), 30)
          }
          else if (input$plot == "Humid") {
            range_start <- 40
            range_end <- 50
            bad_range_start <- 35
            bad_range_end <- 60
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(AK116_data[[input$plot]], na.rm = TRUE), 20)
            y_limit_upper <- max(max(AK116_data[[input$plot]], na.rm = TRUE), 35)
          }
          else if (input$plot == "co2") {
            range_start <- 0
            range_end <- 600
            bad_range_start <- 1000
            bad_range_end <- 1300
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(AK116_data[[input$plot]], na.rm = TRUE), 400)
            y_limit_upper <- max(max(AK116_data[[input$plot]], na.rm = TRUE), 1000)
          }
          else if (input$plot == "voc") {
            range_start <- 0
            range_end <- 400
            bad_range_start <- 1000
            bad_range_end <- 2000
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(AK116_data[[input$plot]], na.rm = TRUE), 0)
            y_limit_upper <- max(max(AK116_data[[input$plot]], na.rm = TRUE), 1000)
          }
          else if (input$plot == "pm25") {
            range_start <- 0
            range_end <- 15
            bad_range_start <- 35
            bad_range_end <- 45
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(AK116_data[[input$plot]], na.rm = TRUE), 0)
            y_limit_upper <- max(max(AK116_data[[input$plot]], na.rm = TRUE), 35)
          }
          else if (input$plot == "noise") {
            range_start <- 0
            range_end <- 45
            bad_range_start <- 85
            bad_range_end <- 200
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(AK116_data[[input$plot]], na.rm = TRUE), 45)
            y_limit_upper <- max(max(AK116_data[[input$plot]], na.rm = TRUE), 85)
          }
          else if (input$plot == "light") {
            range_start <- 300
            range_end <- 500
            bad_range_start <- 100
            bad_range_end <- 600
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(AK116_data[[input$plot]], na.rm = TRUE), 100)
            y_limit_upper <- max(max(AK116_data[[input$plot]], na.rm = TRUE), 400)
          }
          else{
            range_start <- 0
            range_end <- 0
            bad_range_start <- 0
            bad_range_end <- 0
            y_limit_lower <- 0
            y_limit_upper <- 0
          }
          
          # Create the plot
          p <- ggplot(AK116_data, aes_string(x="Timestamp", y=input$plot)) +
            geom_point(size = 2) +
            geom_hline(yintercept = avg_y, color = "blue", linetype = "dashed") +
            geom_hline(yintercept = range_start, color = "green", linetype = "dashed") +
            geom_hline(yintercept = range_end, color = "green", linetype = "dashed") +
            geom_hline(yintercept = bad_range_start, color = "red", linetype = "dashed") +
            geom_hline(yintercept = bad_range_end, color = "red", linetype = "dashed") +
            labs(title=paste(input$plot, "Over Time"), x="Timestamp", y=input$plot) +
            theme_minimal() +
            theme(
              text = element_text(size = 16), # Increase general text size
              axis.title = element_text(size = 16) # Increase axis label size
            ) +
            coord_cartesian(ylim = c(y_limit_lower, y_limit_upper)) # Setting y-axis limits
          print(p)
        }
      })
      
    )
  }
  
  output$AK116_score <- renderUI({
    generateRoomUI("Atwater Kent Laboratories - Room 116",
                   "AK116",
                   AK116_data_reactive(),
                   AK116_data)
  })
  
  output$AK233_score <- renderUI({
    generateRoomUI("Atwater Kent Laboratories - Room 233",
                   "AK233",
                   AK233_data_reactive(),
                   AK233_data)
  })
  
  output$OH107_score <- renderUI({
    generateRoomUI("Olin Hall - Room 107",
                   "OH107",
                   OH107_data_reactive(),
                   OH107_data)
  })
  
  output$OH109_score <- renderUI({
    generateRoomUI("Olin Hall - Room 109",
                   "OH109",
                   OH109_data_reactive(),
                   OH109_data)
  })
  
  output$UH520_score <- renderUI({
    generateRoomUI("Unity Hall - Room 520",
                   "UH520",
                   UH520_data_reactive(),
                   UH520_data)
  })
  
  output$UH500_score <- renderUI({
    generateRoomUI("Unity Hall - Room 500",
                   "UH500",
                   UH500_data_reactive(),
                   UH500_data)
  })
  
  output$SL105_score <- renderUI({
    generateRoomUI("Salisbury Laboratories - Room 105",
                   "SL105",
                   SL105_data_reactive(),
                   SL105_data)
  })
  
  output$SL104_score <- renderUI({
    generateRoomUI("Salisbury Laboratories - Room 104",
                   "SL104",
                   SL104_data_reactive(),
                   SL104_data)
  })
  
  output$phLower_score <- renderUI({
    generateRoomUI("Fuller Labs - PH-Lower",
                   "FLPL",
                   phLower_data_reactive(),
                   FLPL_data)
  })
  
  output$phUpper_score <- renderUI({
    generateRoomUI("Fuller Labs - PH-Upper",
                   "FLPU",
                   phUpper_data_reactive(),
                   FLPU_data)
  })

  })
  
}