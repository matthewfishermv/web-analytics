packages <- c("dplyr", "ggplot2", "lubridate")

for (p in packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

plot_session_length <- function(data, type = "histogram") {
  if (type == "histogram") {
    hist(data$processed$sessionDurationBucket,
         main = paste0("Session Duration\n",
                       paste(
                         format(ymd(
                           as.Date(data$parameters$start_date)
                         ), "%m/%d/%Y"),
                         "-",
                         format(ymd(as.Date(
                           data$parameters$end_date
                         )), "%m/%d/%Y")
                       )))
  }
}
