library("BallMapper")

# Read in data
setwd(".")
csv <- read.csv("./Regional-Referendum-Data.csv")

# Make names valid identifiers (replaces spaces with dots)
names(csv) <- make.names(names(csv))

# Use this step to apply procedures to normalise points
pts <- csv

# CONSTITUENCY AGREE CHART -------------------------------------------------
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


# PARTY BALL MAPPER ANALYSIS -----------------------------------------------
# Extract the parties
party_names = c("Labour", "Conservative", "Liberal.Democrat", "Plaid.Cymru")
parties <- pts[party_names]
parties <- normalize_to_min_0_max_1(parties)

# Create a graph for each party's colouring
for (p in party_names) {
  coloring <- pts[p]
  graph <- BallMapper(parties, coloring, .20)
  ColorIgraphPlot(graph, store_in_file = paste("./", p, ".png"))
  # coloredDynamicNetwork(graph)
}
