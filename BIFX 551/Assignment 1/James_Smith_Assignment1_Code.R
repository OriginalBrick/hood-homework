# J. Jedediah Smith
# BIFX 551
# Assignment 1
# 2/19/2022


##############
# QUESTION 1 #
##############

# Loading the document into R and remove bad rows.
# https://www.r-bloggers.com/2021/06/reading-data-from-excel-files-xlsxlsxcsv-into-r-quick-guide/
library("readxl")
Axis1 <- read_excel("WING paper Data for repository.xlsx", sheet = "Axis 1 measures")
Axis1 <- Axis1[-c(165:175),]
Axis2 <- read_excel("WING paper Data for repository.xlsx", sheet = "Axis 2 measures")
Axis2 <- Axis2[-c(165:168),]

# Remove unneeded name and duplicate variable.
Axis2 <- Axis2[-c(1,3,13)]

# Renaming the name column to match the other sheet.
# https://stackoverflow.com/questions/7531868/how-to-rename-a-single-column-in-a-data-frame
names(Axis2)[names(Axis2) == 'name...2'] <- 'name'

# Combine variables for Axis 1 and 2 together using their name.
CombinedAxis <- merge(Axis1,Axis2,by="name")

# Make sure all the numeric columns are numeric.
# https://stackoverflow.com/questions/2288485/how-to-convert-a-data-frame-column-to-numeric-type
CombinedAxis[, c(4:20)] <- sapply(CombinedAxis[, c(4:20)], as.numeric)


##############
# QUESTION 2 #
##############

# Remove the non-number variables.
NumOnly <- CombinedAxis[-c(1:3)]

# Statistical description.
summary(NumOnly)

# Variable correlation.
CombinedCor <- cor(NumOnly)


##############
# QUESTION 3 #
##############

# Initial pairwise relationship.
pairs(NumOnly, main="Pairwise Comparison of Axis 1 & 2 Measurements")

# Cut out excessive variables.
NumOnlyRefined <- NumOnly[-c(4:10,13:19)]

# Rerun pairwise relationship.
pairs(NumOnlyRefined, main="Pairwise Comparison of Axis 1 & 2 Measurements")


##############
# QUESTION 4 #
##############

# Read in the data and remove bad rows.
Brood <- read_excel("WING paper Data for repository.xlsx", sheet = "Experimental brood")
Brood <- Brood[-c(83:88),]

par(mfrow=c(2,3))

# Compare Sex
countSex0 <- table(Brood$sex)
barplot(countSex0,
        main="Brood Sex Distribution",
        xlab="Sex", ylab="Frequency",
        col=c("red", "blue"),
        legend=rownames(Brood$sex))

# Compare Genotype
countGenotype0 <- table(Brood$genotype)
barplot(countGenotype0,
        main="Brood Genotype Distribution",
        xlab="Genotype", ylab="Frequency",
        col=c("green", "red", "yellow", "blue"),
        legend=rownames(Brood$genotype))

# Compare Phenotype
countPhenotype0 <- table(Brood$phenotype)
barplot(countPhenotype0,
        main="Brood Phenotype Distribution",
        xlab="Phenotype", ylab="Frequency",
        col=c("red", "yellow", "blue"),
        legend=rownames(Brood$phenotype))


##############
# QUESTION 5 #
##############

# Compare Axis1 sex distribution.
countSex1 <- table(Axis1$sex)
barplot(countSex1,
        main="Axis 1 Sex Distribution",
        xlab="Sex", ylab="Frequency",
        col=c("pink", "red", "blue"),
        legend=rownames(Axis1$sex))

# Compare Axis1 genotype distribution.
countGenotype1 <- table(Axis1$genotype)
barplot(countGenotype1,
        main="Axis 1 Genotype Distribution",
        xlab="Genotype", ylab="Frequency",
        col=c("green", "red", "yellow", "blue"),
        legend=rownames(Axis1$genotype))

# Compare Axis1 area distribution.
hist(Axis1$area,
     breaks=3,
     col="red",
     xlab="Area in Pixels",
     main="Axis 1 Aera Distribution")

par(mfrow=c(1,1))