## COVID dashboard data for Cambridge area

Data repository for COVID-19 data in Cambridge, MA area. Raw files from original
sources (listed below) are in the `data-raw/` directory. Scripts and processed
data in the roadmap.

## Processed data

Processed data is in the `data/` directory. Preliminary plan is to follow the
structure of the covidtracking API.

Calculated variables:

- Diffs/increases for more variables, in particular confirmed cases/deaths
- 7-day averages for a number of metrics
  - Suffixed with `7d`, are all 7-day means (multiply by 7 for weekly counts
    when desired)
- Rate of change of 7d averages, named `d[OriginalVariable]7d`

### Data sources

**Update:** After looking into this a little more, <https://covidtracking.com>
is probably the best source for US and state data. They have an API, and for MA
the numbers from the daily dashboard match. NB 
- positivity rate does not appear to be calculable using the Covid Tracking
  data;
- also, the MA daily dashboard reports new **confirmed** cases, which would need
  to be constructed by diffing the cumulatives.

#### Cambridge:

- [Cumulative cases by date](https://data.cambridgema.gov/Public-Health/COVID-19-Cumulative-Cases-by-Date/tdt9-vq5y)
- [Confirmed cases in Cambridge](https://data.cambridgema.gov/Public-Health/Confirmed-COVID-19-Cases-in-Cambridge/inw8-ircw)
  - Need to scrape daily to get time series
  - Includes breakdowns by gender, age
- [Cambridge COVID-19 dashboard](https://cityofcambridge.shinyapps.io/COVID19/)
  - Includes some data not in API, e.g., cases by neighborhood, but unclear how it could be retrieved

#### Boston (**no data in repo**):

Doesn't look like there's easy automated access, especially for historical data.

- [bhpc.org main COVID-19 page](https://www.bphc.org/whatwedo/infectious-diseases/Infectious-Diseases-A-to-Z/covid-19/Pages/default.aspx)
- [Boston dashboard](https://dashboard.cityofboston.gov/t/Guest_Access_Enabled/views/COVID-19/Dashboard1?:showAppBanner=false&:display_count=n&:showVizHome=n&:origin=viz_share_link&:isGuestRedirectFromVizportal=y&:embed=y)

  
#### Massachusetts:

- [Mass.gov COVID response reporting](https://www.mass.gov/info-details/covid-19-response-reporting)
  - Raw daily dashboard available daily; either scrape link or construct URL
    (seems consistent)
  - Weekly public health report contains case counts by town
    - Link to raw data for latest weekly report
    - Prior weekly report raw data seems accessible by manually constructing URL
    
#### US (CDC API):

- [Case surveillance public use data](https://data.cdc.gov/Case-Surveillance/COVID-19-Case-Surveillance-Public-Use-Data/vbim-akqf) 
  **not in repo**
- [COVID-19 cases/deaths by state](https://data.cdc.gov/Case-Surveillance/United-States-COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36)
  - Can use API params to aggregate: <https://data.cdc.gov/resource/9mfq-cb36.json?%24select=submission_date%2C+sum(tot_cases)+AS+tot_cases%2C+sum(new_case)+AS+new_case%2C+sum(tot_death)+AS+tot_death%2C+sum(new_death)+AS+new_death&%24group=submission_date&%24order=submission_date>

#### Other data sources:

Github repos:

- NYTimes
- JHU
- Covidtracking

