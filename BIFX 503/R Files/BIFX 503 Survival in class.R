## This program shows in class examples for BIFX 503 Survival Analysis

setwd("~/Hood/BIFX 503 2021")

library(HSAUR3)
library(coin)
library(dplyr)
library(survival)

###########################################################################################################################################
## Lung cancer data
###########################################################################################################################################

?lung

# Kaplan-Meier survival plot
plot(survfit(Surv(time, status) ~ 1, data=lung), xlab="Days", ylab="Overall Survival Probability")

# Estimating median survival time
survfit(Surv(time, status) ~ 1, data=lung)

# Comparing survival curves
plot(survfit(Surv(time, status) ~ sex, data=lung), xlab="Days", ylab="Overall Survival Probability", lty=c(1,2))
survfit(Surv(time, status) ~ sex, data=lung)

survdiff(Surv(time, status) ~ sex, lung)
logrank_test(Surv(time, status) ~ factor(sex), lung)

# Cox PH regression
summary(coxph(Surv(time, status) ~ sex, data=lung))


# rpart tree based method
library(rpart)
library(partykit)

lung_ctree <- ctree(Surv(time, status) ~ ., data = lung)
lung_ctree
plot(lung_ctree, tp_args = list(id = FALSE))


###########################################################################################################################################
## Glioma treatment data
###########################################################################################################################################

?glioma
head(glioma)
summary(glioma)

survfit(Surv(time, event) ~ group, data=glioma)
# median survival time is 12.5 in control group
# can't be calculated in RIT group (exceeds 12.5)

plot(survfit(Surv(time, event) ~ group, data=glioma), ylab="Probability", xlab="Survival Time (Months)", lty=c(2,1))

summary(coxph(Surv(time, event) ~ group, data=glioma))
## the negative coefficient for the RIT group means that the risk of death is lower for this group
## RIT group >6x as likely to survive

summary(coxph(Surv(time, event) ~ group + age + sex + histology, data=glioma))
## RIT group >11x as likely to survive after adjusting for demographics & histology

coxg <- coxph(Surv(time, event) ~ group + age + sex + histology, data=glioma)
cox.zph(coxg)
# some evidence of time varying effects for sex

g3 <- filter(glioma, histology == "Grade3")
g4 <- filter(glioma, histology == "GBM")

par(mfrow=c(1,2))
plot(survfit(Surv(time, event) ~ group, data=g3), ylab="Probability", xlab="Survival Time (Months)", lty=c(2,1))
plot(survfit(Surv(time, event) ~ group, data=g4), ylab="Probability", xlab="Survival Time (Months)", lty=c(2,1))
par(mfrow=c(1,1))

# stratified Cox regression
logrank_test(Surv(time, event) ~ group | histology, data=glioma, distribution = approximate(B = 10000))















