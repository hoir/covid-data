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
  modules::import(tidyselect)
  modules::import(RcppRoll)
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
      sheetNames <- openxlsx::getSheetNames(.f)
      cityTownSheet <- sheetNames %.>%
        detect(., ~ str_detect(.x, "(?i)city_town"))
      dt <- str_extract(.f, "\\d{4}-\\d{2}-\\d{2}") %.>%
        lubridate::ymd
      out <- readWorkbook(.f, na.strings = "*", sheet = cityTownSheet) %.>%
        set_names(., to_snake_case) %.>%
        .rename_maybe %.>%
        mutate(., date = dt)
      out %.>%
        mutate(., across(where(is.numeric), as.character))
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

read_ma_daily_tests <- function(.dir = here("./data-raw//ma-daily/2020-08-14/")) {
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
           positiveCasesViralIncrease = new_positive_cases) %.>%
    mutate(., positiveCasesViral = positiveCasesViral + positiveCasesViralIncrease)
}

read_ct <- function(fpath){
  read_csv(fpath, col_type = cols(date = col_character())) %.>%
    mutate(., across(date, ymd))
}

add_diff <- function(df, var, .lag = 1L, suffix = "Increase"){
  var_expr <- enexpr(var)
  var_chr <- eval_select(var_expr, df, strict = FALSE) %.>%
    names
  if (is_empty(var_chr)) return(df)
  newVarChr <- paste0(var_chr, suffix)
  if (newVarChr %in% names(df)) {
    warn(paste0("Column `", newVarChr, "` already exists"))
    return(df)
  }
  df %.>%
    mutate(., !!newVarChr := !!var_expr - lag(!!var_expr, !!.lag))
}

add_diffs <- function(df, ...){
  v_exprs <- enexprs(...)
  reduce(v_exprs, ~ add_diff(.x, !!.y), .init = df)
}

add_diffs_default <- function(df) {
  df <- df %.>% arrange(., date)
  add_diffs(df, deathConfirmed, totalTestsViral,
            positiveCasesViral)
}

add_rolling <- function(df){
  .vars <- exprs(positiveIncrease,
                 positiveCasesViralIncrease,
                 deathIncrease,
                 inIcuCurrently,
                 onVentilatorCurrently,
                 deathConfirmedIncrease)
  .vars_existing_chr <- eval_select(expr(c(!!!.vars)), df, strict = FALSE) %.>%
    names
  .idx <- .vars %.>% as.character %.>% match(.vars_existing_chr, .)
  .vars_existing <- .vars[.idx]
  df <- df %.>%
    arrange(., date)
  .new_cols <- df %.>% select(., !!!.vars_existing) %.>%
    mutate(., across(everything(), ~ roll_meanr(.x, 7L))) %.>%
    set_names(., ~ paste0(.x, "7d"))
  bind_cols(df, .new_cols)
}

.pct_chg <- function(x, .lag = 7L) {
  y1 <- log(x)
  y0 <- lag(y1, n = .lag)
  exp(y1 - y0) - 1
}

add_delta7d <- function(df) {
  .vars_chr <- eval_select(quote(c(ends_with("7d"))), df, strict = FALSE) %.>%
    names
  .newNames <- .vars_chr %.>%
    to_upper_camel_case %.>%
    paste0("d", .) %.>%
    str_replace(., "7D$", "7d")
  .newNames <- .vars_chr := .newNames
  delta_df <- df %.>%
    select(., group_cols(), date, !!!syms(.vars_chr)) %.>%
    arrange(., date) %.>%
    mutate(., across(c(!!!syms(.vars_chr)), .pct_chg)) %.>%
    set_names(., ~ .newNames[.x] %?% .x)
  df %.>%
    left_join(., delta_df)
}

add_vars_all <- function(df){
  df %.>%
    add_diffs_default %.>%
    add_rolling %.>%
    add_delta7d
}
