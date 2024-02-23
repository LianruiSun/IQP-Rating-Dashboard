library(httr)
library(jsonlite)
library(dplyr)


# Api connection
headers = c('x-api-key' = '72HcOTWS4tjEVpsFkYPBu8bmXZbnM53F')
omni_experiment <-
  VERB("GET", url = "https://developer-apis.awair.is/v1/orgs/2674/devices/awair-omni/16280/air-data/raw", add_headers(headers))

json_data <- content(omni_experiment, "text", encoding = "UTF-8")
writeLines(json_data, "data.json")

json_data <- fromJSON("data.json")

requestAPI <- function() {
  headers = c('x-api-key' = '72HcOTWS4tjEVpsFkYPBu8bmXZbnM53F')
  omni_experiment <-
    VERB("GET", url = "https://developer-apis.awair.is/v1/orgs/2674/devices/awair-omni/16280/air-data/raw", add_headers(headers))
  
  json_data <- content(omni_experiment, "text", encoding = "UTF-8")
  writeLines(json_data, "data.json")
  
  json_data <- fromJSON("data.json")
  
  # Schedule the next call of requestAPI in 10 seconds
  later::later(requestAPI, delay = 10)
}

# Extract the latest data
latest_timestamp <- json_data$data$timestamp[1]
date_of_latest_timestamp <- as.Date(latest_timestamp)

# Convert Date object to a string formatted as "YYYY-MM-DD"
date_string <- format(date_of_latest_timestamp, "%Y-%m-%d")

sensor_data <- as.data.frame(json_data$data$sensors[[1]])

latest_temp <- sensor_data$value[sensor_data$comp == "temp"]
latest_humid <- sensor_data$value[sensor_data$comp == "humid"]
latest_co2 <- sensor_data$value[sensor_data$comp == "co2"]
latest_pm10 <- sensor_data$value[sensor_data$comp == "pm10_est"]
latest_pm25 <- sensor_data$value[sensor_data$comp == "pm25"]
latest_score <- sensor_data$value[sensor_data$comp == "score"]
latest_voc <- sensor_data$value[sensor_data$comp == "voc"]
latest_lux <- sensor_data$value[sensor_data$comp == "lux"]
latest_spl <- sensor_data$value[sensor_data$comp == "spl_a"]

json_to_csv <- function(json_data, json_file) {
  json_data <- fromJSON(json_file)
  
  # Initialize an empty vector for temperature values
  temp <- c()
  humid <- c()
  co2 <- c()
  voc <- c()
  pm25 <- c()
  lux <- c()
  spl_a <- c()
  for (i in 1:length(json_data$data$sensors)) {
    sensor_df <- json_data$data$sensors[i][[1]]
    for (j in 1:nrow(sensor_df)) {
      comp <- sensor_df$comp[j]
      value <- sensor_df$value[j]
      if (comp == "temp") {
        temp <- c(temp, value)
      }
      if (comp == "humid") {
        humid <- c(humid, value)
      }
      if (comp == "co2") {
        co2 <- c(co2, value)
      }
      if (comp == "voc") {
        voc <- c(voc, value)
      }
      if (comp == "pm25") {
        pm25 <- c(pm25, value)
      }
      if (comp == "lux") {
        lux <- c(lux, value)
      }
      if (comp == "spl_a") {
        spl_a <- c(spl_a, value)
      }
      # Printing or processing each property
    }
  }

  
  # After collecting data, combine all into one data frame with appropriate column names
  final_data_df <- data.frame(
    timestamp = json_data$data$timestamp[1:length(json_data$data$timestamp)],
    score = json_data$data$score[1:length(json_data$data$score)],
    temp = temp,
    humid = humid,
    co2 = co2,
    voc = voc,
    pm25 = pm25,
    lux = lux,
    spl_a = spl_a
  )
  
  # Create the new CSV file path
  csv_file_path <- paste0("www/AK116_16023.csv")
  
  # Check if CSV file exists to determine whether to write new or append
  if(file.exists(csv_file_path)) {
    # Read existing CSV file
    existing_data <- read.csv(csv_file_path)
    
    # Append new data to existing data
    combined_data <- rbind(existing_data, final_data_df)
    
    # Remove duplicates and sort by timestamp
    combined_data <- combined_data %>%
      distinct(timestamp, .keep_all = TRUE) %>%
      arrange(desc(as.POSIXct(timestamp, format = "%Y-%m-%dT%H:%M:%S")))
    
    # Write combined data back to CSV, without row names
    write.csv(combined_data, csv_file_path, row.names = FALSE)
    message("Data appended to existing CSV file ", "(www/AK116-", date_string, ".csv)")
  } else {
    # CSV file doesn't exist, write new data frame to CSV, without row names
    write.csv(final_data_df, csv_file_path, row.names = FALSE)
    message("New CSV file created with data ", "(www/AK116-", date_string, ".csv)")
  }
  
}

json_to_csv(json_data, "data.json")


AK116_data_real <- list(
  score = latest_score,
  rating = latest_score,
  # Assuming the rating is always 100
  temp = latest_temp,
  humidity = latest_humid,
  co2 = latest_co2,
  tvocs = latest_voc,
  pm25 = latest_pm25,
  noise = latest_spl,
  light = latest_lux,
  building = "Atwater-Kent Laboratories",
  building_hef = "https://hub.wpi.edu/building/3",
  seats = 206,
  computer = 1,
  updated = date_string
)
# 
# # Print the AK116_data_real
# print(AK116_data_real)