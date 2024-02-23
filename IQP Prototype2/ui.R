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
      menuItem("Fuller Labs PH-Upper", tabName = "FLPU")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "AK116", uiOutput("AK116_score")),
      tabItem(tabName = "AK233", uiOutput("AK233_score")),
      tabItem(tabName = "OH107", uiOutput("OH107_score")),
      tabItem(tabName = "OH109", uiOutput("OH109_score"), ),
      tabItem(tabName = "UH520", uiOutput("UH520_score")),
      tabItem(tabName = "UH500", uiOutput("UH500_score")),
      tabItem(tabName = "SL105", uiOutput("SL105_score")),
      tabItem(tabName = "SL104", uiOutput("SL104_score")),
      tabItem(tabName = "FLPL", uiOutput("phLower_score")),
      tabItem(tabName = "FLPU", uiOutput("phUpper_score"))
    ),
    
  )
)
