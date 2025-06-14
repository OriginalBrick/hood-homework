# J. Jedediah Smith
# BIFX 551
# Assignment 2 & 3
# 4/9/2022

install.packages("AER")
library(psych)

##################
### QUESTION 1 ###
##################

# Import data
BroData <- read.csv("Bronchitis.csv")

# Relabel binary bron variable
BroData$bron <- factor(BroData$bron,levels=c(0,1),labels=c("No","Yes"))

# View distribution
table(BroData$bron)

# Create generalized linear model
BroFit <- glm(bron ~ cigs + poll, data=BroData, family=binomial())
summary(BroFit)

# Both variables cigs and poll appear to have a significant effect. No need to trim them from model.

# Get the coefficient intercepts to see the probability of getting bron from unit increase of each one.
exp(coef(BroFit))


##################
### QUESTION 2 ###
##################

# Import data
SubData <- read.csv("Subjects.csv")

# Label row names as participant ID
row.names(SubData) <- SubData[,1]
SubData <- SubData[,-1]

# Scree plot to determine the number of components needed.
fa.parallel(SubData, fa="pc", n.iter=100,
            show.legend=FALSE, main="Scree plot with parallel analysis")

# Determined that 1 component is ideal. Get PC values for formula.
SubPC <- principal(SubData, nfactors=1, score=TRUE)
SubPC

# Get global scores for ranking.
SubPC$scores


##################
### QUESTION 3 ###
##################

# Create data
NumData <- c(-3,7,1,4,0,6,3,5,1,9,7,7,6,9,8,10,7,12,10,11)
dim(NumData) <- c(10,2)
colnames(NumData) <- c("X","Y")
NumData <- as.data.frame(NumData)

# Scree plot to determine the number of components needed.
fa.parallel(NumData, fa="pc", n.iter=100,
            show.legend=FALSE, main="Scree plot with parallel analysis")

# Determined that 0 components is ideal. Get PC values for formula.
NumPC <- principal(NumData, nfactors=0, score=TRUE)
NumPC

# Create linear model
NumModel <- lm(Y~X,data=NumData)
summary(NumModel)

# Scatter plot with linear model line
plot(NumData$X, NumData$Y, main = "Scatterplot of X and Y",
     xlab = "X Values", ylab = "Y Values", pch = 20)
abline(lm(Y~X,data=NumData))
