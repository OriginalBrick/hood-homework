## This program shows in-class examples for BIFX 503
## Repeated measures analysis

setwd("~/Hood/BIFX 503 2021")

library(MASS)
library(ggplot2)
library(dplyr)
library(nlme)
library(lme4)
library(geepack)
library(multcomp)

###########################################################################################################################################
## One Way Repeated Measures ANOVA
###########################################################################################################################################

## data sleepstudy from package lme4 -- effects of sleep deprivation (days) on reaction time
str(sleepstudy)

ggplot(sleepstudy, aes(x=Days, y=Reaction, group=Subject)) + geom_line()
boxplot(Reaction ~ Days, sleepstudy)

library(afex)
?aov_ez
summary(aov_ez(id="Subject", dv="Reaction", sleepstudy, within="Days"))

# post hoc tests - pairwise comparisons of time points
# use Bonferroni correction since sphericity assumption is violated

pairwise.t.test(sleepstudy$Reaction, sleepstudy$Days, paired=TRUE, p.adjust.method = "bonferroni")

###########################################################################################################################################
## Mixed ANOVA (between/within)
###########################################################################################################################################

## Dataset cholesterol

cholesterol <- read.csv("Cholesterol_long.csv")
str(cholesterol)

# spaghetti plot
ggplot(cholesterol, aes(x=Weeks, y=Cholesterol, group=ID, colour=Margarine)) + geom_line()

# interaction plot
interaction.plot(x.factor=cholesterol$Weeks, trace.factor=cholesterol$Margarine, response=cholesterol$Cholesterol, fun="mean", type="b", ylab="Cholesterol", xlab="Weeks", pch=c(1,19))

# anova
summary(aov_ez(id="ID", dv="Cholesterol", cholesterol, within="Weeks", between="Margarine"))
# margarine NS, effect of weeks and interaction both significant


## Second example: CO2
?CO2
head(CO2)

ggplot(CO2, aes(x=conc, y=uptake, color=Treatment)) + geom_point() + facet_grid(. ~ Type) + geom_smooth(se=FALSE)

## limit to concentrations above 300 -- "saturation"
CO2sat <- CO2[CO2$conc > 300, ]

ggplot(CO2sat, aes(x=conc, y=uptake, color=Treatment)) + geom_point() + facet_grid(. ~ Type) + geom_smooth(se=FALSE)
boxplot(uptake ~ Type + Treatment, CO2sat)
interaction.plot(x.factor=CO2sat$Treatment, trace.factor=CO2sat$Type, response=CO2sat$uptake, fun="mean", type="b", ylab="Uptake", xlab="Treatment", pch=c(1,19))
interaction.plot(x.factor=CO2sat$Type, trace.factor=CO2sat$Treatment, response=CO2sat$uptake, fun="mean", type="b", ylab="Uptake", xlab="Treatment", pch=c(1,19))

summary(aov_ez(id="Plant", dv="uptake", CO2sat, between=c("Treatment", "Type")))

# Note get same results with this method, since there are no tests of within subject effects
summary(aov(uptake ~ Treatment*Type + Error(Plant), CO2sat))


###########################################################################################################################################
## Repeated Measures Regression
## One independent variable (time)
###########################################################################################################################################

## Example #1 - Sleep Deprivation

## Marginal model with GEE
# Evaluate correlation structure looking at SE

gee1 <- geeglm(Reaction ~ Days, data=sleepstudy, id=Subject, corstr="exchangeable")
summary(gee1)

gee2 <- geeglm(Reaction ~ Days, data=sleepstudy, id=Subject, corstr="ar1")
summary(gee2)

gee3 <- geeglm(Reaction ~ Days, data=sleepstudy, id=Subject, corstr="unstructured")
summary(gee3)


?lmer
# Note: you do not choose the correlation structure with this method
# Within-subject correlation is addressed using random effects

## Random intercept vs. random intercept plus random slope
lmer1 <- lmer(Reaction ~ Days + (1 | Subject), data=sleepstudy)      # random intercept
lmer2 <- lmer(Reaction ~ Days + (Days | Subject), data=sleepstudy)   # random slope
AIC(lmer1)
AIC(lmer2)
anova(lmer1, lmer2)
cftest(lmer2)
# conclusion - random intercept and random slope improves fit

## "Naive" model ignoring correlation
summary(lm(Reaction ~ Days, sleepstudy))

###########################################################################################################################################
## Repeated Measures Regression
## Treatment + Time + Interaction
###########################################################################################################################################

## Example #2 - Cholesterol Study

cholesterol <- read.csv("Cholesterol_long.csv")
str(cholesterol)

cholesterol <- arrange(cholesterol, ID, Weeks)

## Marginal model using GEE
gee1 <- geeglm(Cholesterol ~ Margarine*Weeks, data=cholesterol, id=ID, corstr="exchangeable")
summary(gee1)

gee1 <- geeglm(Cholesterol ~ Margarine*Weeks, data=cholesterol, id=ID, corstr="ar1")
summary(gee1)

gee1 <- geeglm(Cholesterol ~ Margarine*Weeks, data=cholesterol, id=ID, corstr="unstructured")
summary(gee1)

## Random intercept vs. random intercept plus random slope
lmer1 <- lmer(Cholesterol ~ Margarine*Weeks + (1 | ID), data=cholesterol)      # random intercept
lmer2 <- lmer(Cholesterol ~ Margarine*Weeks + (Weeks | ID), data=cholesterol)  # random slope
AIC(lmer1)
AIC(lmer2)
anova(lmer1, lmer2)
summary(lmer1)
cftest(lmer1)

## Naive model ignoring within-subject correlation
summary(lm(Cholesterol ~ Margarine*Weeks, data=cholesterol))


## Repeated measures logistic regression
library(HSAUR3)
?respiratory
str(respiratory)

# data manipulations
resp <- subset(respiratory, month > "0")    # month is an ordered factor, not numeric
resp$baseline <- rep(subset(respiratory, month == "0")$status, rep(4,111))
resp$nstat <- as.numeric(resp$status == "good")
resp$month <- resp$month[, drop = TRUE]
head(respiratory, n=15)
head(resp, n=10)

# Marginal model with exchangeable correlation
resp_gee <- geeglm(nstat ~ centre + treatment + gender + baseline + age, data=resp, id=subject, family="binomial", corstr="exchangeable")
summary(resp_gee)
exp(resp_gee$coefficients)

# Random effects model (random intercept)
resp_lmer <- glmer(status ~ baseline + month + treatment + gender + age + centre + (1 | subject), data=resp, family = binomial())
summary(resp_lmer)
exp(fixef((resp_lmer)))

# Naive model ignoring within-subject correlation
resp_glm <- glm(status ~ centre + treatment + gender + baseline + age, data=resp, family="binomial")
summary(resp_glm)
exp(coef(resp_glm))

