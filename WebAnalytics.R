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
source("./src/visits.R")
source("./src/bounces.R")

account <- get_account()

# Get session length data from the past year.
start_date <- today() - years(1)
end_date <- today()
sessions <-
  get_data(
    account,
    c("pageviews"),
    c("source", "browser", "sessionDurationBucket"),
    start_date = start_date,
    end_date = end_date
  )

# Visualize session length.
p <- plot_session_length(sessions, type = "histogram")
p
wrap_session_dimension(p, "browser")

# Get visit data from the past year.
start_date <- today() - years(5)
end_date <- today()
visits <-
  get_data(
    account,
    c("uniquePageviews"),
    c("date", "browser"),
    start_date = start_date,
    end_date = end_date
  )

# Visualize visits.
p <- plot_visits(visits)
p

# Get bounce data form the past year.
start_date <- today() - years(5)
end_date <- today()
bounces <-
  get_data(
    account,
    c("bounces"),
    c("date", "pagePathLevel1"),
    start_date = start_date,
    end_date = end_date
  )

# Visualize bounces.
p <- plot_bounces(bounces)
p

p <- plot_highest_bounces(bounces)
p
