library(shiny)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(plotly)
library(glue)
library(lubridate)
library(zoo)
library(scales)
options(scipen=1234)
options(shiny.sanitize.errors = TRUE)
safeError(error = "input value")

# tuesdata <- tidytuesdayR::tt_load('2021-03-16')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 12)

games <- read.csv("SteamCharts.csv")

# games <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-16/games.csv')

games_clean <- games %>% 
  mutate_if(is.character, as.factor) %>% 
  mutate(gain=if_else(is.na(gain),0,gain) )
games_clean$year <- as.factor(games_clean$year)
games_clean$yearmonth<- paste(games_clean$year,games_clean$month)
games_clean$yearmonth<- as.yearmon(games_clean$yearmonth, "%Y %b")
games_clean$month<- month(games_clean$yearmonth,label=T)

pw <- function(x){ 
  if(x == "Feb"){
    x <- "Lunar New Year Sale"
  }else if(x == "May"){
    x <- "Spring Sale"
  }else if(x == "Jun"){ 
    x <- "Summer Sale"
  }else if(x == "Oct"){
    x <- "Halloween Sale"
  }else if(x == "Nov"){
    x <- "Black Friday / Autumn Sale"
  }else if(x == "Dec"){
    x <- "Winter Sale"
  }else{
    x <- "No Event Sale"
  }
}

games_clean$sale <- sapply(games_clean$month, pw)
games_clean$sale <- as.factor(games_clean$sale)


