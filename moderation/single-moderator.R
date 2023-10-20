## Doing moderator analysis with single moderator
## https://uedufy.com/how-to-run-moderation-analysis-in-r-single-moderator/
source("https://raw.githubusercontent.com/helseprofil/misc/main/utils.R")
pkgs <- c("lmtest", "car", "ggplot2", "interactions")
kh_load(char = pkgs)

data <- data.frame(
  Respondent = 1:30,
  Cups = c(2, 4, 1, 3, 2, 3, 1, 2, 2, 4, 2, 3, 1, 3, 3, 2, 2, 4, 1, 3, 2, 3, 1, 2, 2, 4, 2, 3, 1, 3),
  Tolerance = c(7, 5, 6, 7, 8, 6, 7, 7, 6, 8, 7, 7, 6, 7, 8, 6, 7, 5, 6, 7, 8, 6, 7, 7, 6, 8, 7, 7, 6, 7),
  Productivity = c(5, 6, 4, 6, 7, 7, 4, 6, 5, 7, 5, 6, 4, 6, 7, 5, 5, 6, 4, 6, 7, 7, 4, 6, 5, 7, 5, 6, 4, 6)
)

# model fitting
model <- lm(Productivity ~ Cups * Tolerance, data)
summary(model)

interactions::interact_plot(model, pred = Cups, modx = Tolerance)

# Influential observations
influence <- influence.measures(model)

# Print Cook's distance values for each observation
print(influence$is.inf)

# Plot Cook's distance
plot(influence$infmat[, "cook.d"],
     main = "Cook's distance plot",
     ylab = "Cook's distance",
     ylim = c(0, max(1, max(influence$infmat[, "cook.d"]))))

# Add a reference line for Cook's distance = 1
abline(h = 1, col = "red")

# Diagnostic Plots
par(mfrow = c(2, 2), oma = c(0, 0, 2, 0))
plot(model, las = 1)
mtext("Diagnostic Plots", outer = TRUE, line = -1, cex = 1.5)

# Save the plots as a PDF file
pdf("Diagnostic_Plots.pdf")
par(mfrow = c(2, 2), oma = c(0, 0, 2, 0))
plot(model, las = 1)
mtext("Diagnostic Plots", outer = TRUE, line = -1, cex = 1.5)
dev.off()
