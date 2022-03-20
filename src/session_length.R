packages <- c("dplyr", "ggplot2", "lubridate", "ggthemes")

for (p in packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

plot_session_length <- function(data, type = "histogram") {
  if (type == "histogram") {
    p <- data$processed %>%
      ggplot(aes(x = sessionDurationBucket, fill = 1)) +
      geom_histogram(binwidth = 200) +
      labs(title = element_text("Session Length"),
           subtitle = paste(format(ymd(
             as.Date(data$parameters$start_date)
           ), "%m/%d/%Y"),
           "-",
           format(ymd(
             as.Date(data$parameters$end_date)
           ), "%m/%d/%Y"))) +
      xlab("Session Length (Minutes)") +
      ylab("Frequency") +
      theme_gdocs() +
      theme(legend.position = "none")
    
    return(p)
  }
}

wrap_session_dimension <- function(p, dimension) {
  p + facet_wrap(as.formula(paste("~", dimension)))
}
