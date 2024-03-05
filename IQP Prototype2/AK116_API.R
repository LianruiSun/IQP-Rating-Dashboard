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
requestAPI

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