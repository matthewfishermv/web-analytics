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

data %>%
  slice_max(order_by = source, n = 10) %>%
  mutate(source = reorder(source, pageviews)) %>%
  ggplot(aes(x = source, y = pageviews)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 10 Sources") +
  facet_wrap( ~ browser, scales = "free")

# Categorize session length.
data$sessionLength <-
  as.factor(ifelse(data$sessionDurationBucket > 60, "Long", "Short"))

# Create test-train split.
train.data <- data[1:750,]
test.data <- data[751:1000,]

set.seed(3487)
model <-
  train(
    sessionLength ~ source + browser + pageviews,
    data = train.data,
    method = "rf",
    trControl = trainControl(method = 'cv', number = 10)
  )
