## This program shows in class examples for BIFX 503 Regression material

setwd("~/Hood/BIFX 503 2021")

library(MASS)

###########################################################################################################################################
## simple linear regression
###########################################################################################################################################

plot(Hwt ~ Bwt, cats)

lm(Hwt ~ Bwt, cats)

summary(lm(Hwt ~ Bwt, cats))
confint(lm(Hwt ~ Bwt, cats))

summary(lm(Hwt ~ Bwt, cats, subset = Sex == "F"))
summary(lm(Hwt ~ Bwt, cats, subset = Sex == "M"))

## residuals plots
plot(lm(Hwt ~ Bwt, cats), which=1)
plot(lm(Hwt ~ Bwt, cats), which=2)
plot(lm(Hwt ~ Bwt, cats), which=4)
# observation 144 may have undue influence
# this is a heavy cat with an unusually large heart

## DIY residuals plot
catfit <- lm(Hwt ~ Bwt, cats)
catres <- resid(catfit)
plot(cats$Bwt, catres, xlab = "Cat Body Weight (kg)", ylab = "Residuals")


## trees

# scatterplot matrix
plot(trees)

fit1 <- lm(Girth ~ Height, trees)
summary(fit1)
plot(fit1, which=1)

fit2 <- lm(Volume ~ Girth, trees)
summary(fit2)
plot(fit2, which = 1)

fit3 <- lm(Volume ~ Height, trees)
summary(fit3)
plot(fit3, which = 1)


## cats
## create binary gender variable a.k.a. "dummy" variable

summary(lm(Bwt ~ Sex, cats))

cats$Female[cats$Sex == "M"] <- 0
cats$Female[cats$Sex == "F"] <- 1
table(cats$Sex, cats$Female)

summary(lm(Bwt ~ Female, cats))


###########################################################################################################################################
## MLR -- Galton Data
###########################################################################################################################################

galton.sub <- read.csv("GaltonSub.csv")

galton.sub$male_child[galton.sub$gender == "male"] <- 1
galton.sub$male_child[galton.sub$gender == "female"] <- 0
table(galton.sub$gender, galton.sub$male_child)

summary(lm(childHeight ~ gender, galton.sub))
summary(lm(childHeight ~ male_child, galton.sub))

## Which is the stronger predictor -- mother's or father's height?
summary(lm(childHeight ~ mother, galton.sub))
summary(lm(childHeight ~ father, galton.sub))
summary(lm(childHeight ~ mother + father, galton.sub))

## scatter plots by 3rd variable
library(lattice)
xyplot(childHeight ~ mother | gender, data=galton.sub, pch=20, cex=2, col="darkblue", type=c("p", "r"), lwd=3)
xyplot(childHeight ~ father | gender, data=galton.sub, pch=20, cex=2, col="darkblue", type=c("p", "r"), lwd=3)
## looks like dad height is the stronger predictor of child height but this does not vary by gender

## interaction by gender?
summary(lm(childHeight ~ mother + father + male_child, galton.sub))
summary(lm(childHeight ~ mother + father + male_child + mother*male_child + father*male_child, galton.sub))
# neither interaction term is significant
# this confirms the pattern we see in the plots

## Partial F Tests
fit1 <- lm(childHeight ~ father + mother + gender + children, galton.sub)
fit2 <- lm(childHeight ~ father + mother + gender, galton.sub)
anova(fit1, fit2)
# number of chidren does not add value to the model

fit3 <- lm(childHeight ~ father + mother, galton.sub)
anova(fit2, fit3)

## Clouds data

library(HSAUR)
?clouds
clouds
summary(clouds)
# see textbook for figures showing the relationship between rainfall and each variable

# bivariate SLR models
summary(lm(rainfall ~ seeding, clouds))    # p=0.72
summary(lm(rainfall ~ time, clouds))       # p=0.014
summary(lm(rainfall ~ sne, clouds))        # p=0.048
summary(lm(rainfall ~ cloudcover, clouds)) # p=0.20
summary(lm(rainfall ~ prewetness, clouds)) # p=0.42
summary(lm(rainfall ~ echomotion, clouds)) # p=0.113
# only two were significant

summary(lm(rainfall ~ time + sne, clouds))
# only time is significant
# does adding sne improve fit?
fit1 <- lm(rainfall ~ time, clouds)
fit2 <- lm(rainfall ~ time + sne, clouds)
anova(fit1, fit2)
# no it does not

###########################################################################################################################################
## Polynomial regression using trees data
###########################################################################################################################################

?trees

library(ggplot2)
ggplot(trees, aes(x=Girth, y=Volume)) + geom_point() + geom_smooth(method=lm, se=FALSE)
ggplot(trees, aes(x=Girth, y=Volume)) + geom_point(cex=3) + geom_smooth(se=FALSE)
# the relationship isn't entirely linear

# create new variable - girth squared
trees$Girth.squared <- trees$Girth^2

# compare model fit - linear vs polynomial
fit1 <- lm(Volume ~ Girth, trees)
summary(fit1)

fit2 <- lm(Volume ~ Girth + Girth.squared, trees)
summary(fit2)

anova(fit1, fit2)
# polynomial better fit

