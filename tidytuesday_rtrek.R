#### tidytuesday_rtrek.R ====================================================
# 04-18 January 2023

# Libraries and Data ===========================================================
if(!require(tidytuesdayR)) install.packages('tidytuesdayR')
tuesdata <- tidytuesdayR::tt_load('2022-12-27')

trek_book <- tuesdata[[1]]
trek_note <- tuesdata[[2]]

rm(tuesdata)

library(dplyr)
library(ggplot2)
library(tidytext)
library(magrittr)
library(wordcloud)
library(reshape2)

#### Text Extraction ===========================================================

# Extract words from "title" field within rtrek dataset
titles <- trek_book %>%
  select(title) %>%
  unnest_tokens(input = "title", output = "title_words") %>%
  pull(title_words)

# Remove possessive ending from words
titles <- gsub("'s", "", titles)

# Download sentiment associations
sentiments <- get_sentiments("bing")

# Pair sentiments with title words
text_data <- data.frame("titles" = titles, "sentiments" = NA)
text_data %<>% inner_join(sentiments, c("titles" = "word"))

# Word cloud plot
text_data %>%
  count(titles, sentiment, sort = TRUE) %>%
  acast(titles ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red3", "cyan3"), max.words = 200)
