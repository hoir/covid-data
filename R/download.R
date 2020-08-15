suppressPackageStartupMessages({
  modules::import(dplyr)
  modules::import(httr)
  modules::import(lubridate)
  modules::import(wrapr)
  modules::import(stringr)
  modules::import(glue)
})

fetch_ma_weekly <- function(dt = floor_date(today(), unit = "week", week_start = 3)){
  .date_tag <- dt %.>%
    format(., "%B-%d-%Y") %.>%
    str_to_lower
  .url <- "https://www.mass.gov/doc/weekly-public-health-report-raw-data-{.date_tag}/download" %.>%
    glue
  GET(.url, write_disk(here::here("./data-raw/ma-weekly/weekly-dashboard-data-{dt}.xlsx" %.>%
                                    glue)))
}

fetch_us_daily <- function(outfile = here::here("./data-raw/covidtracking/us/daily.csv"),
                           overwrite = FALSE){
  GET("https://api.covidtracking.com/v1/us/daily.csv",
      write_disk(outfile, overwrite = overwrite))
}

fetch_ct <- function(urlpath, outfile, overwrite = FALSE){
  # fetch from covidtracking
  urlbase <- "https://api.covidtracking.com/v1/"
  .url <- paste0(urlbase, urlpath)
  GET(.url, write_disk(outfile, overwrite = overwrite))
}

fetch_cambridge_data <- function(outfile = here::here("./data-raw/cambridge/daily.csv"),
                                 overwrite = FALSE) {
  .url <- "https://data.cambridgema.gov/api/views/tdt9-vq5y/rows.csv?accessType=DOWNLOAD"
  GET(.url, write_disk(outfile, overwrite = overwrite))
}
