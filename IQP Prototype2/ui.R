library(shinydashboard, warn.conflicts = FALSE)

# UI definition using dashboardPage
ui <- dashboardPage(
  dashboardHeader(
    title = tags$a(href = "https://www.wpi.edu/", 
                   tags$img(
                     src = "WPI_Inst_Prim_FulClr_PREVIEW.png",
                     height = "50px",
                     width = "auto"
                   )
    )
  ),
  
  dashboardSidebar(
    tags$head(
      tags$style(HTML("
        .skin-blue .sidebar-menu>li.active>a, .skin-blue .sidebar-menu>li:hover>a {
          color: #fff;
          background: #1e282c;
          border-left-color: #AC2B37;
        }
        .skin-blue .main-sidebar .sidebar .sidebar-menu a {
          background-color: #34383B;
          color: #ffffff;
        }
        .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover {
          background-color: #AC2B37;
          color: #ffffff;
        }
        .skin-blue .main-sidebar .sidebar .sidebar-menu .active a {
          background-color: #A9B0B7;
        }
      ")),
      tags$style(HTML("
        .skin-blue .main-header .navbar {background-color: #AC2B37 !important;}
        .skin-blue .main-header .logo {background-color: #AC2B37 !important;}
        .skin-blue .main-header .logo:hover {background-color: #AC2B37;}
        .skin-blue .main-header .navbar .sidebar-toggle:hover {
          background-color: #ffffff;
          color: #AC2B37;
        }
      "))
    ),
    sidebarMenu(
      menuItem("Atwater Kent Laboratories 116", tabName = "AK116"),
      menuItem("Atwater Kent Laboratories 233", tabName = "AK233"),
      menuItem("Olin Hall 107", tabName = "OH107"),
      menuItem("Olin Hall 109", tabName = "OH109"),
      menuItem("Unity Hall 520", tabName = "UH520"),
      menuItem("Unity Hall 500", tabName = "UH500"),
      menuItem("Salisbury Laboratories 105", tabName = "SL105"),
      menuItem("Salisbury Laboratories 104", tabName = "SL104"),
      menuItem("Fuller Labs PH-Lower", tabName = "FLPL"),
      menuItem("Fuller Labs PH-Upper", tabName = "FLPU"),
      menuItem("Analysis", tabName = "analysis")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "AK116",
              dateInput("dateInput_AK116", "Choose a date:", value = Sys.Date()),
              selectInput(
                "plot_AK116",
                "Plot choose",
                choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light"),
                selected = "Score"
              ),
              uiOutput("AK116_ui")),
      tabItem(tabName = "AK233",
              dateInput("dateInput_AK233", "Choose a date:", value = Sys.Date()),
              selectInput(
                "plot_AK233",
                "Plot choose",
                choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
              ),
              uiOutput("AK233_ui")),
      tabItem(tabName = "OH107",
              dateInput("dateInput_OH107", "Choose a date:", value = Sys.Date()),
              selectInput(
                "plot_OH107",
                "Plot choose",
                choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
              ),
              uiOutput("OH107_ui")),
      tabItem(tabName = "OH109",
              dateInput("dateInput_OH109", "Choose a date:", value = Sys.Date()),
              selectInput(
                "plot_OH109",
                "Plot choose",
                choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
              ),
              uiOutput("OH109_ui")),
      tabItem(tabName = "UH520",
              dateInput("dateInput_UH520", "Choose a date:", value = Sys.Date()),
              selectInput(
                "plot_UH520",
                "Plot choose",
                choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
              ),
              uiOutput("UH520_ui")),
      tabItem(tabName = "UH500",
              dateInput("dateInput_UH500", "Choose a date:", value = Sys.Date()),
              selectInput(
                "plot_UH500",
                "Plot choose",
                choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
              ),
              uiOutput("UH500_ui")),
      tabItem(tabName = "SL105",
              dateInput("dateInput_SL105", "Choose a date:", value = Sys.Date()),
              selectInput(
                "plot_SL105",
                "Plot choose",
                choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
              ),
              uiOutput("SL105_ui")),
      tabItem(tabName = "SL104",
              dateInput("dateInput_SL104", "Choose a date:", value = Sys.Date()),
              selectInput(
                "plot_SL104",
                "Plot choose",
                choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
              ),
              uiOutput("SL104_ui")),
      tabItem(tabName = "FLPL",
              dateInput("dateInput_FLPL", "Choose a date:", value = Sys.Date()),
              selectInput(
                "plot_FLPL",
                "Plot choose",
                choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
              ),
              uiOutput("phLower_ui")),
      tabItem(tabName = "FLPU",
              dateInput("dateInput_FLPU", "Choose a date:", value = Sys.Date()),
              selectInput(
                "plot_FLPU",
                "Plot choose",
                choices = c("Score", "Temp", "Humid", "co2", "voc", "pm25", "noise", "light")
              ),
              uiOutput("phUpper_ui")),
      tabItem(tabName = "analysis",
              fluidRow(
                lapply(c("temp..F.", "humid", "co2", "voc", "pm25", "noise", "light"), function(variable) {
                  column(12,
                         img(src = paste0("plots/", variable, ".png"), style = "width:100%;")
                  )
                })
              )
      )
    )
  )
  )
