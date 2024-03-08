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
plot_save_dir <- "www/plots/"
# plot_save_dir <- "www/plots/processed/"

# Ensure the directory exists
if (!dir.exists(plot_save_dir)) {
  dir.create(plot_save_dir, recursive = TRUE)
}

# Base path and file names
base_path <- "www/data/"
file_names <- c("AK116_16023.csv", "AK233_16429.csv", "FLPL_16130.csv",
                "FLPU_15681.csv", "OH107_16145.csv", "OH109_15820.csv",
                "SL104_15921.csv", "SL105_16478.csv", "UH500_16586.csv",
                "UH520_16280.csv")

# file_names <- c("processed/processed_AK116_16023.csv", "processed/processed_AK233_16429.csv", "processed/processed_FLPL_16130.csv",
#                 "processed/processed_FLPU_15681.csv", "processed/processed_OH107_16145.csv", "processed/processed_OH109_15820.csv",
#                 "processed/processed_SL104_15921.csv", "processed/processed_SL105_16478.csv", "processed/processed_UH500_16586.csv",
#                 "processed/processed_UH520_16280.csv")

# Variables to plot
variables_to_plot <- c("temp..F.", "humid", "co2", "voc", "pm25", "noise", "light")

# Loop over each variable to create and save a box plot as an image
for (variable in variables_to_plot) {
  combined_data <- data.frame(Value = numeric(), Dataset = factor())
  
  for (file_name in file_names) {
    file_path <- paste0(base_path, file_name)
    var_data <- read.csv(file_path)[[variable]]
    dataset_name <- sub("_.+\\.csv$", "", file_name)
    combined_data <- rbind(combined_data, data.frame(Value = var_data, Dataset = factor(dataset_name)))
  }
  
  colnames(combined_data)[1] <- "Variable"
  
  # Define the file path for the plot image
  plot_file_path <- paste0(plot_save_dir, variable, ".png")
  
  # Create and save the box plot
  create_and_save_box_plot(combined_data, "Variable", gsub("\\.\\.", " ", gsub("_", " ", variable)), plot_file_path)
}






