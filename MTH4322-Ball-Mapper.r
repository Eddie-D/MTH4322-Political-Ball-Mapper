library("BallMapper")
library("magick")

# Read in data
setwd(".")
pts <- read.csv("./Data/all.csv")

# Make names valid identifiers (replaces spaces with dots)
names(pts) <- make.names(names(pts))

# CONSTITUENCY AGREE CHART -------------------------------------------------
# par(mar = c(5, 10, 4, 2))  # bottom, left, top, right margins
# barplot(pts$Agree,
#        names.arg = pts$Region,
#        main = "Welsh Constituencies and Their Referendum Votes",
#        xlab = "Agree Percentage",
#        col = "skyblue",
#        # Alter region labels to fit
#        horiz = TRUE,
#        las = 1,
#        xlim = c(0, max(pts$Agree) * 1.1)) # extend x-axis by 10%


# PARTY BALL MAPPER ANALYSIS -----------------------------------------------
# Normalise all but the string column (regions)

# Extract the parties
party_names <- c("Percentage.Yes", "Cons", "Lab", "LD", "Other")
# Create image directories

lapply(party_names, dir.create)
party_data <- pts[party_names]
party_data <- normalize_to_min_0_max_1(party_data)

# Create graphs for each party's colouring and a variety of epsilon
for (e in 1:100) {
  for (p in party_names) {
    epsilon <- e / 100
    coloring <- pts[p]
    graph <- BallMapper(party_data, coloring, epsilon)
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
  epsilon <- e * 10000
  coloring <- pts[p]
  graph <- BallMapper(party_data, coloring, epsilon)
  ColorIgraphPlot(graph, store_in_file = paste0("./", p, "-", e, ".jpg"))
  return (graph)
  # coloredDynamicNetwork(graph)
}

# Recreate graphs with values of epsilon
# graph <- plot_for_epsilon(63, "Conservative")
graphs <- lapply(party_names, plot_for_epsilon, e = 550000)


# FULL BALL MAPPER ANALYSIS -----------------------------------------------
# Use all numeric columns from the compiled `all.csv` (excludes constituency name)
# Normalise and run BallMapper for each column as a colouring
numeric_cols <- sapply(pts, is.numeric)
full_pts <- pts[ , numeric_cols]
full_pts_norm <- normalize_to_min_0_max_1(full_pts)

e <- 64
epsilon <- e / 100
dir.create(paste0("./Full-", e), showWarnings = FALSE)
for (col in colnames(full_pts_norm)) {
  # colouring must be a one-column data.frame (BallMapper indexes by rows/columns)
  coloring <- full_pts_norm[col]
  graph <- BallMapper(as.data.frame(full_pts_norm), coloring, epsilon)
  # sanitize filename (remove/replace characters that may cause issues)
  safe_name <- gsub("[^[:alnum:]_.-]", "_", col)
  ColorIgraphPlot(graph, store_in_file = paste0("./Full-", e, "/", safe_name, ".png"))
}

