packages <- c("googleAnalyticsR",
              "dplyr",
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

# Authenticate.
googleAuthR::gar_set_client(json = ".secrets/client_secret_306994286184-usjggu1j6n5v60d4bbt7iv9aao8323ju.apps.googleusercontent.com.json")
ga_auth(email = "ga-analysis@airy-ripple-344600.iam.gserviceaccount.com",
        json_file = ".secrets/airy-ripple-344600-f828fd6663de.json")

# Select the account.
accounts <- ga_account_list()
account <- accounts$viewId

# Look at a single day.
ga_start_date <- today() - years(1)
ga_end_date <- today()

data <- google_analytics(
  account,
  segments = segment_ga4("AllTraffic", segment_id = "gaid::-1"),
  date_range = c(ga_start_date, ga_end_date),
  metrics = c("pageviews"),
  dimensions = c("source", "browser", "sessionDurationBucket")
) %>%
  as_tibble()

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
  train(sessionLength ~ source + browser + pageviews,
        data = train.data,
        method = "rf",
        trControl = trainControl(method = 'cv', number = 10))
