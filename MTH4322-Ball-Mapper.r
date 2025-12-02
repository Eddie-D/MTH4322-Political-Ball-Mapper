library("BallMapper")
library("magick")

# Read in data
setwd(".")
pts <- read.csv("./Regional-Referendum-Data.csv")

# Make names valid identifiers (replaces spaces with dots)
names(pts) <- make.names(names(pts))

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
        xlim = c(0, max(pts$Agree) * 1.1)) # extend x-axis by 10%


# PARTY BALL MAPPER ANALYSIS -----------------------------------------------
# Normalise all but the string column (regions)
# pts[-1] <- normalize_to_min_0_max_1(pts[-1])

# Extract the parties
party_names = c("Referendum", "Labour", "Conservative", "Liberal.Democrat", "Plaid.Cymru")
# Create image directories
lapply(party_names, dir.create)
parties <- pts[party_names]
parties <- normalize_to_min_0_max_1(parties)

# Create graphs for each party's colouring and a gif to show changes with epsilon
for (e in 1:100) {
  for (p in party_names) {
    epsilon <- e / 100
    coloring <- pts[p]
    graph <- BallMapper(parties, coloring, epsilon)
    ColorIgraphPlot(graph, store_in_file = paste0("./", p, "/", e, ".jpg"))
    # coloredDynamicNetwork(graph)
  }
}

# Create gifs
dir.create("Gifs")
for (p in party_names) {
  m <- image_read(paste0("./", p, "/", 1:100, ".jpg"))
  m <- image_animate(m)
  m <- image_write(m, paste0("./Gifs/", p, ".gif"))
}

plot_for_epsilon <- function(e, p) {
  epsilon <- e / 100
  coloring <- pts[p]
  graph <- BallMapper(parties, coloring, epsilon)
  ColorIgraphPlot(graph, store_in_file = paste0("./", p, "-", e, ".jpg"))
  return (graph)
  # coloredDynamicNetwork(graph)
}

# Recreate graphs with values of epsilon
# graph <- plot_for_epsilon(63, "Conservative")
# graphs <- lapply(party_names, plot_for_epsilon, e = 63)
