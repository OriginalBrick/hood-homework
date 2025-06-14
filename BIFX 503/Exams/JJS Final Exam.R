# J. Jedediah Smith
# Final Exam
# BIFX 503-1
# 12/8/2021

BacteriaData <- read.csv("bacteria.csv")
CPUsData <- read.csv("CPUs.csv")

## QUESTION 1 ##
# Run a repeated-measures logistic regression model that consists of bac_pos as the dependent variable, and the following independent variables: week, tx, hilo, and the interaction tx*hilo.
bac_glm <- glm(bac_pos ~ week + tx + hilo + tx*hilo, data=BacteriaData, family="binomial")
exp(coef(bac_glm))
exp(confint(bac_glm))


## QUESTION 2 ##
# Are any terms statistically significant?
summary(bac_glm)


## QUESTION 4 ##
# Examine the distributions of each of the continuous variables in this dataset.
CPUsData2 <- CPUsData[,-1]
CPUsData2

# Generate a histogram for each one.
par(mfrow=c(2,4))
hist(CPUsData2$cycle_time)
hist(CPUsData2$min_memory)
hist(CPUsData2$max_memory)
hist(CPUsData2$cache_size)
hist(CPUsData2$min_channels)
hist(CPUsData2$max_channels)
hist(CPUsData2$log_perf) # Only normal one.
par(mfrow=c(1,1))

# Transform non-normal.
CPUsData2$cycle_time <- sqrt(CPUsData2$cycle_time)
CPUsData2$min_memory <- sqrt(CPUsData2$min_memory)
CPUsData2$max_memory <- sqrt(CPUsData2$max_memory)
CPUsData2$cache_size <- sqrt(CPUsData2$cache_size)
CPUsData2$min_channels <- sqrt(CPUsData2$min_channels)
CPUsData2$max_channels <- sqrt(CPUsData2$max_channels)

par(mfrow=c(2,3))
hist(CPUsData2$cycle_time)
hist(CPUsData2$min_memory)
hist(CPUsData2$max_memory)
hist(CPUsData2$cache_size)
hist(CPUsData2$min_channels)
hist(CPUsData2$max_channels)
par(mfrow=c(1,1))


## QUESTION 5 ##
# Perform hierarchical clustering and plot the dendrogram.

# Distance
cpudist <- dist(CPUsData2)
cpudist

# Clustering
cpuclust <- hclust(cpudist, method="average")

# Plot dendrogram
plot(cpuclust)

# Cut tree
groups <- cutree(cpuclust, k=3)
rect.hclust(cpuclust, k=3, border="red")


## QUESTION 7 ##
# Visualize the relationship between survival and treatment using a Kaplan-Meier plot.
plot(survfit(Surv(stime, status) ~ treat, data=VA), xlab="Survival Time in Days", ylab="Probability of Survival", lty=c(1,2))


## QUESTION 8 ##
# Calculate the median survival time for each treatment group and compare.
survfit(Surv(stime, status) ~ treat, data=VA)


## QUESTION 9 ##
# Use a log-rank test to test the hypothesis that treatment affects survival time.
logrank_test(Surv(stime, status) ~ factor(treat), VA)


## QUESTION 10 ##
# Run a Cox proportional hazards model that includes treatment, age, and Karnofsky score.
summary(coxph(Surv(stime, status) ~ treat + Karn + age, data=VA))

