packages <- c("googleAnalyticsR",
              "dplyr")

for (p in packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

authenticate <- function() {
  googleAuthR::gar_set_client(json = ".secrets/client_secret_306994286184-usjggu1j6n5v60d4bbt7iv9aao8323ju.apps.googleusercontent.com.json")
  ga_auth(email = "ga-analysis@airy-ripple-344600.iam.gserviceaccount.com",
          json_file = ".secrets/airy-ripple-344600-f828fd6663de.json")
}

get_account <- function() {
  authenticate()
  accounts <- ga_account_list()
  account <- accounts$viewId
  return (account)
}

get_data <- function(account,
                     metrics,
                     dimensions,
                     start_date,
                     end_date) {
  # Retrieve data.
  data <- google_analytics(
    account,
    segments = segment_ga4("AllTraffic", segment_id = "gaid::-1"),
    date_range = c(start_date, end_date),
    metrics = c("pageviews"),
    max = -1,
    dimensions = c("source", "browser", "sessionDurationBucket")
  ) %>%
    as_tibble()
  
  # Wrangle data.
  processed <- data %>%
    mutate(source = as.factor(source)) %>%
    mutate(browser = as.factor(browser)) %>%
    mutate(sessionDurationBucket = as.numeric(sessionDurationBucket)) %>%
    mutate(segment = as.factor(segment))
  
  # Return data.
  return (list(
    raw = data,
    processed = processed,
    parameters = list(
      account = account,
      start_date = start_date,
      end_date = end_date
    )
  ))
}
