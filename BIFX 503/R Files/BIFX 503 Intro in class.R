## This program shows in-class examples for BIFX 503 Intro to R (Week 1)

###########################################################################################################################################
## Introductory stuff
###########################################################################################################################################
  
a <- c(1, 2, 3)
b <- c(4, 5, 6)
c <- rbind(a, b)

a <- 2
b <- 10
c <- a + b
  
d <- c(1, 2, 3, 4, 5)
e <- c(1, 2, 3, 4, 5)
f <- rbind(d, e)
g <- c(9,9)
h <- cbind(f, g)
  
numvar <- factor(c("Zero", "One", "Two", "Three"))
numvar
  
numvar <- factor(numvar, levels=c("Zero", "One", "Two", "Three+"), ordered=TRUE)
numvar
  
numvar <- factor(c("Zero", "One", "Two", "Three"), levels=c("Zero", "One", "Two", "Three+"), ordered=TRUE)
numvar
  
numbers <- c(1, 2, 3, 4, 5)
text <- c("a", "b", "c", "d", "e")
both <- data.frame(numbers, text)
str(both)
both

# Class Exercise #1  
numbers <- c(1, 2, 3, 4, 5)
fact <- factor(numbers, levels=c(1, 2, 3, 4, 5), ordered=TRUE)
text <- as.character(numbers)
all3 <- data.frame(numbers, fact, text)
str(all3)
  
fact <- factor(fact, levels=c("1", "2", "3", "4", "5"), ordered=TRUE)
fact
class(fact)
  

###########################################################################################################################################
## Working with Data
###########################################################################################################################################

## getting data into R

setwd("~/Hood/BIFX 503 2021")
treedf <- read.csv("trees.csv")

## Subsetting a vector

x <- c("a", "b", "c", "c", "d", "a")
x[1]
x[1:4]
x[c(1, 3, 4)]

## Subsetting a matrix

x <- matrix(1:6, 2, 3)
x[1,2]
x[1,]
x[,2]

## Subsetting a list

x <- list(foo = 1:4, bar = 0.5)
x[[1]]
x[["bar"]]
x$bar

## Missing values

x <- c(1, 2, NA, 4, NA, 5)
bad <- is.na(x)
bad
x[!bad]
na.omit(x)

# Class Exercise #2
?mtcars
mtcars

# Class Exercise #3
subcars <- mtcars[, 1:4]
subcars

subcars <- mtcars[, c(2,4,6)]
subcars

subcars <- mtcars[mtcars$cyl == 6,]  
subcars

subcars <- mtcars[mtcars$mpg > 25,]  
subcars

## Merging

# Class Exercise #4
transmission <- c("Automatic", "Manual")
am <- c(0, 1)
trans <- data.frame(am, transmission)
trans    

newdata <- merge(mtcars, trans, by = "am")
str(newdata)
newdata


###########################################################################################################################################
## Descriptive Statistics
###########################################################################################################################################
  
## univariate

nrow(mtcars)
ncol(mtcars)
str(mtcars)
head(mtcars)
head(mtcars, n=10)
tail(mtcars)

summary(mtcars)
table(mtcars$cyl)
prop.table(table(mtcars$cyl))

hist(mtcars$mpg)
boxplot(mtcars$mpg)

# Class Exercise #5
?trees
nrow(trees)
ncol(trees)
head(trees)
tail(trees)
summary(trees)

par(mfrow=c(1,3))
hist(trees$Girth)
hist(trees$Height)
hist(trees$Volume)

boxplot(trees$Girth)
boxplot(trees$Height)
boxplot(trees$Volume)
par(mfrow=c(1,1))

## bivariate summaries

# tables - alternate syntax, similar result
table(mtcars[,c("am", "cyl")])
table(mtcars$am, mtcars$cyl)

prop.table(table(mtcars[,c("am", "cyl")]), 1)
prop.table(table(mtcars[,c("am", "cyl")]), 2)
  
## summary stats, by group
aggregate(mpg ~ am, mtcars, mean, na.action=na.omit)
aggregate(mpg ~ cyl, mtcars, mean, na.action=na.omit)
aggregate(mpg ~ am + cyl, mtcars, mean, na.action=na.omit)

