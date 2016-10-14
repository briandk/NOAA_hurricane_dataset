require(hms)
require(magrittr)
require(stringr)
require(tidyverse)

format_time <- function(raw_time) {
  formatted_time <- raw_time %>%
    str_extract(pattern="^\\d\\d") %>%
    hms::hms(
      seconds=0,
      minutes=0,
      hours=.,
      days=0
    )
  return(formatted_time)
}

format_date <- function(raw_date) {
  return( lubridate::ymd(raw_date) )
}

atlantic <- readr::read_csv("Atlantic.csv")
pacific <- readr::read_csv("Pacific.csv")

atlantic %<>% dplyr::mutate(ocean = "atlantic")
pacific %<>% dplyr::mutate(ocean = "pacific")

hurricane_data <- atlantic %>%
  dplyr::bind_rows(pacific) %>%
  mutate(time = format_time(time)) %>%
  mutate(date = format_date(date))

hurricane_data %>% readr::write_csv(path="combined_hurricane_data.csv")
