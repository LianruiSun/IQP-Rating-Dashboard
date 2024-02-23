library(shiny)
library(plotly)

# Source UI and Server scripts
source("ui.R")
source("server.R")

# Run the application 
shinyApp(ui = ui, server = server)
