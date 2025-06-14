# J. Jedediah Smith
# Homework Set No.2
# BIFX 503-1
# 9/23/2021


library(MASS)

### QUESTION 1 ###

# Generate interaction plot of vitamin C by cultivar and plant date.
interaction.plot(x.factor=cabbages$Date, trace.factor=cabbages$Cult, response=cabbages$VitC, fun="mean", type="b", ylab="Vitamin C", xlab="Date", trace.label="Cabbage Cultivar",  pch=c(1,19))


### QUESTION 2 ###

# Run an ANOVA model for cultivar, plant date, and interaction. If interaction is significant, run simple main effects analysis.
summary(aov(VitC ~ Cult*Date, cabbages))


### QUESTION 3 ###

# Assess relationship between Vitamin C and Weight using scatterplot and correlation.
ggplot(cabbages, aes(x=HeadWt, y=VitC)) + geom_point() + xlab("Weight") + ylab("Vitamin C")
cor(cabbages$HeadWt, cabbages$VitC)


### QUESTION 4 ###

# Re-Run ANOVA with weight as a covariate (ANCOVA).
summary(aov(VitC ~ HeadWt+Cult*Date, cabbages))


### QUESTION 5 ###

# This question did not require code to be answered.
print("No code required.")


### QUESTION 6 ###

library(MASS)

# Create new variable that is the average of MPG.city and MPG.highway.
Cars93$MPG.average <- rowMeans(Cars93[ , c(7,8)], na.rm=TRUE)

# Make three scatter plots and three box plots to see how each of the six independent variables (MPG, Horsepower, Passengers, AirBags, DriveTrain, and Origin) relate to the dependent variable (Price).
par(mfrow=c(3,3))
plot(Price ~ MPG.average, Cars93)
plot(Price ~ Horsepower, Cars93)
plot(Price ~ Passengers, Cars93)
boxplot(Price ~ AirBags, Cars93)
boxplot(Price ~ DriveTrain, Cars93)
boxplot(Price ~ Origin, Cars93)
par(mfrow=c(1,1))


### QUESTION 7 ###

# Fit a series of linear regression models having Price as the dependent variable for each of the independent variables.
lm(Price ~ MPG.average, Cars93)            # Regression Coefficient
confint(lm(Price ~ MPG.average, Cars93))   # 95% Confidence Interval
summary(lm(Price ~ MPG.average, Cars93))   # P-Value

lm(Price ~ Horsepower, Cars93)
confint(lm(Price ~ Horsepower, Cars93))
summary(lm(Price ~ Horsepower, Cars93))

lm(Price ~ Passengers, Cars93)
confint(lm(Price ~ Passengers, Cars93))
summary(lm(Price ~ Passengers, Cars93))

lm(Price ~ AirBags, Cars93)
confint(lm(Price ~ AirBags, Cars93))
summary(lm(Price ~ AirBags, Cars93))

lm(Price ~ DriveTrain, Cars93)
confint(lm(Price ~ DriveTrain, Cars93))
summary(lm(Price ~ DriveTrain, Cars93))

lm(Price ~ Origin, Cars93)
confint(lm(Price ~ Origin, Cars93))
summary(lm(Price ~ Origin, Cars93))


### QUESTION 8 ###

# Should any of the variables be removed?
fit1 <- lm(Price ~ Horsepower, Cars93)
fit2 <- lm(Price ~ Horsepower + MPG.average, Cars93)
fit3 <- lm(Price ~ Horsepower + AirBags, Cars93)
fit4 <- lm(Price ~ Horsepower + DriveTrain, Cars93)
anova(fit1, fit2)
anova(fit1, fit3) # Only one with significant result, remove other variables.
anova(fit1, fit4)

# What is the final model?
lm(Price ~ Horsepower + AirBags, Cars93)
confint(lm(Price ~ Horsepower + AirBags, Cars93))
summary(lm(Price ~ Horsepower + AirBags, Cars93))


