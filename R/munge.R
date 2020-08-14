suppressPackageStartupMessages({
  modules::import(data.table)
  modules::import(tibble)
  modules::import(purrr)
  modules::import(rlang)
  modules::import(dplyr)
  modules::import(tidyr)
  modules::import(stringr)
  modules::import(wrapr)
  modules::import(openxlsx)
  modules::import(snakecase)
  modules::import(here, here)
  modules::import(readr)
})

read_ma_weekly <- function(){
  files <- fs::dir_ls(path = here("./data-raw/ma-weekly"), glob = "*.xlsx", type = "f", recurse = TRUE)
  files %.>%
    map(., function(.f){
      filename <- fs::path_file(.f) %.>%
        fs::path_ext_remove
      dt <- str_extract(.f, "\\d{4}-\\d{2}-\\d{2}") %.>%
        lubridate::ymd
      out <- readWorkbook(.f, na.strings = "*") %.>%
        set_names(., to_snake_case) %.>%
        mutate(., dt = dt)
    }) %.>%
    bind_rows %.>%
    as_tibble
}

read_ma_daily <- function(.dir = here("./data-raw//ma-daily/2020-08-12/")){
  fs::path_join(c(.dir, "CasesByDate.csv")) %.>%
    read_csv %.>%
    set_names(., to_snake_case) %.>%
    mutate(., across(date, lubridate::mdy))
}
