library(shiny)
library(ggplot2)
library(lubridate)
library(dplyr)
library(readr)


server <- function(input, output, session) {
  base_path <- "www/data/"
  
  # List of file names obtained from the image you've uploaded
  file_names <- c("AK116_16023.csv", "AK233_16429.csv", "FLPL_16130.csv", 
                  "FLPU_15681.csv", "OH107_16145.csv", "OH109_15820.csv", 
                  "SL104_15921.csv", "SL105_16478.csv", "UH500_16586.csv", 
                  "UH520_16280.csv")
  
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
  generateRoomUI <- function(roomName, roomPrefix, roomData, environmentData, date, plot) {
    
    selected_date <- format(as.Date(date), "%Y-%m-%d")
    file_path <- grep(paste0("^", roomPrefix), file_names, value = TRUE)
    
    file_path <- paste0(base_path, file_path)
      
      # Read the CSV file
      data <- read_csv(file_path)
      
      # Process and filter data
      colnames(data)[1] <- "timestamp"
      data$timestamp <- with_tz(as.POSIXct(data$timestamp, format = "%Y-%m-%d %H:%M:%S"), "America/New_York")
      filtered_data <- data %>%
        filter(date(timestamp) == selected_date)
      
      # Write the filtered data to a new temporary CSV file
      temp_file_name <- paste0(sub(".csv", "", roomPrefix), "_temp.csv")
      file_temp_path <- paste0(base_path, temp_file_name)
    
      write_csv(filtered_data, file_temp_path)
      
      # Output the name of the temp file created
      cat("Created temp file:", temp_file_name, "\n")
    
    
    # Reading the CSV files
    data <- read.csv(file_temp_path, stringsAsFactors = FALSE)
    
    # Setting column names
    names(data) <- c("Timestamp", "Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
    
    # Convert Timestamp from UTC to Eastern Time
    data <- data %>%
      mutate(Timestamp = ymd_hms(Timestamp, tz = "UTC"), # Parse as UTC
             Timestamp = with_tz(Timestamp, "America/New_York")) # Convert to Eastern Time  
    
    # if (any(is.na(data$Timestamp))) {
    #   stop("Timestamp conversion failed. Check the format.")
    # }

    
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
      
      renderPlot({
        if (plot %in% c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")) {
          # Calculate the average of the y-values
          avg_y <- mean(data[[plot]], na.rm = TRUE)
          
          # Determine the range values based on the selected input
          if (plot == "Score") {
            range_start <- 80
            range_end <- 100
            bad_range_start <- 0
            bad_range_end <- 60
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(data[[plot]], na.rm = TRUE), 50)
            y_limit_upper <- max(max(data[[plot]], na.rm = TRUE), 100)
          } 
          else if (plot == "Temp") {
            range_start <- 66.2
            range_end <- 73.4
            bad_range_start <- 64.4
            bad_range_end <- 77
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(data[[plot]], na.rm = TRUE), 59)
            y_limit_upper <- max(max(data[[plot]], na.rm = TRUE), 85)
          }
          else if (plot == "Humid") {
            range_start <- 40
            range_end <- 50
            bad_range_start <- 35
            bad_range_end <- 60
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(data[[plot]], na.rm = TRUE), 20)
            y_limit_upper <- max(max(data[[plot]], na.rm = TRUE), 35)
          }
          else if (plot == "co2") {
            range_start <- 0
            range_end <- 600
            bad_range_start <- 1000
            bad_range_end <- 1300
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(data[[plot]], na.rm = TRUE), 400)
            y_limit_upper <- max(max(data[[plot]], na.rm = TRUE), 1000)
          }
          else if (plot == "voc") {
            range_start <- 0
            range_end <- 400
            bad_range_start <- 1000
            bad_range_end <- 2000
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(data[[plot]], na.rm = TRUE), 0)
            y_limit_upper <- max(max(data[[plot]], na.rm = TRUE), 1000)
          }
          else if (plot == "pm25") {
            range_start <- 0
            range_end <- 15
            bad_range_start <- 35
            bad_range_end <- 45
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(data[[plot]], na.rm = TRUE), 0)
            y_limit_upper <- max(max(data[[plot]], na.rm = TRUE), 35)
          }
          else if (plot == "noise") {
            range_start <- 0
            range_end <- 45
            bad_range_start <- 85
            bad_range_end <- 200
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(data[[plot]], na.rm = TRUE), 45)
            y_limit_upper <- max(max(data[[plot]], na.rm = TRUE), 85)
          }
          else if (plot == "light") {
            range_start <- 300
            range_end <- 500
            bad_range_start <- 100
            bad_range_end <- 600
            # Set y-axis limits around the central part of the data
            y_limit_lower <- min(min(data[[plot]], na.rm = TRUE), 100)
            y_limit_upper <- max(max(data[[plot]], na.rm = TRUE), 400)
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
          p <- ggplot(data, aes_string(x="Timestamp", y=plot)) +
            geom_point(size = 2) +
            geom_hline(yintercept = avg_y, color = "blue", linetype = "dashed") +
            geom_hline(yintercept = range_start, color = "green", linetype = "dashed") +
            geom_hline(yintercept = range_end, color = "green", linetype = "dashed") +
            geom_hline(yintercept = bad_range_start, color = "red", linetype = "dashed") +
            geom_hline(yintercept = bad_range_end, color = "red", linetype = "dashed") +
            labs(title=paste(plot, "Over Time"), x="Timestamp", y=plot) +
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
  
  observeEvent(input$dateInput_AK116, {
    updateUI_AK116()
  })
  
  observeEvent(input$plot_AK116, {
    updateUI_AK116()
  })
  
  updateUI_AK116 <- function() {
    output$AK116_ui <- renderUI({
      generateRoomUI("Atwater Kent Laboratories - Room 116",
                     "AK116",
                     AK116_data_reactive(),
                     AK116_data,
                     input$dateInput_AK116,
                     input$plot_AK116)
    })
  }
  
  observeEvent(input$dateInput_AK233, {
    updateUI_AK233()
  })
  
  observeEvent(input$plot_AK233, {
    updateUI_AK233()
  })
  
  updateUI_AK233 <- function() {
    output$AK233_ui <- renderUI({
      generateRoomUI("Atwater Kent Laboratories - Room 233",
                     "AK233",
                     AK233_data_reactive(),
                     AK233_data,
                     input$dateInput_AK233,
                     input$plot_AK233)
    })
  }

  observeEvent(input$dateInput_OH107, {
    updateUI_OH107()
  })
  
  observeEvent(input$plot_OH107, {
    updateUI_OH107()
  })
  
updateUI_OH107 <- function() {
    output$OH107_ui <- renderUI({
      generateRoomUI("Olin Hall - Room 107",
                     "OH107",
                     OH107_data_reactive(),
                     OH107_data,
                     input$dateInput_OH107,
                     input$plot_OH107)
    })
} 


observeEvent(input$dateInput_OH109, {
  updateUI_OH109()
})

observeEvent(input$plot_OH109, {
  updateUI_OH109()
})

updateUI_OH109 <- function() {
  output$OH109_ui <- renderUI({
    generateRoomUI("Olin Hall - Room 109",
                   "OH109",
                   OH109_data_reactive(),
                   OH109_data,
                   input$dateInput_OH109,
                   input$plot_OH109)
  })
}

observeEvent(input$dateInput_UH520, {
  updateUI_UH520()
})

observeEvent(input$plot_UH520, {
  updateUI_UH520()
})
updateUI_UH520 <- function() {
  output$UH520_ui <- renderUI({
    generateRoomUI("Unity Hall - Room 520",
                   "UH520",
                   UH520_data_reactive(),
                   UH520_data,
                   input$dateInput_UH520,
                   input$plot_UH520)
  })
}

observeEvent(input$dateInput_UH500, {
  updateUI_UH500()
})

observeEvent(input$plot_UH500, {
  updateUI_UH500()
})
updateUI_UH500 <- function() {
  output$UH500_ui <- renderUI({
    generateRoomUI("Unity Hall - Room 500",
                   "UH500",
                   UH500_data_reactive(),
                   UH500_data,
                   input$dateInput_UH500,
                   input$plot_UH500)
  })
}


observeEvent(input$dateInput_SL105, {
  updateUI_SL105()
})

observeEvent(input$plot_SL105, {
  updateUI_SL105()
})
updateUI_SL105 <- function() {
  output$SL105_ui <- renderUI({
    generateRoomUI("Salisbury Laboratories - Room 105",
                   "SL105",
                   SL105_data_reactive(),
                   SL105_data,
                   input$dateInput_SL105,
                   input$plot_SL105)
  })
}
observeEvent(input$dateInput_SL104, {
  updateUI_SL104()
})

observeEvent(input$plot_SL104, {
  updateUI_SL104()
})
updateUI_SL104 <- function() {
  output$SL104_ui <- renderUI({
    generateRoomUI("Salisbury Laboratories - Room 104",
                   "SL104",
                   SL104_data_reactive(),
                   SL104_data,
                   input$dateInput_SL104,
                   input$plot_SL104)
  })
}

observeEvent(input$dateInput_FLPL, {
  updateUI_FLPL()
})

observeEvent(input$plot_FLPL, {
  updateUI_FLPL()
})
updateUI_FLPL <- function() {
  output$phLower_ui <- renderUI({
    generateRoomUI("Fuller Labs - PH-Lower",
                   "FLPL",
                   phLower_data_reactive(),
                   FLPL_data,
                   input$dateInput_FLPL,
                   input$plot_FLPL)
  })
}

observeEvent(input$dateInput_FLPU, {
  updateUI_FLPL()
})

observeEvent(input$plot_FLPU, {
  updateUI_FLPU()
})
updateUI_FLPU <- function() {
  output$phUpper_ui <- renderUI({
    generateRoomUI("Fuller Labs - PH-Upper",
                   "FLPU",
                   phUpper_data_reactive(),
                   FLPU_data,
                   input$dateInput_FLPU,
                   input$plot_FLPU)
  })
}
}