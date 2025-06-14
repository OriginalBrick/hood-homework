## This program shows in-class examples for BIFX 503 -- Simple inference -- t tests, confidence intervals, non-parametrics

## load libraries
library(datasets)
library(MASS)

###########################################################################################################################################
## Calculating confidence inervals
###########################################################################################################################################

library(Rmisc)

?CI

CI(cats$Bwt)

# calculate CIs for separate groups
# first, create subsets
cats_female <- cats[cats$Sex == "F",]  
cats_male <- cats[cats$Sex == "M",]

# alternatively, using dplyr package
library(dplyr)
cats_female <- filter(cats, Sex == "F")
cats_male <- filter(cats, Sex == "M")

CI(cats_female$Bwt)
CI(cats_male$Bwt)

###########################################################################################################################################
## Independent samples t test
###########################################################################################################################################

## Example: Cats dataset
## Do male and female cats differ in terms of body weight or heart weight?

## visualize group differences using boxplots
boxplot(Bwt ~ Sex, cats)
boxplot(Hwt ~ Sex, cats)

## test group differences using independent samples t tests
t.test(Bwt ~ Sex, cats)     ## note: unequal variances is default
t.test(Hwt ~ Sex, cats)
## For both tests, the p value is extremely small, much less than the cutoff value of 0.05
## So we reject the null hypothesis, and conclude that male and female cats are different


## Exercise: Crabs dataset in MASS package
## Use independent samples t tests to determine if there are any morphological dfferences by sex or variety

?crabs

# example: does frontal lobe differ by species?
boxplot(FL ~ sp, crabs)
t.test(FL ~ sp, crabs)

# repeat for other measurements (RW, CL, CW, BD) and for both sex and sp


###########################################################################################################################################
## Paired t test
###########################################################################################################################################

## Paired data -- corn

library(HistData)
?ZeaMays

## Note the difference in cross vs. self is already calculated
## A paired t test on this data is just a one-sample t test on the difference

boxplot(ZeaMays$diff)
# box exceeds zero, difference probably exceeds zero

# do one-sample t test on difference
# null hypothesis is difference = zero
# one-sided test - cross > self?
t.test(ZeaMays$diff, mu=0, alternative="greater")
# significant p=0.025
# agrees with boxplot

## Paired data -- sleep
## Does the mean increase in sleep differ for the two drugs?

?sleep
head(sleep)

# this data is in a different format - LONG rather than WIDE format
# do not calculate difference score in this case!

boxplot(extra ~ group, sleep)

t.test(extra ~ group, sleep, paired = TRUE)    ## p=0.0028

# what happens when we ignore the correlation?
t.test(extra ~ group, sleep, paired = FALSE)   ## NS, p=0.08
# test is no longer significant -- Why??
# we are not considering how much alike the groups are because the measurements are from the same subjects

## Exercise: Rabbits dataset in MASS package
## For which dose(s) of phenylbiguanide is there a difference between the test treatment and the control?
## Hint: use the subset argument in t.test

?Rabbit
Rabbit

t.test(BPchange ~ Treatment, Rabbit, paired = TRUE, subset = Dose == 6.25) 
# repeat for other doses
# what are your conclusions?

###########################################################################################################################################
## Nonparametrics
###########################################################################################################################################

boxplot(Bwt ~ Sex, cats)
boxplot(extra ~ group, sleep)
# both look right skewed

## Independent samples - Cats data
## Compare results parametric vs. non
t.test(Bwt ~ Sex, cats)
wilcox.test(Bwt ~ Sex, cats)
## both yield same conclusion

## Paired samples - Sleep data
t.test(extra ~ group, sleep, paired = TRUE)
wilcox.test(extra ~ group, sleep, paired = TRUE)
## both yield same conclusion





