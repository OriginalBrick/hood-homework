## This program shows in-class examples for BIFX 503
## One-way ANOVA and multiple comparisons

library(MASS)
library(multcomp)
library(dplyr)

setwd("~/Hood/BIFX 503 2021")

###########################################################################################################################################
## One-way ANOVA
###########################################################################################################################################

# visualize data
hist(chickwts$weight)
table(chickwts$feed)
boxplot(weight ~ feed, chickwts)

# descriptives by group
chk.grp <- group_by(chickwts, feed)
chk.sum <- summarize(chk.grp, mean_weight = mean(weight), sd_weight = sd(weight))
chk.sum

# ANOVA
summary(aov(weight ~ feed, chickwts))
# statistically significant effect of feed (p<0.001)

# visualize data
hist(PlantGrowth$weight)
table(PlantGrowth$group)
boxplot(weight ~ group, PlantGrowth)

# descriptives by group
plant.grp <- group_by(PlantGrowth, group)
plant.sum <- summarize(plant.grp, mean_weight = mean(weight), sd_weight = sd(weight))
plant.sum

# ANOVA
summary(aov(weight ~ group, PlantGrowth))
# statistically significant effect of group (p=0.0159)

###########################################################################################################################################
## Factorial ANOVA
###########################################################################################################################################

?ToothGrowth

## Interaction Plots

boxplot(len ~ supp + dose, ToothGrowth)

library(lattice)
xyplot(len ~ dose | supp, data=ToothGrowth, pch=20, cex=2, col="darkblue", type=c("p", "r"), lwd=3)

interaction.plot(x.factor=ToothGrowth$dose, trace.factor=ToothGrowth$supp, response=ToothGrowth$len, fun="mean", type="b", ylab="Tooth Length", xlab="Dose", pch=c(1,19))

# ggplot with boxplots plus overlaid interaction plot
library(ggplot2)
library(plyr)

ToothInt <- ddply(ToothGrowth, .(supp, dose), summarize, len=mean(len))  # calculate means for each supp/dose combo

ggplot(ToothGrowth, aes(x=factor(dose), y=len, color=supp)) + 
  geom_boxplot() + 
  geom_point(data=ToothInt, aes(y=len), position=position_dodge(width=0.75)) + 
  geom_line(data=ToothInt, aes(y=len, group=supp), position=position_dodge(width=0.75)) + 
  scale_x_discrete("Dose") + 
  scale_y_discrete("Response") + 
  theme_bw()

## Two way ANOVA using aov()
summary(aov(len ~ supp*dose, ToothGrowth))

## Simple Main Effects Analysis
ToothGrowth$dose_fac <- as.factor(ToothGrowth$dose)
aov.out <- aov(len ~ supp*dose_fac, ToothGrowth)

## Alternative method: lm()
tooth.main <- lm(len ~ supp + dose, data=ToothGrowth)
tooth.intx <- lm(len ~ supp*dose, data=ToothGrowth)
anova(tooth.main, tooth.intx)
## partial F test shows interaction term adds value to model

###########################################################################################################################################
## Simple Main Effects Analysis
###########################################################################################################################################

# make factor variable from dose variable
ToothGrowth$dose_fac <- as.factor(ToothGrowth$dose)

## cell means
aov.out <- aov(len ~ supp*dose_fac, ToothGrowth)
model.tables(aov.out, type="means", se = TRUE)

## simple main effects tests
TukeyHSD(aov.out)
plot(TukeyHSD(aov.out))

## Rat pup example: display data
library(MASS)
?genotype
str(genotype)

## Interaction plots
interaction.plot(x.factor=genotype$Litter, trace.factor=genotype$Mother, response=genotype$Wt, fun="mean", type="b", ylab="Average Weight Gain (g)", xlab="Litter Genotype", pch=c(1,19))

ggplot(genotype, aes(x=Litter, y=Wt, color=Litter)) + geom_boxplot() + facet_grid(. ~ Mother)

## factorial ANOVA
summary(aov(Wt ~ Litter*Mother, genotype))      ## No signficant interaction -- no need for simple main effects analysis

## main effects only, since no interaction
summary(aov(Wt ~ Litter + Mother, genotype))    ## Effect of mother genotype is significant but litter genotype is not


###########################################################################################################################################
## ANCOVA
###########################################################################################################################################

chol <- read.csv("cholesterol.csv")

str(chol)

# create low/high baseline cholesterol variable
chol$chol.bl[chol$baseline.chol < median(chol$baseline.chol)] <- "Low BL"
chol$chol.bl[chol$baseline.chol >= median(chol$baseline.chol)] <- "High BL"

ggplot(chol, aes(x=tx, y=chol.8weeks)) + geom_boxplot()

summary(aov(chol.8weeks ~ tx, chol))   ## no treatment effect

ggplot(chol, aes(x=tx, y=chol.8weeks)) + geom_boxplot() + facet_grid(. ~ chol.bl)

summary(aov(chol.8weeks ~ tx + baseline.chol, chol))  ## now treatment is significant





