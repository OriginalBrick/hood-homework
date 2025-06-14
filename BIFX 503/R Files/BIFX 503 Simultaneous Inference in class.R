## This program shows in-class examples for BIFX 503
## One-way ANOVA and multiple comparisons

library(MASS)
library(multcomp)
library(dplyr)

###########################################################################################################################################
## Pairwise Testing - Chick weights
###########################################################################################################################################

# ANOVA
summary(aov(weight ~ feed, chickwts))
# statistically significant effect of feed (p<0.001)

# Tukey's HSD method
TukeyHSD(aov(weight ~ feed, chickwts))
plot(TukeyHSD(aov(weight ~ feed, chickwts)))

# pairwise t tests
# methods = "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
pairwise.t.test(chickwts$weight, chickwts$feed, p.adjust.method = "bonf")
pairwise.t.test(chickwts$weight, chickwts$feed, p.adjust.method = "holm")
pairwise.t.test(chickwts$weight, chickwts$feed, p.adjust.method = "fdr")

## multcomp package

# we want to compare Casein to each other group
# this is a more restricted number of tests than all pairwise comparisons
# matrix below gives Casein a -1, each other group gets a 1
K <- rbind(c(-1, 1, 0, 0, 0, 0),
           c(-1, 0, 1, 0, 0, 0),
           c(-1, 0, 0, 1, 0, 0),
           c(-1, 0, 0, 0, 1, 0),
           c(-1, 0, 0, 0, 0, 1))
rownames(K) <- c("cas-hor", "cas-lin", "cas-mea", "cas-soy", "cas-sun")
colnames(K) <- names(coef(chicks))
K

# ANOVA must be specified differently, stored as variable
chicks <- aov(weight ~ feed -1, chickwts)
summary(glht(chicks, K))



