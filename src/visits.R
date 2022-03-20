packages <- c("dplyr", "ggplot2", "lubridate", "ggthemes")

for (p in packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

plot_visits <- function(data) {
  p <- data$processed %>%
    group_by(date) %>%
    summarize(uniquePageviews = sum(uniquePageviews)) %>%
    ggplot(aes(x = date, y = uniquePageviews)) +
    geom_line() +
    labs(title = element_text("Visits"),
         subtitle = paste(format(ymd(
           as.Date(data$parameters$start_date)
         ), "%m/%d/%Y"),
         "-",
         format(ymd(
           as.Date(data$parameters$end_date)
         ), "%m/%d/%Y"))) +
    xlab("\nDate") +
    ylab("# Unique Visits\n") +
    theme_gdocs() +
    theme(legend.position = "none")
  
  return(p)
}
