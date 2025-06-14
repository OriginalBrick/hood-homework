## This program shows in-class examples for BIFX 503 Missing Data

library(MASS)
library(HSAUR3)
library(mice)
library(dplyr)
library(ggplot2)
library(e1071)
library(naniar)

###########################################################################################################################################
## Missing Data
###########################################################################################################################################

?bp
str(bp)
summary(bp)

## Little's test for MCAR
mcar_test(bp)
# Result - reject null hypothesis of MCAR (p<0.05)

# create missing value dummy variable
bp$is_msg <- ifelse(is.na(bp$recovtime), 1, 0)

# t tests to determine if missingness associated with values of other variables
t.test(logdose ~ is_msg, bp)   # NS
t.test(bloodp ~ is_msg, bp)    # NS
# missingness not associated with either variable's magnitude

## analysis of complete cases only
bp.complete <- na.omit(bp)
str(bp.complete)
summary(bp.complete)
cor(bp.complete)
summary(lm(recovtime ~ bloodp + logdose, bp.complete))

## analysis of available cases only
summary(bp)
cor(bp, use = "pairwise")
summary(lm(recovtime ~ bloodp + logdose, bp))

## mean value imputation
imp <- mice(bp, method="mean", m=1, maxit=1)
with(imp, summary(recovtime))
with(imp, sd(recovtime))
with(imp, cor(bloodp, recovtime))
with(imp, cor(logdose, recovtime))
with(imp, summary(lm(recovtime ~ bloodp + logdose)))

## multiple imputation
imp_ppm <- mice(bp, method="pmm", m=10, print=FALSE, seed=1)
summary(unlist(with(imp_ppm, mean(recovtime))$analyses))
summary(unlist(with(imp_ppm, sd(recovtime))$analyses))
summary(unlist(with(imp_ppm, cor(bloodp,recovtime))$analyses))
summary(unlist(with(imp_ppm, cor(logdose,recovtime))$analyses))
fit <- with(imp_ppm, lm(recovtime ~ bloodp + logdose))
summary(pool(fit))


###########################################################################################################################################
## Assessing Normality
###########################################################################################################################################
  
## Histogram

summary(airquality)

hist(airquality$Ozone)
hist(airquality$Ozone, breaks=seq(0, 170, 10))

hist(airquality$Solar.R)
hist(airquality$Solar.R, breaks=seq(0, 350, 25))

hist(airquality$Wind)
hist(airquality$Wind, breaks=seq(0, 22, 1))

hist(airquality$Temp)
hist(airquality$Temp, breaks=seq(50, 100, 2))


## QQ Plot

qqnorm(airquality$Ozone, main = "Normal Q-Q Plot for Ozone")
qqline(airquality$Ozone)

qqnorm(airquality$Solar.R, main = "Normal Q-Q Plot for Solar Radiation")
qqline(airquality$Solar.R)

qqnorm(airquality$Wind, main = "Normal Q-Q Plot for Wind Speed")
qqline(airquality$Wind)

qqnorm(airquality$Temp, main = "Normal Q-Q Plot for Temperature")
qqline(airquality$Temp)


## Shapiro-Wilk Test

shapiro.test(airquality$Ozone)
shapiro.test(airquality$Solar.R)
shapiro.test(airquality$Wind)
shapiro.test(airquality$Temp)


## skewness and kurtosis

skewness(airquality$Ozone, na.rm = TRUE)
kurtosis(airquality$Ozone, na.rm = TRUE)

skewness(airquality$Solar.R, na.rm = TRUE)
kurtosis(airquality$Solar.R, na.rm = TRUE)

skewness(airquality$Temp, na.rm = TRUE)
kurtosis(airquality$Temp, na.rm = TRUE)

skewness(airquality$Wind, na.rm = TRUE)
kurtosis(airquality$Wind, na.rm = TRUE)


###########################################################################################################################################
## Data Transformations
###########################################################################################################################################

## Creating New Variables

airquality$log_ozone <- log10(airquality$Ozone)
airquality$sqrt_ozone <- sqrt(airquality$Ozone)

str(airquality)
head(airquality)
summary(airquality)

hist(airquality$log_ozone)
hist(airquality$sqrt_ozone)

qqnorm(airquality$log_ozone)
qqnorm(airquality$sqrt_ozone)

skewness(airquality$log_ozone, na.rm = TRUE)
kurtosis(airquality$log_ozone, na.rm = TRUE)
shapiro.test(airquality$log_ozone)

skewness(airquality$sqrt_ozone, na.rm = TRUE)
kurtosis(airquality$sqrt_ozone, na.rm = TRUE)
shapiro.test(airquality$sqrt_ozone)




