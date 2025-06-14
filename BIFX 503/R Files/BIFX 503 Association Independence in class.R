## This program shows in-class examples for BIFX 503
## Association and Independence (correlation, chi square, fisher's exact)

library(datasets)
library(MASS)

setwd("~/Hood/BIFX 503 2021")

###########################################################################################################################################
## Scatterplots
###########################################################################################################################################

## Scatterplots -- cat data

# Review - Using base R
plot(cats$Bwt, cats$Hwt, xlim=c(2, 4), ylim=c(0, 25), pch=20, cex=2, col="darkblue", xlab="Cat Body Weight (kg)", ylab="Cat Heart Weight (g)")

# Using ggplot

library(ggplot2)

# Basic scatterplot
ggplot(cats, aes(x=Bwt, y=Hwt)) + geom_point() + xlab("Cat Body Weight (kg)") + ylab("Cat Heart Weight (g)")

# Scatterplot color by group
ggplot(cats, aes(x=Bwt, y=Hwt, color=Sex)) + geom_point() + xlab("Cat Body Weight (kg)") + ylab("Cat Heart Weight (g)")
# Notice legend is generated automatically

# Scatterplot panel by group
ggplot(cats, aes(x=Bwt, y=Hwt)) + geom_point() + facet_grid(. ~ Sex) + xlab("Cat Body Weight (kg)") + ylab("Cat Heart Weight (g)")
ggplot(cats, aes(x=Bwt, y=Hwt)) + geom_point() + facet_grid(Sex ~ .) + xlab("Cat Body Weight (kg)") + ylab("Cat Heart Weight (g)")


###########################################################################################################################################
## Correlation
###########################################################################################################################################

cor(cats$Bwt, cats$Hwt)

cor.test(cats$Bwt, cats$Hwt)

cor.test( ~ Bwt + Hwt, cats, subset = Sex == "F")
cor.test( ~ Bwt + Hwt, cats, subset = Sex == "M")

cor.test(cats$Bwt, cats$Hwt, na.action = "na.exclude")

# Class Exercise #1

par(mfrow=c(1,3))
plot(trees$Height, trees$Girth, pch=20, cex=2, col="darkblue", xlab = "Tree Height (ft)", ylab = "Tree Girth (in)")
plot(trees$Girth, trees$Volume, pch=20, cex=2, col="darkblue", xlab = "Tree Girth (in)", ylab = "Tree Volume (cu ft)")
plot(trees$Height, trees$Volume, pch=20, cex=2, col="darkblue", xlab = "Tree Height (ft)", ylab = "Tree Volume (cu ft)")
par(mfrow=c(1,1))

cor.test( ~ Height + Girth, trees)
cor.test( ~ Girth + Volume, trees)
cor.test( ~ Height + Volume, trees)

cor(trees)

###########################################################################################################################################
## Visualizing correlation -- other methods
###########################################################################################################################################

# Base R -- pairs()

pairs(trees)

# Base R -- heatmap()

iris.cor <- cor(iris[,1:4])
iris.cor

heatmap(iris.cor, symm=TRUE, revC=TRUE, margins=c(10,10))

heatmap(iris.cor, symm=TRUE, revC=TRUE, margins=c(10,10), col=terrain.colors(256))

# Specialty package -- ggcorrplot

library(ggcorrplot)

ggcorrplot(iris.cor, method="circle")

###########################################################################################################################################
## contingency tables
###########################################################################################################################################

library(MASS)

?birthwt
summary(birthwt)

#Class Exercise #2
table(birthwt$low)
table(birthwt$smoke)
table(birthwt$ptl)
table(birthwt$ht)
table(birthwt$ftv)

prop.table(table(birthwt$low))
prop.table(table(birthwt$smoke))
prop.table(table(birthwt$ptl))
prop.table(table(birthwt$ht))
prop.table(table(birthwt$ftv))

prop.table(table(birthwt$low, birthwt$smoke), 2)
prop.table(table(birthwt$low, birthwt$ptl), 2)
prop.table(table(birthwt$low, birthwt$ht), 2)
prop.table(table(birthwt$low, birthwt$ftv), 2)


###########################################################################################################################################
## Contingency tables, frequency analysis, chi square, Fisher's exact test
###########################################################################################################################################

# Class Exercise #3

table(birthwt$low, birthwt$smoke)
chisq.test(table(birthwt$low, birthwt$smoke))
fisher.test(table(birthwt$low, birthwt$smoke))

table(birthwt$low, birthwt$ptl)
chisq.test(table(birthwt$low, birthwt$ptl))
fisher.test(table(birthwt$low, birthwt$ptl))

table(birthwt$low, birthwt$ht)
chisq.test(table(birthwt$low, birthwt$ht))
fisher.test(table(birthwt$low, birthwt$ht))

table(birthwt$low, birthwt$ftv)
chisq.test(table(birthwt$low, birthwt$ftv))
fisher.test(table(birthwt$low, birthwt$ftv))


