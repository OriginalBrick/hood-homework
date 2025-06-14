# J. Jedediah Smith
# BIFX 551
# Assignment 4
# 5/10/2022

# install.packages("C50")
library(C50)

# install.packages("gmodels")
library(gmodels)


##################
### QUESTION 1 ###
##################

# Prepare the provided Diabetes data set, implement ONE of the classification techniques and 
# evaluate the performance using the proper metrics for the binary classification of the variable "Outcome."

# Import data
DiabetesData <- read.csv("diabetes.csv")

# Set Outcome variable as a factor
DiabetesData$Outcome <- as.factor(DiabetesData$Outcome)

# Random number generator
RNGversion("3.5.2"); set.seed(123)
TrainSample <- sample(1000, 900)

# Use random numbers to choose test and train data
DiabetesTrain <- DiabetesData[TrainSample,]
DiabetesTest <- DiabetesData[-TrainSample,]

# Check that distributions are close to 7:3 ratio
prop.table(table(DiabetesTest$Outcome))
prop.table(table(DiabetesTrain$Outcome))


# CLASSIFICATION (via Decision Tree)
# Create model and exclude the Outcome variable
DiabetesModel <- C5.0(DiabetesTrain[-9], DiabetesTrain$Outcome)

# Check diagnostics to make sure it worked
DiabetesModel
summary(DiabetesModel)

# Set up prediction model
DiabetesPredicted <- predict(DiabetesModel, DiabetesTest)


# EVALUTION (via Cross Table)
# Review results in table format. Correct about 77% of the time.
CrossTable(DiabetesTest$Outcome, DiabetesPredicted,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))