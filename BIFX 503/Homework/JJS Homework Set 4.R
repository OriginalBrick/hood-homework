# J. Jedediah Smith
# Homework Set No.4
# BIFX 503-1
# 11/18/2021

library(MASS)
library(afex)

### QUESTION 2 ###
# Plot tree growth over time separately for the ozone and control groups, using interaction or other plot.
Sitka89_ozone <- Sitka89[Sitka89$treat == "ozone", ]
Sitka89_control <- Sitka89[Sitka89$treat == "control", ]

# Separate
par(mfrow=c(1,2))
interaction.plot(x.factor=Sitka89_ozone$Time, trace.factor=Sitka89_ozone$treat, response=Sitka89_ozone$size, fun="mean", type="b", ylab="Size", xlab="Time", pch=c(1,19))
interaction.plot(x.factor=Sitka89_control$Time, trace.factor=Sitka89_control$treat, response=Sitka89_control$size, fun="mean", type="b", ylab="Size", xlab="Time", pch=c(1,19))
par(mfrow=c(1,1))

# Together
interaction.plot(x.factor=Sitka89$Time, trace.factor=Sitka89$treat, response=Sitka89$size, fun="mean", type="b", ylab="Size", xlab="Time", pch=c(1,19))


### QUESTION 3 ###
# Run a repeated measures regression model having time, treatment, and their interaction as independent variables.
gee1 <- geeglm(size ~ treat*Time, data=Sitka89, id=tree, corstr="exchangeable")
summary(gee1)


### QUESTION 4 ###
# Run a second repeated measures regression model having time and treatment as the only independent variables.
gee1 <- geeglm(size ~ Time + treat, data=Sitka89, id=tree, corstr="exchangeable")
summary(gee1)


### QUESTION 5 ###
# Examine the distributions of each of the continuous variables in this dataset.
head(Pima.tr)
pim <- Pima.tr[,-8]
pim

# Generate a histogram and QQ plot for each one.
par(mfrow=c(2,4))
hist(pim$npreg)
hist(pim$glu)
hist(pim$bp)
hist(pim$skin)
hist(pim$bmi)
hist(pim$ped)
hist(pim$age)
par(mfrow=c(1,1))

par(mfrow=c(2,4))
qqnorm(pim$npreg, main = "Normal Q-Q Plot for npreg")
qqline(pim$npreg)
qqnorm(pim$glu, main = "Normal Q-Q Plot for glu")
qqline(pim$glu)
qqnorm(pim$bp, main = "Normal Q-Q Plot for bp")
qqline(pim$bp)
qqnorm(pim$skin, main = "Normal Q-Q Plot for skin")
qqline(pim$skin)
qqnorm(pim$bmi, main = "Normal Q-Q Plot for bmi")
qqline(pim$bmi)
qqnorm(pim$ped, main = "Normal Q-Q Plot for ped")
qqline(pim$ped)
qqnorm(pim$age, main = "Normal Q-Q Plot for age")
qqline(pim$age)
par(mfrow=c(1,1))

# Transform the non-normal ones and replot.
pim$sqrt_npreg <- sqrt(pim$npreg)
pim$sqrt_skin <- sqrt(pim$skin)
pim$sqrt_ped <- sqrt(pim$ped)
pim$sqrt_age <- sqrt(pim$age)

par(mfrow=c(2,4))
hist(pim$sqrt_npreg)
hist(pim$sqrt_skin)
hist(pim$sqrt_ped)
hist(pim$sqrt_age)
qqnorm(pim$sqrt_npreg, main = "Normal Q-Q Plot for sqrt_npreg")
qqline(pim$sqrt_npreg)
qqnorm(pim$sqrt_skin, main = "Normal Q-Q Plot for sqrt_skin")
qqline(pim$sqrt_skin)
qqnorm(pim$sqrt_ped, main = "Normal Q-Q Plot for sqrt_ped")
qqline(pim$sqrt_ped)
qqnorm(pim$sqrt_age, main = "Normal Q-Q Plot for sqrt_age")
qqline(pim$sqrt_age)
par(mfrow=c(1,1))

# Some remain non-normal.
pim$log_npreg <- log10(pim$npreg)
pim$log_ped <- log10(pim$ped)
pim$log_age <- log10(pim$age)

par(mfrow=c(2,3))
hist(pim$log_npreg)
hist(pim$log_ped)
hist(pim$log_age)
qqnorm(pim$log_npreg, main = "Normal Q-Q Plot for log_npreg")
qqline(pim$log_npreg)
qqnorm(pim$log_ped, main = "Normal Q-Q Plot for log_ped")
qqline(pim$log_ped)
qqnorm(pim$log_age, main = "Normal Q-Q Plot for log_age")
qqline(pim$log_age)
par(mfrow=c(1,1))


### QUESTION 6 ###
# Create a dataset that contains the seven numeric predictor variables. Use transformed as needed.
pimfix <- pim[,c(-1,-4,-6,-7,-10,-11,-12)]

# Scale the 7 variables.
scaled.pimfix <- scale(pimfix)
summary(scaled.pimfix)

# Do a scatter plot and correlation matrix.
pairs(scaled.pimfix, lower.panel=NULL, cex.labels=2, pch=19, cex=1.2)

cor.pimfix <- round(cor(scaled.pimfix), 2)
cor.pimfix

# Perform PCA, generate a scree plot and output the proportion of variance for each component.
pca1 <- prcomp(scaled.pimfix, scale = TRUE)
summary(pca1)             # Print variance accounted for
pca1$rotation             # Loadings
plot(pca1, type="lines")  # Scree plot
pca1$x                    # Component scores


### QUESTION 7 ###
# Calculate the distance matrix on the unscaled variables.
pimdist <- dist(pimfix)
pimdist

# Perform hierarchical clustering and plot the dendrogram.
pimclust <- hclust(pimdist, method="average")
plot(pimclust)

groups <- cutree(pimclust, k=4)
rect.hclust(pimclust, k=4, border="red")


### QUESTION 8 ###
# Cross-tabulate the Type variable with the cluster assignment from the k-means clustering.
pim.kmeans <- kmeans(pimfix, centers=2)
pim.kmeans$cluster

pim.clusters <- cbind(Pima.tr, pim.kmeans$cluster)
pim.clusters$Cluster <- pim.kmeans$cluster

table(pim.clusters$type, pim.clusters$Cluster)

# Perform a chi square test to see if cluster assignment and diabetes are associated.
chisq.test(table(pim.clusters$type, pim.clusters$Cluster))
