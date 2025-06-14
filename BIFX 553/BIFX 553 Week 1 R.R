# BIFX 553
# Week 1 Notes
# J. Jedediah Smith
# 1/25/2023

### DATA FRAME INTRO ###

# Data Frame
## May look like a number but isn't stored as such.
ir = head(iris)
ir

# Tibble
## Tells you  little more about the data than data frame.
library(tibble)
irt = as_tibble(ir)
head(irt)

# Accessing Single Column
## Be consistent with use because output format is different
ir[,1] # Vector
irt[,1] # Column


# Careful with Making Tables
## Don't want to accident set a string as a factor when it isn't. Common error!
df1 = data.frame(Gene='EGF', Count=3)
df2 = data.frame(Gene='EGF', Count=3, stringsAsFactors=TRUE)
df3 = data.frame(cbind(Gene='EGF', Count=3))

str(df1) # Gene is character, Count is number.
str(df2) # Gene is factor character, Count is number.
str(df3) # Both are characters.

df3$Count = as.numeric(df3$Count) # Rescue character back to number
# To rescue a number from a factor, you have to turn it into a character first. Then do above.

# Summary
## Be mindful about whether number is actually a number
## Tibble slightly different than data frame
## Be consistent with data structures.


### DATA FRAME MANIPULATION ##

irt %>% rename(Sepal_Width="Sepal.Width")

# Lots more stuff. See slides!