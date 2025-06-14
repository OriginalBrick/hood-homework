## This program shows in class examples for BIFX 503 Recursive Partitioning material

library(MASS)
library(rpart)
library(partykit)
library(TH.data)

?rpart
?prune

###########################################################################################################################################
## Continuous outcome -- Body fat data
###########################################################################################################################################

?bodyfat
summary(bodyfat)  # note all continuous variables with no missing values

## exploratory plots
hist(bodyfat$DEXfat)
plot(DEXfat ~ age, bodyfat)           # relationship looks weak
plot(DEXfat ~ waistcirc, bodyfat)     # relationship looks strong and linear
plot(DEXfat ~ hipcirc, bodyfat)       # relationship looks strong and fairly linear
plot(DEXfat ~ elbowbreadth, bodyfat)  # relationship looks weak
plot(DEXfat ~ kneebreadth, bodyfat)   # relationship looks slightly curved

## Initial model
bodyfat_rpart <- rpart(DEXfat ~ age + waistcirc + hipcirc + elbowbreadth + kneebreadth, data = bodyfat, control = rpart.control(minsplit=10))

plot(as.party(bodyfat_rpart), tp_args = list(id = FALSE))

## Pruning the tree
bodyfat_rpart$cptable

opt <- which.min(bodyfat_rpart$cptable[, "xerror"])

# identify tree with minimized prediction error
cpval <- bodyfat_rpart$cptable[opt, "CP"]
bodyfat_prune <- prune(bodyfat_rpart, cp = cpval)
plot(as.party(bodyfat_prune), tp_args = list(id = FALSE))

## Generating predicted values
DEXfat_pred <- predict(bodyfat_prune, newdata = bodyfat)

xlim <- range(bodyfat$DEXfat)
plot(DEXfat_pred ~ DEXfat, data = bodyfat, xlab="Observed", ylab="Predicted", ylim=xlim, xlim=xlim)
abline(a=0, b=1)

## Another approach, without pruning -- conditional inference tree
bodyfat_ctree <- ctree(DEXfat ~ age + waistcirc + hipcirc + elbowbreadth + kneebreadth, data = bodyfat)
bodyfat_ctree
plot(bodyfat_ctree, tp_args = list(id = FALSE))

###########################################################################################################################################
## Dichotomous outcome -- Glaucoma data
###########################################################################################################################################

?GlaucomaM
summary(GlaucomaM)

## Initial model
# Note syntax D ~ . uses all variables without having the name them all
glaucoma_rpart <- rpart(Class ~ ., data = GlaucomaM, control = rpart.control(xval=100))
plot(as.party(glaucoma_rpart), tp_args = list(id = FALSE))
glaucoma_rpart$cptable

## Pruned model
opt <- which.min(glaucoma_rpart$cptable[, "xerror"])
cpval <- glaucoma_rpart$cptable[opt, "CP"]
glaucoma_prune <- prune(glaucoma_rpart, cp = cpval)
plot(as.party(glaucoma_prune), tp_args = list(id = FALSE))

## Demonstrates that the solution is not stable
nsplitopt <- vector(mode="integer", length=25)
for (i in 1:length(nsplitopt)) {
  cp <- rpart(Class ~ ., data=GlaucomaM)$cptable
  nsplitopt[i] <- cp[which.min(cp[,"xerror"]), "nsplit"]
}
table(nsplitopt)

## Demonstrates "bagging"
trees <- vector(mode="list", length=25)
n <- nrow(GlaucomaM)
bootsamples <- rmultinom(length(trees), n, rep(1,n)/n)
mod <- rpart(Class ~ ., data=GlaucomaM, control=rpart.control(xval=0))
for (i in 1:length(trees))
  trees[[i]] <- update(mod, weights=bootsamples[,i])
table(sapply(trees, function(x) as.character(x$frame$var[1])))
# variable "varg" is selected most of the time

## Estimate the conditional probability of glaucoma, given covariates for each person in dataset
classprob <- matrix(0, nrow=n, ncol=length(trees))
for (i in 1:length(trees)) {
  classprob[,i] <- predict(trees[[i]], newdata=GlaucomaM)[,1]
  classprob[bootsamples[,i] > 0, i] <- NA
}

## Average the estimates and assign "glaucoma" when the average probability is more than half
avg <- rowMeans(classprob, na.rm = TRUE)
predictions <- factor(ifelse(avg > 0.5, "glaucoma", "normal"))
predtab <- table(predictions, GlaucomaM$Class)
predtab

round(predtab[1,1]/colSums(predtab)[1]*100)
## Probability of a correct prediction of glaucoma (%)

round(predtab[2,2]/colSums(predtab)[2]*100)
## Probability of a correct prediction of normal eye (%)


## Conditional inference tree for glaucoma data
glaucoma_ctree <- ctree(Class ~ ., data = GlaucomaM)
glaucoma_ctree
plot(glaucoma_ctree, tp_args = list(id = FALSE))

# does this do any better at prediction?
glaucoma_cpred <- predict(glaucoma_ctree, newdata = GlaucomaM)
addpred <- cbind(GlaucomaM, glaucoma_cpred)
table(addpred$Class, addpred$glaucoma_cpred)

###########################################################################################################################################
## CPU data
###########################################################################################################################################

library(MASS)
?cpus

cpus.cont <- cpus[,2:8]

cpu_rpart <- rpart(perf ~ ., data = cpus.cont, control = rpart.control(minsplit=10))
plot(as.party(cpu_rpart), tp_args = list(id = FALSE))

cpu_rpart$cptable
# no pruning necessary

## Generating predicted values
cpu_pred <- predict(cpu_rpart, newdata = cpus.cont)

# Compare to observed, and to published predicted values
cpus.cp <- cbind(cpus.cont, cpu_pred)
cpus.cp <- cbind(cpus.cp, cpus$estperf)

plot(cpu_pred ~ perf, cpus.cp, log="xy")
plot(cpu_pred ~ cpus$estperf, cpus.cp, log="xy")





