library(drake)
library(tidyverse)
library(wrapr)

modules::expose("R/download.R")
modules::expose("R/munge.R")

plan <- drake_plan(
  us_daily_raw = fetch_us_daily(
    outfile = file_out("data-raw/covidtracking/us/daily.csv"),
    overwrite = TRUE),
  ma_daily_raw = fetch_ct(
    "states/ma/daily.csv",
    outfile = file_out("data-raw/covidtracking/states/ma/daily.csv"),
    overwrite = TRUE),
  cambridge_daily_raw = fetch_cambridge_data(
    outfile = file_out("data-raw/cambridge/daily.csv"),
    overwrite = TRUE),
  us_daily = read_ct(file_in("data-raw/covidtracking/us/daily.csv")) %.>%
    add_vars_all %.>%
    write_csv(., file_out("data/us/daily.csv")),
  ma_daily = read_ct(file_in("data-raw/covidtracking/states/ma/daily.csv")) %.>%
    add_vars_all %.>%
    write_csv(., file_out("data/states/ma/daily.csv")),
  cambridge_data = read_cambridge_daily(
    file_in("./data-raw/cambridge/daily.csv")) %.>%
    add_vars_all %.>%
    write_csv(., file_out("data/cities/cambridge/daily.csv"))
)

drake_config(plan, verbose = 2)
