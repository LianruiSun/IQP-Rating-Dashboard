library(dplyr)
library(lubridate)

# Function to process data for a single classroom
process_classroom_data <- function(file_path) {
  data <- read.csv(file_path)
  data$timestamp <- ymd_hms(data$timestamp)
  
  # Calculate unoccupied standard from 1AM to 5AM
  unoccupied_standard <- data %>%
    filter(hour(timestamp) >= 1 & hour(timestamp) <= 5) %>%
    summarise(average_noise = mean(noise, na.rm = TRUE),
              average_co2 = mean(co2, na.rm = TRUE))
  
  # Filter data based on noise and CO2 exceeding the unoccupied standards,
  # and consider only school hours from 8AM to 7PM
  data_filtered <- data %>%
    filter(hour(timestamp) >= 8 & hour(timestamp) <= 19) %>%
    filter(noise > unoccupied_standard$average_noise | co2 > unoccupied_standard$average_co2)
  
  # Remove the timestamp column before returning the data
  data_filtered <- select(data_filtered, -timestamp)
  
  return(data_filtered)
}

# Base path and file names
base_path <- "www/data/"
file_names <- c("AK116_16023.csv", "AK233_16429.csv", "FLPL_16130.csv", 
                "FLPU_15681.csv", "OH107_16145.csv", "OH109_15820.csv", 
                "SL104_15921.csv", "SL105_16478.csv", "UH500_16586.csv", 
                "UH520_16280.csv")

# Loop over each file name, process it
for (file_name in file_names) {
  file_path <- paste0(base_path, file_name)
  classroom_data <- process_classroom_data(file_path)
  
  # Save the filtered data, which excludes the timestamp column
  output_file_path <- paste0("www/data/processed/processed_", file_name)
  write.csv(classroom_data, output_file_path, row.names = FALSE)
}

#-----------------------------------------------------------------------------------------------------
#plot

library(ggplot2)
library(dplyr)

# Function to create and save a box plot for a given variable, including the mean and all data points
create_and_save_box_plot <- function(data, variable_name, y_label, file_path) {
  plot <- ggplot(data, aes(x = Dataset, y = get(variable_name), fill = Dataset)) +
    geom_boxplot(width = 0.75, outlier.shape = NA) + # Hide default outliers
    geom_jitter(width = 0.2, size = 1, alpha = 0.05) + # Add jittered points
    stat_summary(fun = mean, geom = "point", shape = 20, size = 3, color = "red") + # Add mean
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12)) +
    labs(title = paste("Box Plot of", y_label, "Across Datasets"), y = y_label, x = "Dataset") +
    theme_light() +
    theme(legend.position = "none")
  
  # Save the plot
  ggsave(file_path, plot, width = 10, height = 6)
}

# Specify the directory to save plots
plot_save_dir <- "www/plots/processed/"

# Ensure the directory exists
if (!dir.exists(plot_save_dir)) {
  dir.create(plot_save_dir, recursive = TRUE)
}

# Base path and file names for processed data
base_path <- "www/data/processed/"
file_names <- c("processed_AK116_16023.csv", "processed_AK233_16429.csv", "processed_FLPL_16130.csv",
                "processed_FLPU_15681.csv", "processed_OH107_16145.csv", "processed_OH109_15820.csv",
                "processed_SL104_15921.csv", "processed_SL105_16478.csv", "processed_UH500_16586.csv",
                "processed_UH520_16280.csv")

# Variables to plot
variables_to_plot <- c("temp..F.", "humid", "co2", "voc", "pm25", "noise", "light")

# Loop over each variable to create and save a box plot as an image
for (variable in variables_to_plot) {
  combined_data <- data.frame(Value = numeric(), Dataset = factor())
  
  for (file_name in file_names) {
    file_path <- paste0(base_path, file_name)
    if(file.exists(file_path)) { # Check if the file exists
      var_data <- read.csv(file_path)[[variable]]
      # Extract dataset name by removing the file extension and any prefix like 'processed_'
      dataset_name <- gsub("processed_", "", file_name)
      dataset_name <- gsub(".csv", "", dataset_name)
      # Append data with dataset name
      combined_data <- rbind(combined_data, data.frame(Value = var_data, Dataset = factor(dataset_name)))
    }
  }
  
  # Proceed if data has been loaded
  if(nrow(combined_data) > 0) {
    colnames(combined_data)[1] <- variable # Use actual variable name
    # Generate a valid filename for the plot
    plot_file_name <- gsub("\\.\\.", "_", gsub("[^A-Za-z0-9]", "_", variable))
    plot_file_path <- paste0(plot_save_dir, plot_file_name, ".png")
    
    # Create and save the box plot
    create_and_save_box_plot(combined_data, variable, gsub("\\.\\.", " ", gsub("_", " ", variable)), plot_file_path)
  }
}


