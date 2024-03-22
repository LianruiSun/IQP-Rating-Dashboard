# Load necessary libraries
library(ggplot2)

# Define the base path where the CSV files are located
base_path <- "www/data/processed/"
plot_path <- "www/plots/pie/"

# Define the file names
file_names <- c("processed_AK116_16023.csv", "processed_AK233_16429.csv", "processed_FLPL_16130.csv", 
                "processed_FLPU_15681.csv", "processed_OH107_16145.csv", "processed_OH109_15820.csv", 
                "processed_SL104_15921.csv", "processed_SL105_16478.csv", "processed_UH500_16586.csv", 
                "processed_UH520_16280.csv")

# Function to read data, create and save pie chart
create_pie_chart <- function(file_name) {
  file_path <- paste0(base_path, file_name)
  data <- read.csv(file_path)
  
  # Categorize temperature into three categories
  data$temp_category <- ifelse(data$humid < 30, "Below 30%",
                               ifelse(data$humid <= 60, "Between 30% and 60%", "Above 60%"))
  
  # Calculate counts for each category
  category_counts <- table(data$temp_category)
  
  # Calculate percentages
  category_percentages <- round(100 * category_counts / sum(category_counts), 1)
  
  # Labels with percentages
  labels_with_percentages <- paste(names(category_counts), "\n", category_percentages, "%", sep="")
  
  # Define colors for each category
  colors <- c("Below 30%" = "green", "Between 30% and 60%" = "blue", "Above 60%" = "red")
  
  # Create pie chart
  pie(category_counts, labels = labels_with_percentages,
      col = colors[names(category_counts)], main = paste("Humidity Distribution for", gsub("processed_", "", file_name)))
  
  # Save the pie chart as PNG
  png_filename <- paste0(plot_path, "humidity_distribution_pie_chart_", gsub("processed_", "", file_name), ".png")
  png(file = png_filename)
  pie(category_counts, labels = labels_with_percentages,
      col = colors[names(category_counts)], main = paste("Humidity Distribution for", gsub("processed_", "", file_name)))
  dev.off()
}

# Apply the function to each file
lapply(file_names, create_pie_chart)

#---------------------------------------------

# Load necessary libraries
library(ggplot2)

# Define the base path where the CSV files are located
base_path <- "www/data/processed/"
plot_path <- "www/plots/pie/"

# Define the file names
file_names <- c("processed_AK116_16023.csv", "processed_AK233_16429.csv", "processed_FLPL_16130.csv", 
                "processed_FLPU_15681.csv", "processed_OH107_16145.csv", "processed_OH109_15820.csv", 
                "processed_SL104_15921.csv", "processed_SL105_16478.csv", "processed_UH500_16586.csv", 
                "processed_UH520_16280.csv")

# Function to read data, create and save pie chart
create_pie_chart <- function(file_name) {
  file_path <- paste0(base_path, file_name)
  data <- read.csv(file_path)
  data$temp_category <- ifelse(data$temp..F. >= 68 & data$temp..F. <= 75.2, "Between 68°F and 75.2°F", "Out of Range")
  
  # Calculate counts for each category
  category_counts <- table(data$temp_category)
  
  # Calculate percentages
  category_percentages <- round(100 * category_counts / sum(category_counts), 1)
  
  # Labels with percentages
  labels_with_percentages <- paste(names(category_counts), "\n", category_percentages, "%", sep="")
  
  # Create pie chart
  pie(category_counts, labels = labels_with_percentages,
      col = c("blue", "red"), main = paste("Temperature Distribution for", gsub(".csv", "", file_name)))
  
  # Save the pie chart as PNG
  png_filename <- paste0(plot_path, "temperature_distribution_pie_chart_", gsub(".csv", "", file_name), ".png")
  png(file = png_filename)
  pie(category_counts, labels = labels_with_percentages,
      col = c("blue", "red"), main = paste("Temperature Distribution for", gsub(".csv", "", file_name)))
  dev.off()
}

# Apply the function to each file
lapply(file_names, create_pie_chart)




