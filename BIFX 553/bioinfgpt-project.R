# Load in data and remove unneeded columns
full_data <- read.csv("2018-06-06-ss.cleaned.csv")

# Subset only seq and sst3 columns where seq >= 20 bases.
library(tidyr)
library(stringr)
sub_data <- subset(full_data, select = c(3,5))
sub_data$count <- str_count(sub_data$seq)
sub_data <- subset(sub_data, sub_data$count >= 20, select = c(1,2))

# Determine train and test sample sizes.
TrainNum <- round(nrow(sub_data)*.80)
TestNum <- round(nrow(sub_data)*.20)

# Sample random rows from the data set.
# Turns out the program actually does this part for us, so we don't need to actually use it here.
set.seed(5)
TestRows <- sample(1:nrow(sub_data), TestNum)
test_data <- sub_data[TestRows, ]
train_data <- sub_data[-TestRows, ]

# Create data format a
train_data$seq_a <- paste("(",train_data$seq,")", sep = "")
train_data$sst3_a <- paste("[",train_data$sst3,"]", sep = "")
format_a <- paste(train_data$seq_a, train_data$sst3_a, sep = "")
train_data <- subset(train_data, select = -c(3,4))

# Create data format b
train_data$seq_b <- paste("[",train_data$seq, sep = "")
train_data$sst3_b <- paste(train_data$sst3,"]", sep = "")
format_b <- paste(train_data$seq_b, train_data$sst3_b, sep = "|")
train_data <- subset(train_data, select = -c(3,4))

# Export to text
write.table(format_a, file = "format_a.txt", sep = "", col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(format_b, file = "format_b.txt", sep = "", col.names = FALSE, row.names = FALSE, quote = FALSE)
