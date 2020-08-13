## COVID dashboard data for Cambridge area

Data repository for COVID-19 data in Cambridge, MA area. Raw files from original
sources (listed below) are in the `data-raw/` directory. Scripts and processed
data in the roadmap.

### Data sources

#### Cambridge:

- [Cumulative cases by date](https://data.cambridgema.gov/Public-Health/COVID-19-Cumulative-Cases-by-Date/tdt9-vq5y)
- [Confirmed cases in Cambridge](https://data.cambridgema.gov/Public-Health/Confirmed-COVID-19-Cases-in-Cambridge/inw8-ircw)
  - Need to scrape daily to get time series
  - Includes breakdowns by gender, age

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

#### Other data sources:

Github repos:

- NYTimes
- JHU
- Covidtracking

