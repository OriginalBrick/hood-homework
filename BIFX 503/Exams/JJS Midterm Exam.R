# J. Jedediah Smith
# Midterm Exam
# BIFX 503-1
# 10/6/2021


NitrofenData <- read.csv("Nitrofen.csv")
CPUsData <- read.csv("CPUs.csv")


### QUESTION 1 ###
# Generate box plot and summary statistics for population each concentration (mean, std).
boxplot(NitrofenData$offspring ~ NitrofenData$conc)
aggregate(offspring ~ conc, NitrofenData, mean, na.action=na.omit)
aggregate(offspring ~ conc, NitrofenData, sd, na.action=na.omit)


### QUESTION 2 ###
# One-way ANOVA to confirm whether concentrations are different. Use post-hoc if needed.
summary(aov(offspring ~ conc, NitrofenData))
pairwise.t.test(NitrofenData$offspring, NitrofenData$conc, p.adjust.method = "bonf")


### QUESTION 3 ###
# No code required.


### QUESTION 4 ###
# No code required.


### QUESTION 5 ####
# Six scatterplots to visualize the relationship between log_perf and each of the other quantitative variables.
par(mfrow=c(3,3))
plot(log_perf ~ cycle_time, CPUsData)
plot(log_perf ~ min_memory, CPUsData)
plot(log_perf ~ max_memory, CPUsData)
plot(log_perf ~ cache_size, CPUsData)
plot(log_perf ~ min_channels, CPUsData)
plot(log_perf ~ max_channels, CPUsData)
par(mfrow=c(1,1))


### QUESTION 6 ###
# Subset the quantitative variables. Calculate correlation matrix.
CPUsSubset<- CPUsData[,2:8]
cor(CPUsSubset)


### QUESTION 7 ###
# Multiple linear regression model with log_perf as dependent and all other quantitative variables as independent.
# Evaluate the fit of the model by looking at the residuals plot and R square value.
summary(lm(log_perf ~ cycle_time + min_memory + max_memory + cache_size + min_channels + max_channels, CPUsSubset))
CPUsFit <- lm(log_perf ~ cycle_time + min_memory + max_memory + cache_size + min_channels + max_channels, CPUsSubset)
CPUsRes <- resid(CPUsFit)
plot(CPUsSubset$log_perf, CPUsRes, xlab = "Log_perf", ylab = "Residuals")


### QUESTION 8 ###
# Report the results in terms of regression coefficients, 95% confidence intervals, and p-value.  
summary(lm(log_perf ~ cycle_time + min_memory + max_memory + cache_size + min_channels + max_channels, CPUsSubset))
lm(log_perf ~ cycle_time + min_memory + max_memory + cache_size + min_channels + max_channels, CPUsSubset)
confint(lm(log_perf ~ cycle_time + min_memory + max_memory + cache_size + min_channels + max_channels, CPUsSubset))


