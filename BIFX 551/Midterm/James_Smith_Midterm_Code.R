# J. Jedediah Smith
# BIFX 551
# Midterm
# 3/20/2022

library("MASS")
library("ggplot2")


###############
# QUESTION 1a #
###############

# Grab the data set.
catsData <- cats

# Plot data with hwt on vertical axis, bwt on horizontal, and colored by sex.
# https://www.geeksforgeeks.org/how-to-color-scatter-plot-points-in-r/
# http://www.sthda.com/english/wiki/ggplot2-title-main-axis-and-legend-titles
ggplot(catsData,aes(x=Bwt,y=Hwt,group=Sex))+
  geom_point(aes(color=Sex))+
  scale_color_manual(values=c('Red','Blue'))+
  ggtitle("Cat Body and Heart Weight by Sex")+
  xlab("Body Weight (kg)")+
  ylab("Heart Weight (g)")


###############
# QUESTION 1b #
###############

# Fit a least-squares multiple linear regression model with hwt as response, bwt and sex as predictors.
fit <- lm(Hwt ~ Bwt + Sex, data=catsData)
summary(fit)

# Run regression diagnostics
par(mfrow=c(2,2))
plot(fit)
par(mfrow=c(1,1))

# Normality: Pass (Normal QQ is a straight line.)
# Linearity: Pass (Residuals vs Fitted is not curved.)
# Homoscedasticity: Pass (Scale-Location is random around a horizontal line.)
# Independence: Assumed


###############
# QUESTION 1c #
###############

# No new code needed.
# Plug the coefficient intercepts from Question 1b into line equation to get prediction formula.
# As shown in Question 1b, Bwt was significant, while Sex was insignificant.


###############
# QUESTION 1d #
###############

# No new code needed.
# Coefficient of determination is the Multiple R-Squared from summary in Question 1b.
# Omnibus F-Test is the F-statistic from summary in Question 1b.
# Links below helped me make these conclusions, as I found the question terminology puzzling.
# http://www.sthda.com/english/articles/40-regression-analysis/168-multiple-linear-regression-in-r/
# https://www.statology.org/r-squared-in-r/


###############
# QUESTION 1e #
###############

# Create frame with data to predict from.
Bwt <- 3.4
Sex <- "F"
newData <- data.frame(Sex,Bwt)

# Predict what the Hwt will be.
# https://www.r-tutor.com/elementary-statistics/simple-linear-regression/prediction-interval-linear-regression
predict(fit,newData,interval="predict") #95% interval is the default.


###############
# QUESTION 1f #
###############

# Make predictions using fitted model
predfit <- predict(fit)

# Plot the predictions against original data.
# https://aosmith.rbind.io/2018/11/16/plot-fitted-lines/#plotting-predicted-values-with-geom_line
ggplot(catsData, aes(x = Bwt, y = Hwt, color = Sex) ) +
  geom_point() +
  geom_line(aes(y = predfit), size = 1) +
  scale_color_manual(values=c('Red','Blue'))+
  ggtitle("Cat Body and Heart Weight by Sex with Prediction Trendlines")+
  xlab("Body Weight (kg)")+
  ylab("Heart Weight (g)")


###############
# QUESTION 2a #
###############

# Grab data and remove the unneeded categories.
carData <- Cars93
carData.num <- carData[-c(1,2,3,10,26,27)]

# Aggregate data around remaining categories to get length mean
# https://r-coder.com/aggregate-r/
aggregate(Length ~ AirBags + Man.trans.avail, data = carData.num, FUN = mean)


###############
# QUESTION 2b #
###############

# Save the aggregate data
aggrfit <- aggregate(Length ~ AirBags + Man.trans.avail, data = carData.num, FUN = mean)

# Interaction plot of aggregate data
# https://ggplot2tutor.com/tutorials/interaction_plot
ggplot(aggrfit, aes(x=Length, y=AirBags, group=Man.trans.avail)) +
  geom_line(aes(group = Man.trans.avail, color = Man.trans.avail)) +
  geom_point(aes(color = Man.trans.avail)) +
  ggtitle("Average Car Length by Air Bag Type and Manual Transition Availability")+
  xlab("Mean Length (in)")+
  ylab("Air Bag Type")


###############
# QUESTION 2c #
###############

# First two-way ANOVA model from aggregate data.
# Did not display p-values when I tested it, so I went and made a second model.
anovaModel <- aov(Length ~ AirBags * Man.trans.avail, data = aggrfit)
summary(anovaModel)

# Second two-way ANOVA model from original raw data.
# It did display p-values when I tested it, so I used this for my answers.
anovaModel <- aov(Length ~ AirBags * Man.trans.avail, data = carData)
summary(anovaModel)
