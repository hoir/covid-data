suppressPackageStartupMessages({
  modules::import(data.table)
  modules::import(tidyselect)
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
  modules::import(lubridate)
})

.rename_maybe <- function(df){
  .renames <- exprs(two_week_case_count = case_count_last_14_days,
                    total_tests = total_tested,
                    total_tested_last_14_days = total_tests_last_14_days,
                    relative_change_in_case_count = change,
                    positive_tests_last_14_days = total_positive_tests_last_14_days,
                    percent_positivity = percent_positivity_last_14_days)
  .renames_chr <- as.character(.renames)
  .idx <- .renames_chr %.>%
    intersect(., names(df)) %.>%
    match(., .renames_chr)
  .renames <- .renames[.idx]
  df %.>%
    rename(., !!!.renames)
}

read_ma_cities <- function(){
  files <- fs::dir_ls(path = here("./data-raw/ma-weekly"), glob = "*.xlsx", type = "f", recurse = TRUE)
  dl <- files %.>%
    map(., function(.f){
      filename <- fs::path_file(.f) %.>%
        fs::path_ext_remove
      dt <- str_extract(.f, "\\d{4}-\\d{2}-\\d{2}") %.>%
        lubridate::ymd
      out <- readWorkbook(.f, na.strings = "*", sheet = "City_Town_Data") %.>%
        set_names(., to_snake_case) %.>%
        .rename_maybe %.>%
        mutate(., date = dt)
    })
  dl %.>%
    bind_rows %.>%
    as_tibble
}

read_ma_daily <- function(.dir = here("./data-raw//ma-daily/2020-08-12/")){
  fs::path_join(c(.dir, "CasesByDate.csv")) %.>%
    read_csv %.>%
    set_names(., to_snake_case) %.>%
    mutate(., across(date, lubridate::mdy))
}

read_ma_daily_tests <- function(.dir = here("./data-raw//ma-daily/2020-08-13/")) {
  file.path(.dir, "TestingByDate.csv") %.>%
    read_csv %.>%
    set_names(., to_snake_case) %.>%
    mutate(., across(date, mdy))
}

read_cambridge_daily <- function(fpath = here("./data-raw/cambridge/daily.csv")) {
  read_csv(fpath) %.>%
    set_names(., to_snake_case) %.>%
    mutate(., across(date, mdy)) %.>%
    rename(., positiveCasesViral = cumulative_positive_cases,
           positiveCasesViralIncrease = new_positive_cases)
}
