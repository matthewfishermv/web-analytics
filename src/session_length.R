packages <- c("dplyr", "ggplot2")

for (p in packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

plot_session_length <- function(data, type = "histogram") {
  if (type == "histogram") {
    hist(data$processed$sessionDurationBucket,
         main = "Session Duration")
  }
}
