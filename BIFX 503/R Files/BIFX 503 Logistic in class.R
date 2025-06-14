## This program shows in class examples for BIFX 503 - Logistic Regression

setwd("~/Hood/BIFX 503 2021")

library(HSAUR3)
library(coin)
library(dplyr)

## Blood screening example

# get familiar with data
?plasma
head(plasma)
summary(plasma)

par(mfrow=c(1,2))  # 2 plots per page, side by side
boxplot(fibrinogen ~ ESR, plasma)
boxplot(globulin ~ ESR, plasma)
# higher values of each protein are associated with ESR>20

hist(plasma$fibrinogen)  # right skewed
hist(plasma$globulin)    # possibly right skewed
cor.test(plasma$fibrinogen, plasma$globulin, method="spearman")  # Not associated

mod1 <- glm(ESR ~ fibrinogen, data = plasma, family = binomial())
summary(mod1)       # significant p=0.0425 
exp(coef(mod1))
exp(confint(mod1))

mod2 <- glm(ESR ~ globulin, data = plasma, family = binomial())
summary(mod2)       # not significant p=0.17
exp(coef(mod2))
exp(confint(mod2))

mod3 <- glm(ESR ~ fibrinogen + globulin, data = plasma, family = binomial())
summary(mod3)       # fibrinogen is significant p=0.049 while globulin is not p=0.19
exp(coef(mod3))
exp(confint(mod3))

anova(mod1, mod3, test = "Chisq")

library(pROC)
logpred <- predict(mod1, type="response")
roccurve <- roc(plasma$ESR ~ logpred, title = "Fibrinogen Alone")
roccurve  ## AUC = 0.71
plot(roccurve)

logpred <- predict(mod3, type="response", title = "Fibrinogen + Globulin")
roccurve <- roc(plasma$ESR ~ logpred)
roccurve  ## AUC = 0.81
plot(roccurve)

par(mfrow=c(1,1))


