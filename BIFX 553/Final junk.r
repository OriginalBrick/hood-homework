

data <- data.frame(Genotype=c(2, 1, 0),
                 Diseased=c(80, 200, 280),
                 Normal=c(20,600,920),
                 Total=c(100,800,1200))

rownames(data) <- c("Homozygous Variant", "Heterozygous", "Homozygous Wildtype")


chisq.test(data[2:3])

long_data <- data.frame(
  Genotype=c(
    rep(1,100),
    rep(0.5,800),
    rep(0,1200)),
  Condition=c(
    rep(1,80), rep(0,20),
    rep(1,200), rep(0,600),
    rep(1,280), rep(0,920))
  )
    
glm <- glm(long_data, family = binomial())
glm

glm.fit(long_data$Condition,long_data$Genotype)