# BIFX 546
# Midterm 1
# J. Jedediah Smith
# 2/18/2023

library(dplyr)
library(stringr)
library(gmodels)
library(class)
library(e1071)

##################
# PRE-PROCESSING #
##################

# Import data, name the outcome column, set R to 0, set M to 1, and make sure it is all numeric.
# Looked up how to do the mutate with dplyr! https://www.statology.org/dplyr-replace-string-in-column/
SonarData <- read.csv("sonar.csv", stringsAsFactors = FALSE) %>%
  rename("Outcome" = "R") %>%
  mutate(across("Outcome", str_replace, "R", "0")) %>%
  mutate(across("Outcome", str_replace, "M", "1")) %>%
  mutate_if(is.character, as.numeric)

# Brief analysis, no need to normalize since range is pretty similar.
table(SonarData$Outcome)
round(prop.table(table(SonarData$Outcome)) * 100, digits = 1)
summary(SonarData)

# Normalize the data
normalize <- function(x) {return ((x - min(x)) / (max(x) - min(x)))}
SonarData_n <- as.data.frame(lapply(SonarData, normalize))

# Randomize the rows so it isn't "in order." Don't want to bias the model by choosing too many of one outcome.
# Looked up how to randomize rows. https://statisticsglobe.com/randomly-reorder-data-frame-by-row-and-column-in-r
set.seed(2347723)
SonarData_nr <- SonarData_n[sample(1:nrow(SonarData_n)), ]

# Now select our test and train data for both models. Exclude the outcome.
sd_train <- SonarData_nr[1:165, 1:60]
sd_test <- SonarData_nr[166:207, 1:60]

# Save our outcomes for comparison afterwards.
sd_train_labels <- SonarData_nr[1:165,61]
sd_test_labels <- SonarData_nr[166:207,61]


#################
# 1a. KNN MODEL #
#################

# Run the K Nearest Neighbor model. Used K = 10 since it is close to 13, the square root of 165, but performs better.
KNN_test_pred <- knn(train = sd_train, test = sd_test,
                      cl = sd_train_labels, k = 10)

# Cross table for overall metrics
CrossTable(x = sd_test_labels, y = KNN_test_pred, prop.chisq = FALSE)

# Calculate stats: accuracy, precision, recall, F1 score
KNN_Precision = 17/(17+4)
KNN_Recall = 17/(17+7)
KNN_Accuracy = (17+14) / (17+14+7+4)
KNN_F1 = 2*((KNN_Precision*KNN_Recall)/(KNN_Precision+KNN_Recall))


#################
# 1b. NBC MODEL #
#################

# Run the Naive Bayes Classifier model.
sd_classifier <- naiveBayes(sd_train, sd_train_labels)
NBC_test_pred <- predict(sd_classifier, sd_test)

# Cross table for overall metrics
CrossTable(x = sd_test_labels, y = NBC_test_pred, prop.chisq = FALSE)

# Calculate stats: accuracy, precision, recall, F1 score
NBC_Precision = 11/(11+10)
NBC_Recall = 11/(11+5)
NBC_Accuracy = (11+16) / (11+16+5+10)
NBC_F1 = 2*((NBC_Precision*NBC_Recall)/(NBC_Precision+NBC_Recall))


##################
# 2. CONCLUSIONS #
##################

# Summarize the stats in a single table
tab <- matrix(c(KNN_Precision,KNN_Recall,KNN_Accuracy,KNN_F1,
                NBC_Precision,NBC_Recall,NBC_Accuracy,NBC_F1),ncol=2, byrow=FALSE)
colnames(tab) <- c("K Nearest Neighbor","Naive Bayes")
rownames(tab) <- c("Precision","Recall","Accuracy", "F1 Score")
tab

# Over all it seems that the KNN Model is better.
# It has superior performance in all stats, especially precision.