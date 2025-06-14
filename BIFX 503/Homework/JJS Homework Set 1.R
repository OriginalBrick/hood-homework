# J. Jedediah Smith
# Homework Set No.1
# BIFX 503-1
# 9/9/2021


### QUESTION 1 ###

# Testing the data set.
?airquality
str(airquality)
head(airquality)


### QUESTION 2 ###

# Generates histogram of each data category.
par(mfrow=c(2,2))
hist(airquality$Ozone)
hist(airquality$Temp)
hist(airquality$Wind)
hist(airquality$Solar.R)
par(mfrow=c(1,1))


### QUESTION 3 ###

# Provides summary info of each data category
summary(airquality$Ozone)
summary(airquality$Temp)
summary(airquality$Wind)
summary(airquality$Solar.R)


### QUESTION 4 ###

# Generates side-by-side box plots of each data category by month.
par(mfrow=c(2,2))
boxplot(airquality$Ozone ~ airquality$Month)
boxplot(airquality$Temp ~ airquality$Month)
boxplot(airquality$Wind ~ airquality$Month)
boxplot(airquality$Solar.R ~ airquality$Month)
par(mfrow=c(1,1))


### QUESTION 5 ###

# Generates the mean of each data category by month.
aggregate(Ozone ~ Month, airquality, mean, na.action=na.omit)
aggregate(Temp ~ Month, airquality, mean, na.action=na.omit)
aggregate(Wind ~ Month, airquality, mean, na.action=na.omit)
aggregate(Solar.R ~ Month, airquality, mean, na.action=na.omit)

# Generates the standard deviation of each data category by month.
aggregate(Ozone ~ Month, airquality, sd, na.action=na.omit)
aggregate(Temp ~ Month, airquality, sd, na.action=na.omit)
aggregate(Wind ~ Month, airquality, sd, na.action=na.omit)
aggregate(Solar.R ~ Month, airquality, sd, na.action=na.omit)


### QUESTION 6 ###

# Creates a subset containing only ozone, solar radiation, wind, and temperature.
data_all <- airquality[,1:4]

# Removes N/A values so that correlation can be calculated.
omit_data_all <- na.omit(data_all)

# Calculates the correlation matrix.
cor(omit_data_all)


### QUESTION 7 ###

# Creates a subset containing only data from months 5 (May) and 9 (Sept)
data_may <- airquality[airquality$Month == "5",]
data_sept <- airquality[airquality$Month == "9",]
data_both <- rbind(data_may, data_sept)

# Performs independent t-tests for each data category to compare months 5 (May) and 9 (Sept)
t.test(Ozone ~ Month, data_both)
t.test(Temp ~ Month, data_both)
t.test(Wind ~ Month, data_both)
t.test(Solar.R ~ Month, data_both)


### QUESTION 8 ###

# Performs nonparametric tests instead.
wilcox.test(Ozone ~ Month, data_both)
wilcox.test(Temp ~ Month, data_both)
wilcox.test(Wind ~ Month, data_both)
wilcox.test(Solar.R ~ Month, data_both)
