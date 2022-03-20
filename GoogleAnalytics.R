packages <- c("dplyr",
              "lubridate",
              "ggplot2")

for (p in packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

source("./src/google.R")
source("./src/session_length.R")

account <- get_account()

# Get data from the past year.
start_date <- today() - years(1)
end_date <- today()
data <-
  get_data(
    account,
    c("pageviews"),
    c("source", "browser", "sessionDurationBucket"),
    start_date = start_date,
    end_date = end_date
  )

# Visualize session length.
p <- plot_session_length(data, type = "histogram")
p
wrap_session_dimension(p, "browser")
