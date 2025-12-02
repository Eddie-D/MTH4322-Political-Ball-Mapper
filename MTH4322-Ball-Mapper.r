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

# Extract the parties
parties <- subset(pts, select = c(Labour,
                                  Conservative,
                                  Liberal.Democrat,
                                  Plaid.Cymru))
parties <- normalize_to_min_0_max_1(parties)

# Run the desired colouring
color_by <- "Labour"
color_by <- "Conservative"
color_by <- "Liberal.Democrat"
color_by <- "Plaid.Cymru"

coloring <- data.frame(pts[[color_by]])

graph <- BallMapper(parties, coloring, .20)
ColorIgraphPlot(graph, store_in_file = paste("./", color_by, ".png"))
print(graph)
coloredDynamicNetwork(graph)
