library(httr)
library(jsonlite)

# Api connection
headers = c('x-api-key' = '72HcOTWS4tjEVpsFkYPBu8bmXZbnM53F')
omni_experiment <- VERB("GET", url = "https://developer-apis.awair.is/v1/orgs/2674/devices/awair-omni/16028/air-data/latest", add_headers(headers))


experiment_data <- content(omni_experiment, "parsed")

# Access the first element of the 'data' list
data_item <- experiment_data$data[[1]]
data_item

# Now you can access each variable like this:
timestamp <- data_item$timestamp
score <- data_item$score
sensors <- data_item$sensors

# For example, to access the temperature:
temp <- sensors[[which(sapply(sensors, function(x) x$comp == "temp"))]]$value
humid <- sensors[[which(sapply(sensors, function(x) x$comp == "humid"))]]$value
co2 <- sensors[[which(sapply(sensors, function(x) x$comp == "co2"))]]$value
voc <- sensors[[which(sapply(sensors, function(x) x$comp == "voc"))]]$value
pm25 <- sensors[[which(sapply(sensors, function(x) x$comp == "pm25"))]]$value
noise <- sensors[[which(sapply(sensors, function(x) x$comp == "spl_a"))]]$value
light <- sensors[[which(sapply(sensors, function(x) x$comp == "lux"))]]$value

AK116_data_real <-
  list(
    score = score,
    rating = 100,
    temp = temp,
    humidity = humid,
    co2 = co2,
    tvocs = voc,
    pm25 = pm25,
    noise = noise,
    light = light,
    building = "Atwater-Kent Laboratories",
    building_hef = "https://hub.wpi.edu/building/3",
    seats = 206,
    computer = 1,
    
    updated = "12/7/2023"
  )
AK233_data_real <-
  list(
    score = 100,
    rating = 100,
    temp = 20,
    humidity = 37,
    co2 = 606,
    tvocs = 307,
    pm25 = 5,
    noise = 49,
    light = 0,
    building = "Atwater-Kent Laboratories",
    building_hef = "https://hub.wpi.edu/building/3",
    seats = 72,
    computer = 1,
    updated = "12/7/2023"
  )
OH107_data_real <-
  list(
    score = 100,
    rating = 100,
    temp = 20,
    humidity = 37,
    co2 = 606,
    tvocs = 307,
    pm25 = 5,
    noise = 49,
    light = 0,
    building = "Olin Hall",
    building_hef = "https://hub.wpi.edu/building/53",
    seats = 202,
    computer = 1,
    updated = "12/7/2023"
  )
OH109_data_real <-
  list(
    score = 100,
    rating = 100,
    temp = 20,
    humidity = 37,
    co2 = 606,
    tvocs = 307,
    pm25 = 5,
    noise = 49,
    light = 0,
    building = "Olin Hall",
    building_hef = "https://hub.wpi.edu/building/53",
    seats = 38,
    computer = 1,
    updated = "12/7/2023"
  )
UH520_data_real <-
  list(
    score = 100,
    rating = 100,
    temp = 20,
    humidity = 37,
    co2 = 606,
    tvocs = 307,
    pm25 = 5,
    noise = 49,
    light = 0,
    building = "Unity Hall",
    building_hef = "https://hub.wpi.edu/building/99",
    seats = 80,
    computer = 1,
    updated = "12/7/2023"
  )
UH500_data_real <-
  list(
    score = 100,
    rating = 100,
    temp = 20,
    humidity = 37,
    co2 = 606,
    tvocs = 307,
    pm25 = 5,
    noise = 49,
    light = 0,
    building = "Unity Hall",
    building_hef = "https://hub.wpi.edu/building/99",
    seats = 120,
    computer = 1,
    updated = "12/7/2023"
  )
SL105_data_real <-
  list(
    score = 100,
    rating = 100,
    temp = 20,
    humidity = 37,
    co2 = 606,
    tvocs = 307,
    pm25 = 5,
    noise = 49,
    light = 0,
    building = "Salisbury Laboratories",
    building_hef = "https://hub.wpi.edu/building/43",
    seats = 54,
    computer = 1,
    updated = "12/7/2023"
  )
SL104_data_real <-
  list(
    score = 100,
    rating = 100,
    temp = 20,
    humidity = 37,
    co2 = 606,
    tvocs = 307,
    pm25 = 5,
    noise = 49,
    light = 0,
    building = "Salisbury Laboratories",
    building_hef = "https://hub.wpi.edu/building/43",
    seats = 72,
    computer = 1,
    updated = "12/7/2023"
  )
phLower_data_real <-
  list(
    score = 100,
    rating = 100,
    temp = 20,
    humidity = 37,
    co2 = 606,
    tvocs = 307,
    pm25 = 5,
    noise = 49,
    light = 0,
    building = "Fuller Laboratories",
    building_hef = "https://hub.wpi.edu/building/2",
    seats = 102,
    computer = 1,
    updated = "12/7/2023"
  )
phUpper_data_real <-
  list(
    score = 100,
    rating = 100,
    temp = 20,
    humidity = 37,
    co2 = 606,
    tvocs = 307,
    pm25 = 5,
    noise = 49,
    light = 0,
    building = "Fuller Laboratories",
    building_hef = "https://hub.wpi.edu/building/2",
    seats = 192,
    computer = 1,
    updated = "12/7/2023"
  )