boxplot(mpg ~ am, mtcars)
boxplot(mpg ~ cyl, mtcars)
boxplot(mpg ~ am + cyl, mtcars)

#Class Exercise #6
sepl <- aggregate(Sepal.Length ~ Species, iris, mean)
sepw <- aggregate(Sepal.Width ~ Species, iris, mean)
petl <- aggregate(Petal.Length ~ Species, iris, mean)
petw <- aggregate(Petal.Width ~ Species, iris, mean)
iris.sum <- merge(sepl, sepw, by="Species")
iris.sum <- merge(iris.sum, petl, by="Species")
iris.sum <- merge(iris.sum, petw, by="Species")
iris.sum
# to save this as csv file
write.csv(iris.sum, "iris_sum.csv")

par(mfrow=c(2,2))
boxplot(Sepal.Length ~ Species, iris)
boxplot(Sepal.Width ~ Species, iris)
boxplot(Petal.Length ~ Species, iris)
boxplot(Petal.Width ~ Species, iris)
par(mfrow=c(1,1))

  
###########################################################################################################################################
## Graphics
###########################################################################################################################################

## Scatterplot example

set.seed(1234)
a <- seq(1:100) + 0.1*seq(1:100)*sample(c(1:10) , 100 , replace=TRUE)
b <- seq(1:100) + 0.2*seq(1:100)*sample(c(1:10) , 100 , replace=TRUE)
head(a, n=10)
head(b, n=10)

plot(a, b)
plot(a, b, pch=20)
plot(a, b, pch=20, xlim=c(0,200), ylim=c(0,200))
plot(a, b, xlim=c(10,200), ylim=c(10,200), pch=20, col="blue")
plot(a, b, xlim=c(10,200), ylim=c(10,200), pch=20, col="blue", cex=3)
plot(a, b, xlim=c(10,200), ylim=c(10,200), pch=20, col="blue", cex=3+(a/30))
plot(a, b, xlim=c(10,200), ylim=c(10,200), pch=20, cex=3+(a/30) , col=rgb(a/300,b/300,0.9,0.9) )

## Scatterplot -- iris data
# Class example #7
plot(iris$Sepal.Length, iris$Sepal.Width, xlim=c(4, 8), ylim=c(2, 4),pch=20, cex=2, col=iris$Species, xlab="Sepal Length", ylab="Sepal Width")
legend(7, 2.5, pch=20, cex=1.5, c("Setosa", "Versicolor", "Virginica"), col=c("black", "red", "green"))

## Note to save, click on "Export", "Save as image"
## Also option to copy to clipboard without saving in a file

## using code not menu
png("outplot.png")

plot(iris$Sepal.Length, iris$Sepal.Width, xlim=c(4, 8), ylim=c(2, 4),pch=20, cex=2, col=iris$Species, xlab="Sepal Length", ylab="Sepal Width")
legend(7, 2.5, pch=20, cex=1.5, c("Setosa", "Versicolor", "Virginica"), col=c("black", "red", "green"))

dev.off()

## note several options available, e.g. pdf, jpg, ....

## Line plot
plot(height ~ age, data=Loblolly, type="l", lwd=2, subset = Seed == 329)

## Lattice plot

library(lattice)

xyplot(mpg ~ cyl | transmission, data=newdata, pch=20, cex=2)

# Class Exercise #8
xyplot(Sepal.Width ~ Sepal.Length | Species, data=iris)

## Bar chart

# plain
counts <- table(newdata$cyl)
barplot(counts, col="darkblue")

# stacked
counts <- table(newdata$transmission, newdata$cyl)
barplot(counts, col=c("darkblue", "firebrick"))
legend("top", legend=rownames(counts), fill=c("darkblue", "firebrick"))

# proportional stacked
counts <- prop.table(table(newdata$transmission, newdata$cyl), 2)
barplot(counts, col=c("darkblue", "firebrick"))
legend("top", legend=rownames(counts), fill=c("darkblue", "firebrick"))

# grouped
counts <- table(newdata$transmission, newdata$cyl)
barplot(counts, col=c("darkblue", "firebrick"), beside=TRUE)
legend("top", legend=rownames(counts), fill=c("darkblue", "firebrick"))














