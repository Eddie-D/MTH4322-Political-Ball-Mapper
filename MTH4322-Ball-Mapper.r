library("BallMapper")

# Read in data
setwd(".")
csv <- read.csv("./Regional-Referendum-Data.csv")

# Make names valid identifiers (replaces spaces with dots)
names(csv) <- make.names(names(csv))

# Use this step to apply procedures to normalise points
pts <- csv

# Create constituency-agree chart
par(mar = c(5, 10, 4, 2))  # bottom, left, top, right margins
barplot(pts$Agree,
        names.arg = pts$Region,
        main = "Welsh Constituencies and Their Referendum Votes",
        xlab = "Agree Percentage",
        col = "skyblue",
        # Alter region labels to fit
        horiz = TRUE,
        las = 1,
        xlim = c(0, max(csv$Agree) * 1.1)) # extend x-axis by 10%
