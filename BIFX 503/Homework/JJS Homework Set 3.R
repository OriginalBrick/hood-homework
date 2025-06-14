# J. Jedediah Smith
# Homework Set No.3
# BIFX 503-1
# 10/21/2021

library(MASS)
library(rpart)
library(partykit)
library(TH.data)

library(HSAUR3)
library(coin)
library(dplyr)
library(survival)

### QUESTION 1 ###
# Series of bivariate logistic regression models. Use type as dependent. Use npreg, bp, skin, bmi, and age as independents.

mod_npreg <- glm(type ~ npreg, data = Pima.tr, family = binomial()) # Fit
summary(mod_npreg)      # P-Value
exp(coef(mod_npreg))    # Exponentiated Coefficient
exp(confint(mod_npreg)) # Exponentiated Confidence Interval

mod_bp <- glm(type ~ bp, data = Pima.tr, family = binomial()) # Fit
summary(mod_bp)      # P-Value
exp(coef(mod_bp))    # Exponentiated Coefficient
exp(confint(mod_bp)) # Exponentiated Confidence Interval

mod_skin <- glm(type ~ skin, data = Pima.tr, family = binomial()) # Fit
summary(mod_skin)      # P-Value
exp(coef(mod_skin))    # Exponentiated Coefficient
exp(confint(mod_skin)) # Exponentiated Confidence Interval

mod_bmi <- glm(type ~ bmi, data = Pima.tr, family = binomial()) # Fit
summary(mod_bmi)      # P-Value
exp(coef(mod_bmi))    # Exponentiated Coefficient
exp(confint(mod_bmi)) # Exponentiated Confidence Interval

mod_age <- glm(type ~ age, data = Pima.tr, family = binomial()) # Fit
summary(mod_age)      # P-Value
exp(coef(mod_age))    # Exponentiated Coefficient
exp(confint(mod_age)) # Exponentiated Confidence Interval


### QUESTION 2 ###
# Should any of the variables be removed?

fit_a <- glm(type ~ age + bmi, data = Pima.tr, family = binomial())
fit_b <- glm(type ~ age + npreg, data = Pima.tr, family = binomial())
fit_c <- glm(type ~ age + skin, data = Pima.tr, family = binomial())
fit_d <- glm(type ~ age + bp, data = Pima.tr, family = binomial())

anova(mod_age, fit_a, test="Chisq")
anova(mod_age, fit_b, test="Chisq") # Not Significant
anova(mod_age, fit_c, test="Chisq")
anova(mod_age, fit_d, test="Chisq") # Not Significant

# What is the final model?
mod_final <- glm(type ~ age + bmi + skin, data = Pima.tr, family = binomial())
exp(coef(mod_final))
exp(confint(mod_final))

# How well does the model fit the data? Use ROC curve.
library(pROC)
par(mfrow=c(1,2))
logpred1 <- predict(mod_age, type="response")
roccurve1 <- roc(Pima.tr$type ~ logpred1, title = "Age (Alone)")
roccurve1  ## AUC = 0.7333
plot(roccurve1)

logpred2 <- predict(mod_final, type="response", title = "Age + BMI + Skin")
roccurve2 <- roc(Pima.tr$type ~ logpred2)
roccurve2  ## AUC = 0.7633
plot(roccurve2)
par(mfrow=c(1,1))


### QUESTION 3 ###
# Fit initial recursive partitioning model with all 5 predictors. Prune if needed.

# Initial Model
pima_rpart <- rpart(type ~ age + bmi + npreg + skin + bp, data = Pima.tr, control = rpart.control(minsplit=10))
plot(as.party(pima_rpart), tp_args = list(id = FALSE))
pima_rpart$cptable # xerror lowest for 2 nsplit.

# Pruned Model
pima_opt <- which.min(pima_rpart$cptable[, "xerror"]) # Confirms 2 splits.
pima_cpval <- pima_rpart$cptable[pima_opt, "CP"] # Identifies tree with minimized prediction error.
pima_prune <- prune(pima_rpart, cp = pima_cpval) # Prunes data tree.
plot(as.party(pima_prune), tp_args = list(id = FALSE)) # Plots pruned data tree.

## Use Bagging on Pruned Model
trees <- vector(mode="list", length=25)
n <- nrow(Pima.tr)
bootsamples <- rmultinom(length(trees), n, rep(1,n)/n)
mod <- pima_prune
for (i in 1:length(trees))
  trees[[i]] <- update(mod, weights=bootsamples[,i])
table(sapply(trees, function(x) as.character(x$frame$var[1])))

## Estimate the conditional probability of diabetes, given covariates for each person in dataset
typeprob <- matrix(0, nrow=n, ncol=length(trees))
for (i in 1:length(trees)) {
  typeprob[,i] <- predict(trees[[i]], newdata=Pima.tr)[,1]
  typeprob[bootsamples[,i] > 0, i] <- NA
}

## Average the estimates and assign "diabetes" when the average probability is more than half
avg <- rowMeans(typeprob, na.rm = TRUE)
predictions <- factor(ifelse(avg > 0.5, "Yes", "No"))
predtab <- table(predictions, Pima.tr$type)
predtab

## Probability of a correct prediction of diabetes type (%)
round(predtab[1,1]/colSums(predtab)[1]*100)

## Probability of a correct prediction of non-diabetes type (%)
round(predtab[2,2]/colSums(predtab)[2]*100)


### QUESTION 4 ###
# Visualize the relationship between treatments and visual loss using a Kaplan-Meier plot.

plot(survfit(Surv(time, status) ~ trt, data=diabetic), xlab="Months", ylab="Probability of Non-Blindness", lty=c(1,2))


### QUESTION 5 ###
# Calculate the median survival time for each treatment group and compare.

survfit(Surv(time, status) ~ trt, data=diabetic)


### QUESTION 6 ###
# Use a log-rank test to test the hypothesis that laser treatment affects time to visual loss.

logrank_test(Surv(time, status) ~ factor(trt), diabetic)


### QUESTION 7 ###
# Create a variable called juvenile that is equal to 1 for patients under the age of 20, and equal to zero otherwise.  
diabetic$juvenile <- ifelse(diabetic$age >= 20, 0, 1)

# Run a Cox proportional hazards model to determine if there is an interaction between juvenile diabetes and laser treatment.
summary(coxph(Surv(time, status) ~ juvenile * trt, data=diabetic))

# Visualizing the data.
j0 <- filter(diabetic, juvenile == "0")
j1 <- filter(diabetic, juvenile == "1")

par(mfrow=c(1,2))
plot(survfit(Surv(time, status) ~ trt, data=j0), ylab="Probability of Non-Blindness", xlab="Months", main="Adult", lty=c(2,1))
plot(survfit(Surv(time, status) ~ trt, data=j1), ylab="Probability of Non-Blindness", xlab="Months", main="Juvenile", lty=c(2,1))
par(mfrow=c(1,1))
