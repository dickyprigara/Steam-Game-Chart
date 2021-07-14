library(shiny)
library(shinydashboard)
# Define UI for application that draws a histogram

shinyUI(
    
    dashboardPage(skin = "black",
                  dashboardHeader(title = "Game Dashboard"),
                  dashboardSidebar(
                      sidebarMenu(
                          menuItem(" Overview", tabName = "menu1", icon = icon("steam")),
                          menuItem("Data", tabName = "menu2", icon = icon("database")),
                          menuItem("Peak to Peak",tabName = "menu3", icon = icon("poll"))
                          # menuItem("Event Sale", tabName = "menu4", icon = icon("steam"))
                      )
                  ),
                  dashboardBody(
                      tabItems(
                          tabItem(tabName = "menu1",
                                  fluidRow(
                                    box(
                                      selectInput(inputId = "yearchoice",
                                                  label = "Year",
                                                  choices = unique(games_clean$year),
                                                  selected = 2020)
                                    ),
                                      valueBox(
                                          value = games_clean$gamename %>%
                                              unique() %>%
                                              length(),
                                          subtitle = "Total of Game",
                                          icon =icon("gamepad"),
                                          color = "orange"
                                      )
                                  ),
                                  
                                  fluidRow(
                                      box(
                                          plotlyOutput("visual1")
                                      ),
                                      box(
                                          plotlyOutput("visual2")
                                      )
                                  )
                          ),
                          tabItem(tabName = "menu2",
                                  h2("Data Games"),
                                  fluidRow(
                                      box(width = 12,
                                          dataTableOutput(outputId = "data"))
                                  )
                          ),
                          tabItem(tabName = "menu3",
                                  fluidRow(
                                      box(
                                          selectInput(inputId = "game1",
                                                      label = "Input Game",
                                                      choices = unique(games_clean$gamename),
                                                      multiple = T,
                                                      selected=c("Dota 2", "Counter-Strike: Global Offensive","PLAYERUNKNOWN'S BATTLEGROUNDS","Grand Theft Auto V","Tom Clancy's Rainbow Six Siege","Team Fortress 2")

                                          )
                                      )
                                      # ,
                                      # box(
                                      #   dateRangeInput(inputId = "test",
                                      #                  label = "input date",
                                      #                  start = "2012-07-01",
                                      #                  end = "2021-02-28")
                                      # )
                                      ,
                                      box(
                                        sliderInput(inputId = "slide",
                                                      label = "choose year",
                                                      min = 2012,
                                                      max = 2021,
                                                      value = 2020))
                                  ),
                                  fluidRow(
                                      box(
                                          plotlyOutput("visual3"),
                                          width = 12
                                      )
                                  ),
                                  fluidRow(
                                    box(
                                      plotlyOutput("visual4"),
                                      width = 12
                          )
                          )
                      #     ,
                      #     tabItem(tabName = "menu4",
                      #              fluidRow(
                      #                box(selectInput(inputId = "game2",
                      #                                label = "Input Game",
                      #                                choices = unique(games_clean$gamename),
                      #                                 multiple = T
                      #                                )
                      #                )
                      #                ,
                      #              #     checkboxGroupInput(
                      #              #       inputId = "cek",
                      #              #       label = "Check the Event",
                      #              #       choices = unique(games_clean$sale[games_clean$sale!="No Event Sale"])
                      #              #       )
                      #              #     )
                      #              #   
                      #              # ,
                      #              fluidRow(
                      #                box(
                      #                  plotlyOutput("visual4"),
                      #                  width = 12
                      #                  
                      #                )
                      #              ))
                      # )
                  
                  )
    )

)
)
)
