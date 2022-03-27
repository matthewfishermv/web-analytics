packages <- c("dplyr", "ggplot2", "lubridate", "ggthemes")

for (p in packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p)
    library(p, character.only = TRUE)
  }
}

plot_bounces <- function(data) {
    p <- data$processed %>%
      ggplot(aes(x = date, y = bounces, fill = 1)) +
      geom_line() +
      labs(title = element_text("Bounces"),
           subtitle = paste(format(ymd(
             as.Date(data$parameters$start_date)
           ), "%m/%d/%Y"),
           "-",
           format(ymd(
             as.Date(data$parameters$end_date)
           ), "%m/%d/%Y"))) +
      xlab("\nSession Length (Minutes)") +
      ylab("Frequency\n") +
      theme_gdocs() +
      theme(legend.position = "none")
    
    return(p)
}

plot_highest_bounces <- function(data) {
  data$processed %>%
    mutate(pagePathLevel1 = gsub("\\/", "", pagePathLevel1)) %>%
    group_by(pagePathLevel1) %>%
    count() %>%
    ungroup() %>%
    mutate(pagePathLevel1 = reorder(pagePathLevel1, n)) %>%
    filter(n > 50) %>%
    ggplot(aes(x = pagePathLevel1, y = n, fill = -n)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    labs(
      title = "Highest Bounces by Page"
    ) +
    xlab("Page\n") +
    ylab("\n# Bounces") +
    theme_gdocs() +
    theme(
      legend.position = "none"
    )
}

wrap_bounce_dimension <- function(p, dimension) {
  p + facet_wrap(as.formula(paste("~", dimension)))
}
