# J. Jedediah Smith
# BIFX 551
# Final
# 5/12/2022

library(C50)
library(gmodels)
library(caret)

###################
### ENGINEERING ###
###################

# Import data
PassengerData <- read.csv("titanic.csv")

# Bin continuous variable Age
PassengerData$Age <- findInterval(PassengerData$Age, c(0, 18, 25, 35, 45, 55, 65))
PassengerData$Age[is.na(PassengerData$Age)] <- 0

# 0 = N/A
# 1 = Under 18
# 2 = 18 to 24
# 3 = 25 to 34
# 4 = 35 to 44
# 5 = 45 to 54
# 6 = 55 to 64
# 7 = Over 64


# Bin continuous variable Fare
PassengerData$Fare <- findInterval(PassengerData$Fare, c(0, 50, 100, 150))
PassengerData$Fare[is.na(PassengerData$Fare)] <- 0

# 1 = Under 50
# 2 = 50 to 99
# 3 = 100 to 149
# 4 = Over 149

# https://stackoverflow.com/questions/12979456/categorize-numeric-variable-into-group-bins-breaks
# https://stackoverflow.com/questions/8161836/how-do-i-replace-na-values-with-zeros-in-an-r-dataframe


# Reorganize variable Cabin to correspond with deck level
# When multiple Cabins are assigned to the same passenger, it will preserve the higher deck

PassengerData$Cabin <- ifelse(grepl("T", PassengerData$Cabin), "T",PassengerData$Cabin)
PassengerData$Cabin <- ifelse(grepl("A", PassengerData$Cabin), "A",PassengerData$Cabin)
PassengerData$Cabin <- ifelse(grepl("B", PassengerData$Cabin), "B",PassengerData$Cabin)
PassengerData$Cabin <- ifelse(grepl("C", PassengerData$Cabin), "C",PassengerData$Cabin)
PassengerData$Cabin <- ifelse(grepl("D", PassengerData$Cabin), "D",PassengerData$Cabin)
PassengerData$Cabin <- ifelse(grepl("E", PassengerData$Cabin), "E",PassengerData$Cabin)
PassengerData$Cabin <- ifelse(grepl("F", PassengerData$Cabin), "F",PassengerData$Cabin)
PassengerData$Cabin <- ifelse(grepl("G", PassengerData$Cabin), "G",PassengerData$Cabin)
PassengerData$Cabin <- sub("^$", "U", PassengerData$Cabin)

# Records on cabin assignment are historically lacking
# U represents an unknown cabin or deck
# Other letters represent the deck

# https://www.encyclopedia-titanica.org/cabins.html
# https://stackoverflow.com/questions/21243588/replace-blank-cells-with-character


# Add unknown for variable Embarked
PassengerData$Embarked <- sub("^$", "U", PassengerData$Embarked)

# Set variable Survived as a factor
PassengerData$Survived <- as.factor(PassengerData$Survived)


#####################
### DECISION TREE ###
#####################

# Random number generator
RNGversion("3.5.2"); set.seed(414)
TrainSample <- sample(891, 800)

# Use random numbers to choose test and train data
PassengerTrain <- PassengerData[TrainSample,]
PassengerTest <- PassengerData[-TrainSample,]

# Create model and exclude variables Passenger ID, Survived, Name, and Ticket
PassengerModel <- C5.0(PassengerTrain[,c(-1,-2,-4,-9)], PassengerTrain$Survived)

# Check diagnostics to make sure it worked
PassengerModel
summary(PassengerModel)

# Set up prediction model
PassengerPredicted <- predict(PassengerModel, PassengerTest)

# Review results in table format. Correct about 78% of the time.
CrossTable(PassengerTest$Survived, PassengerPredicted,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))

# Boost to see if better results? Not really, still correct about 78% of the time.
PassengerModel_Boost25 <- C5.0(PassengerTrain[,c(-1,-2,-4,-9)], PassengerTrain$Survived, trials=25)
PassengerModel_Boost25
summary(PassengerModel_Boost25)
PassengerPredicted_Boost25 <- predict(PassengerModel_Boost25, PassengerTest)
CrossTable(PassengerTest$Survived, PassengerPredicted_Boost25,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))


#######################
### QUALITY METRICS ###
#######################

confusionMatrix(PassengerTest$Survived, PassengerPredicted,positive = "1")
confusionMatrix(PassengerTest$Survived, PassengerPredicted_Boost25,positive = "1")

# Sensitivity or Recall (Proportion of positive examples that were correctly classified.)
sens <- sensitivity(PassengerTest$Survived, PassengerPredicted,positive = "1")
rec <- sensitivity(PassengerTest$Survived, PassengerPredicted,positive = "1")
sens_Boost25 <- sensitivity(PassengerTest$Survived, PassengerPredicted_Boost25,positive = "1")
rec_Boost25 <- sensitivity(PassengerTest$Survived, PassengerPredicted_Boost25,positive = "1")

# Specificity (Proportion of negative examples that were correctly classified.)
spec <- specificity(PassengerTest$Survived, PassengerPredicted,negative = "0")
spec_Boost25 <- specificity(PassengerTest$Survived, PassengerPredicted_Boost25,negative = "0")

# Precision (Proportion of positive examples that are truly positive.)
prec <- posPredValue(PassengerTest$Survived, PassengerPredicted,positive = "1")
prec_Boost25 <- posPredValue(PassengerTest$Survived, PassengerPredicted_Boost25,positive = "1")

# F-1 Score (Describes model performance in a single number.)
f1s <- (2 * prec * rec) / (prec + rec)
f1s_Boost25 <- (2 * prec_Boost25 * rec_Boost25) / (prec_Boost25 + rec_Boost25)

