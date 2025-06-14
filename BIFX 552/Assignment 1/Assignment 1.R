# J. Jedediah Smith
# BIFX 552
# Assignment 1
# 11/9/2022

# Load Packages
library(ggplot2)
library(scales)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggcorrplot)


# Set up colorblind pallete
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# Load the document into R, remove unneeded rows or columns, and fix bad data.
import <- read.csv("cinema.csv")
cinema <- import[c(1:40),c(1:9)] %>%
  mutate(Spain = case_when(Spain == "x" ~ "0", !is.na(Spain) ~ Spain)) %>%
  mutate(co.productions = case_when(co.productions == "x" ~ "0", !is.na(co.productions) ~ co.productions)) %>%
  mutate(Spain = as.numeric(Spain))

# Pivot for the comparison line graph
cinema_pivot <- cinema[,c(1,4:7)] %>%
  pivot_longer(cols = 2:5, names_to = "country", values_to = "screenings")

# Subset for the 2018 bar graph
cinema_2018 <- cinema[,c(1,3:8)] %>%
  rename("Other" = other_countries) %>%
  pivot_longer(cols = 2:7, names_to = "country", values_to = "screenings") %>%
  filter(year == "2018")

# Subset for the Portugal box plot
cinema_Portugal <- cinema[,c(1,3:8)] %>%
  pivot_longer(cols = 2:7, names_to = "country", values_to = "screenings") %>%
  filter(country == "Portugal")


##############
# QUESTION 1 #
##############
# Find the distribution of the total number of screenings over time.
ggplot(cinema, aes(x = year, y = total, group = 1)) +
  geom_line() +
  labs(
      title = "Total Screenings by Year",
      x = 'Year',
      y = 'Total Screenings',
      caption = "This simple line graph plots the total number of cinema screenings over time.") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5),
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0.5))


##############
# QUESTION 2 #
##############
# Choose a country and display the number of screenings over time.
ggplot(cinema, aes(x = year, y = USA, group = 1)) +
  geom_line() +
  labs(
    title = "USA Screenings by Year",
    x = 'Year',
    y = 'Total Screenings',
    caption = "This simple line graph plots the number of US cinema screenings over time.") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5),
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0.5))


##############
# QUESTION 3 #
##############
# Compare the screenings over time for Spain, France, UK and USA
cinema_pivot$country <- factor(cinema_pivot$country, levels = c("Spain", "USA", "France", "UK"))
ggplot(cinema_pivot, aes(x = year, y = screenings, color = country)) +
  geom_line(linewidth = 1) +
  labs(
    title = "Country Screenings by Year",
    x = 'Year',
    y = 'Screenings',
    caption = "This line graph plots the number of cinema screenings in four countries over time.") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5),
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0.35)) +
  scale_colour_manual(values=cbbPalette)
# Could have solved this WITHOUT a pivot by creating multiple lines like I did for area plot under question 5.


##############
# QUESTION 4 #
##############
# In 2018 compare the screening number produced by the different locations in the dataset?
ggplot(cinema_2018, aes(reorder(x = country, -screenings), y = screenings)) +
  geom_col() +
  geom_text(aes(label = screenings), vjust = -0.5) +
  labs(
      title = "Screenings by Country in 2018",
      x = 'Country', 
      y = 'Screenings',
      caption = "This bar graph plots the number of cinema screenings in 2018 for each country in the dataset.") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5),
    axis.text.x = element_text(angle=0, hjust=0.5),
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0.5))


##############
# QUESTION 5 #
##############
# How many of the total movies were produced by USA over the years?
ggplot(cinema, aes(x = year)) +
  geom_area(aes(y = total, fill = "black")) +
  geom_area(aes(y = USA, fill = "blue")) +
  scale_fill_identity(
    name = "Color",
    labels = c("Total", "USA"),
    guide = "legend") +
  labs(
    title = "USA Screenings Compared to Total",
    x = 'Year',
    y = 'Screenings',
    caption = "This area plot compares the number of USA screenings to total screenings over time.") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5),
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0.35))


##############
# QUESTION 6 #
##############
# Is there any correlation between the screenings produced by UK and USA, what about France and USA?
corr <- round(cor(cinema[,c(5:7)]), 1)
ggcorrplot(corr, hc.order = TRUE, type = "lower", outline.col = "white", lab = TRUE) +
  labs(
    title = "Screening Correlation",
    caption = "This simple correlation plot compares the screening in 3 countries.") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.text.x = element_text(angle=0, hjust=0.5),
    axis.text.y = element_text(angle=90, hjust=0.5),
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0.35))


##############
# QUESTION 7 #
##############
# Are there any outliers in the Portugal screenings?
ggplot(cinema_Portugal, aes(x=screenings, y=country, group = 1)) + 
  geom_boxplot() +
  coord_flip() +
  labs(
    title = "Portugal Screening Distribution",
    x = 'Screenings',
    y = '',
    caption = "This boxplot shows the distribution of screenings for Portugal and identifies outliers.") +
  theme(
    plot.title = element_text(color="black", size=18, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="black", size=12, face="bold"),
    axis.title.y = element_text(color="black", size=12, face="bold"),
    axis.text.y = element_text(angle=90, hjust=0.5),
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0.5))
