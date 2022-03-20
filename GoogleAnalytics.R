packages <- c("dplyr",
              "lubridate",
              "ggplot2",
              "randomForest",
              "caret")

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

# Wrangle the data.
data <- data %>%
  mutate(sessionDurationBucket = as.numeric(sessionDurationBucket))

# Categorize session length.
plot_session_length(data, type = "histogram")

data$sessionLength <-
  as.factor(ifelse(data$sessionDurationBucket > breakpoint, "Long", "Short"))

# Create test-train split.
train.data <- data[1:750, ]
test.data <- data[751:1000, ]

set.seed(3487)
model <-
  train(
    sessionLength ~ source + browser + pageviews,
    data = train.data,
    method = "rf",
    trControl = trainControl(method = 'cv', number = 10)
  )
