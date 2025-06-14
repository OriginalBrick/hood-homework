## This program shows in-class examples for BIFX 503 PCA and Cluster Analysis

setwd("~/Hood/BIFX 503 2021")

library(datasets)
library(MASS)
library(HSAUR)
library(HSAUR3)
library(psych)

###########################################################################################################################
## PCA
###########################################################################################################################

## Principal Components Analysis - alternative functions

?princomp
?prcomp

# Women's Heptathlon data

?heptathlon
heptathlon

# create a working copy of the file with total score removed

hept <- heptathlon[,-8]
hept

# look at characteristics of variables
summary(hept)
# no missing values

# look at data distributions
par(mfrow=c(2,4))
hist(hept$hurdles)
hist(hept$highjump)
hist(hept$shot)
hist(hept$run200m)
hist(hept$longjump)
hist(hept$javelin)
hist(hept$run800m)
par(mfrow=c(1,1))

# reverse-score some so that large values are 'good'
hept$hurdles <- max(hept$hurdles) - hept$hurdles
hept$run200m <- max(hept$run200m) - hept$run200m
hept$run800m <- max(hept$run800m) - hept$run800m
summary(hept)

# standardize them
scaled.hept <- scale(hept)
summary(scaled.hept)

# visualization 1 -- scatterplot matrix
pairs(scaled.hept, lower.panel=NULL, cex.labels=2, pch=19, cex=1.2)

# calculate correlation matrix -- do they seem correlated?
cor.hept <- round(cor(scaled.hept), 2)
cor.hept

# visualization 2 -- heat map
heatmap(cor.hept, symm = TRUE, revC = TRUE, margins=c(10,10))

# remove outlier -- PNG
scaled.hept2 <- scaled.hept[-grep("PNG", rownames(scaled.hept)),]
nrow(scaled.hept2)

# re-do correlations & scatterplot matrix & heatmap
cor.hept <- round(cor(scaled.hept2), 2)
pairs(scaled.hept2, lower.panel=NULL, cex.labels=2, pch=19, cex=1.2)
heatmap(cor.hept, symm = TRUE, revC = TRUE, margins=c(10,10))

# perform principal components using prcomp()
pca1 <- prcomp(scaled.hept2, scale = TRUE)
summary(pca1)             # print variance accounted for
pca1$rotation             # loadings
plot(pca1, type="lines")  # scree plot
pca1$x                    # component scores

# note textbook presents an another method for calculating component scores that is a bit more complicated!
center <- pca1$center
scale <- pca1$scale
hm <- as.matrix(scaled.hept2)
drop(scale(hm, center=center, scale=scale) %*% pca1$rotation[,1])

# another, simpler way
predict(pca1)[,1]

# alternative: princomp()
pca2 <- princomp(scaled.hept2, cor=TRUE)
summary(pca2)             # print variance accounted for
pca2$loadings             # loadings
plot(pca2, type="lines")  # scree plot
pca2$scores               # component scores

# another alternative package: psych, for specifying how many components to retain
library(psych)
pca3 <- principal(scaled.hept2, nfactors=1, scores=TRUE)
pca3$loadings
pca3$scores


## Example 2: Iris data

?iris
head(iris)
summary(iris)
# no missing data

# subset - leave species out
iris.q <- iris[,1:4]

scaled.iris <- scale(iris.q)

pairs(scaled.iris, lower.panel=NULL, cex.labels=2, pch=19, cex=1.2)
# note clusters evident in scatterplots

corr.iris <- cor(scaled.iris)
corr.iris

heatmap(corr.iris, symm = TRUE, revC = TRUE, margins=c(10,10), col=cm.colors(256))

pca1 <- princomp(scaled.iris, cor=TRUE)
plot(pca1, type="lines")
summary(pca1)
# two components explain >95% of variance
pca1$loadings


###########################################################################################################################
## Cluster Analysis 1 -- Hierarchical Agglomerative Clustering
###########################################################################################################################

## Example One -- Simulated Data

## Generate simulated data: three clusters

set.seed(1234)
x <- rnorm(12, rep(1:3, each = 4), 0.2)
y <- rnorm(12, rep(c(1, 2, 1), each = 4), 0.2)

plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

# combine x and y into data frame format
sim.df <- data.frame(x=x, y=y)
sim.df

## Hierarchical Clustering Example

# calculate distance matrix, Euclidian distance is the default
mydist <- dist(sim.df)
mydist

# perform clustering on distance matrix
myclust <- hclust(mydist, method="average")

# plot dendrogram
plot(myclust)

# cut tree into three clusters
groups <- cutree(myclust, k=3)
rect.hclust(myclust, k=3, border="red")


## Example Two -- Iris Data

## Scatter plot matrix
sp.cols <- character(nrow(iris))
sp.cols <- "black"
sp.cols[iris$Species == "setosa"] <- "cornflowerblue"
sp.cols[iris$Species == "versicolor"] <- "mediumseagreen"
sp.cols[iris$Species == "virginica"] <- "orchid"

species_labels <- iris[,5]

pairs(iris.q, col=sp.cols, lower.panel=NULL, cex.labels=2, pch=19, cex=1.2)

par(xpd = TRUE)
legend(x = 0.05, y = 0.4, cex=2, legend=as.character(levels(species_labels)), fill=unique(sp.cols))
par(xpd = NA)

# calculate distance matrix

iris.dist <- dist(iris.q)
iris.dist2 <- dist(iris.q, method="manhattan")

# cluster analysis using "complete" method

iris.clust <- hclust(iris.dist)
iris.clust2 <- hclust(iris.dist2)
iris.clust3 <- hclust(iris.dist, method="average")
iris.clust4 <- hclust(iris.dist2, method="average")

# plot dendrogram

plot(iris.clust, main="euclidean, complete")
plot(iris.clust2, main="manhattan, complete")
plot(iris.clust3, main="euclidean, average")
plot(iris.clust4, main="manhattan, average")


# cut tree into three clusters

iris.groups <- cutree(iris.clust, k=3)
rect.hclust(iris.clust, k=3, border="red")


## Class exercise -- USArrests data

?USArrests
str(USArrests)
head(USArrests)

ua.dist1 <- dist(USArrests)
ua.dist2 <- dist(USArrests, method="manhattan")

ua.clust1 <- hclust(ua.dist1)
plot(ua.clust1)

ua.clust2 <- hclust(ua.dist2)
plot(ua.clust2)

ua.clust3 <- hclust(ua.dist1, method = "average")
plot(ua.clust3)

ua.clust4 <- hclust(ua.dist2, method = "average")
plot(ua.clust4)


###########################################################################################################################
## Cluster Analysis 2 -- K-Means Clustering
###########################################################################################################################

## Example One -- Simulated Data

mykmeans <- kmeans(sim.df, centers = 3)
mykmeans$cluster
mykmeans$centers  

plot(x, y, col = "blue", pch = 19, cex = 2)
points(mykmeans$centers, col = "red", pch = 12, cex = 2)


## Example Two -- Iris Data

iris.kmeans <- kmeans(iris.q, centers=3)
iris.kmeans$cluster

iris.clusters <- cbind(iris, iris.kmeans$cluster)
iris.clusters$Cluster <- iris.kmeans$cluster

table(iris.clusters$Species, iris.clusters$Cluster)

## Setosa accurately classified -- all in cluster 1
## Versicolor all in cluster 2 with the exception of two plants
## Virginica -- most in cluster 3

## Re-do scatter plot matrix, using cluster assignment

pairs(iris.q, col=iris.kmeans$cluster, pch=19, lower.panel = NULL)

## 1=black 2=red 3=green

## Class Exercise -- Arrest Data

arr.kmeans <- kmeans(USArrests, centers=3)
arr.clusters <- cbind(USArrests, arr.kmeans$cluster)
arr.clusters$cluster <- arr.clusters$`arr.kmeans$cluster`

sorted.clusters <- arr.clusters[order(arr.clusters$cluster),]
sorted.clusters

boxplot(Murder ~ cluster, sorted.clusters)
boxplot(Assault ~ cluster, sorted.clusters)
boxplot(Rape ~ cluster, sorted.clusters)
boxplot(UrbanPop ~ cluster, sorted.clusters)







