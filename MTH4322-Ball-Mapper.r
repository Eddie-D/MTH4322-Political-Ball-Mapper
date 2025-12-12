library("BallMapper")
library("magick")

# Read in data
setwd(".")
pts <- read.csv("./Data/all.csv")

# Make names valid identifiers (replaces spaces with dots)
names(pts) <- make.names(names(pts))


# PARTY BALL MAPPER ANALYSIS -----------------------------------------------
# Extract the parties
party_names <- c("Percentage.Yes", "Percentage.Con", "Percentage.Lab", "Percentage.LD", "Percentage.Other")

# Create image directories
dir.create("Party-Analysis")
lapply(paste0("Party-Analysis/", party_names), dir.create)

# Extract and Normalize party data
party_data <- pts[party_names]
party_data <- normalize_to_min_0_max_1(party_data)

# Create graphs for each party's colouring and a variety of epsilon
for (e in 10:80) {
  for (p in party_names) {
    epsilon <- e / 100
    coloring <- pts[p]
    # Set the seed so diagrams look the same
    set.seed(12345)
    #Create the plot in the correct folder
    graph <- BallMapper(party_data, coloring, epsilon)
    ColorIgraphPlot(graph, store_in_file = paste0("Party-Analysis/", p, "/", e, ".jpg"))
    # coloredDynamicNetwork(graph)
  }
}

# Create gifs out of the graphs
dir.create("Party-Analysis/Gifs")
for (p in party_names) {
  m <- image_read(paste0("Party-Analysis/", p, "/", 10:80, ".jpg"))
  m <- image_animate(m)
  m <- image_write(m, paste0("Party-Analysis/Gifs/", p, ".gif"))
}

# Function which plots a party for a specific value of epsilon
plot_for_epsilon <- function(e, p) {
  # Create Epsilon Directory
  dir_name <- paste0("./Parites-", e)
  dir.create(dir_name, showWarnings = FALSE)
  epsilon <- e / 100
  coloring <- pts[p]
  set.seed(12345)
  graph <- BallMapper(party_data, coloring, epsilon)
  ColorIgraphPlot(graph, store_in_file = paste0(dir_name, "/", p, "-", e, ".jpg"))
  return(graph)
  # coloredDynamicNetwork(graph)
}

# Use plot_for_epsilon to create specific graphs
# Plot a specific graph
# graph <- plot_for_epsilon(63, "Conservative")
# Plot all parties for one epsilon
# graphs <- lapply(party_names, plot_for_epsilon, e = 28)


# FULL BALL MAPPER ANALYSIS -----------------------------------------------
# Extract all numeric columns and normalize
numeric_cols <- sapply(pts, is.numeric)
full_pts_norm <- normalize_to_min_0_max_1(pts[, numeric_cols])

# Choose epsilon
e <- 74
epsilon <- e / 100
# Create folder for all the images
dir.create(paste0("./Full-", e), showWarnings = FALSE)

# Generate coloured images
for (col in colnames(full_pts_norm)) {
  coloring <- pts[col, drop = FALSE]
  # Fix seed so drawing is the same
  set.seed(12345)
  graph <- BallMapper(as.data.frame(full_pts_norm), coloring, epsilon)
  # Create a safe name from the column title
  safe_name <- gsub("[^[:alnum:]_.-]", "_", col)
  ColorIgraphPlot(graph, store_in_file = paste0("./Full-", e, "/", safe_name, ".png"))
}
