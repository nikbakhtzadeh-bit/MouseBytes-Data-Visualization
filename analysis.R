# MouseBytes 5-Choice Data Visualization

# Compare 5XFAD and B6SJLF1/J mice in the 3–6 month age group

library(ggplot2)
library(dplyr)

# Project paths

project_dir <- "C:/Users/nikba/OneDrive/Desktop/Neuroscience_DataViz"
data_file <- file.path(
project_dir,
"mousebytesdataset_version-1/Aggregated-Data/FB_AD_5Choice.csv"
)
figures_dir <- file.path(project_dir, "figures")

# Create figures folder if it does not exist

dir.create(figures_dir, showWarnings = FALSE, recursive = TRUE)

# Load the aggregated dataset

mydata <- read.csv(data_file)

# Select the two genotypes for the probe-task comparison

probe_data <- subset(
mydata,
Genotype %in% c("5XFAD", "B6SJLF1/J") &
SessionName == "Probe"
)

# Average accuracy for each animal, age, sex, genotype, and schedule

probe_accuracy <- aggregate(
`AVG_Trial.Analysis...Accuracy.` ~
AnimalID + Genotype + Age + Sex + Schedule_Name,
data = probe_data,
FUN = mean,
na.rm = TRUE
)

probe_accuracy$Age <- trimws(probe_accuracy$Age)

# Focus on the 3–6 month age group and four schedules

plot_data <- subset(
probe_accuracy,
Age == "3_6" &
Schedule_Name %in% c(
"5CSRTT_1500ms_Var1",
"5CSRTT_600ms_var1",
"5CSRTT_800ms_var1",
"5CSRTT_1s_var1"
)
)

# Set consistent group order and colors

plot_data$Genotype <- factor(
plot_data$Genotype,
levels = c("5XFAD", "B6SJLF1/J")
)

group_colors <- c(
"5XFAD" = "black",
"B6SJLF1/J" = "grey60"
)

# Calculate group means and 95% confidence intervals

summary_data <- plot_data %>%
group_by(Genotype, Schedule_Name) %>%
summarise(
n = sum(!is.na(`AVG_Trial.Analysis...Accuracy.`)),
mean_accuracy = mean(
`AVG_Trial.Analysis...Accuracy.`,
na.rm = TRUE
),
sd_accuracy = sd(
`AVG_Trial.Analysis...Accuracy.`,
na.rm = TRUE
),
se = sd_accuracy / sqrt(n),
ci95 = if (n > 1) qt(0.975, df = n - 1) * se else NA_real_,
.groups = "drop"
)

summary_data$Genotype <- factor(
summary_data$Genotype,
levels = c("5XFAD", "B6SJLF1/J")
)

# Scientific visualization: black vs grey points and confidence intervals

scientific_plot <- ggplot(
summary_data,
aes(
x = Schedule_Name,
y = mean_accuracy,
color = Genotype,
group = Genotype
)
) +
geom_point(
position = position_dodge(width = 0.35),
size = 3
) +
geom_errorbar(
aes(
ymin = mean_accuracy - ci95,
ymax = mean_accuracy + ci95
),
position = position_dodge(width = 0.35),
width = 0.15
) +
scale_color_manual(
values = group_colors,
breaks = c("5XFAD", "B6SJLF1/J"),
drop = FALSE
) +
labs(
title = "Probe accuracy across experimental schedules",
subtitle = "Age group 3–6 months; mean and 95% confidence intervals",
x = "Experimental schedule",
y = "Mean accuracy (%)",
color = "Genotype"
) +
theme_classic()

# Public-facing visualization: black vs grey bars

public_plot <- ggplot(
summary_data,
aes(
x = Schedule_Name,
y = mean_accuracy,
fill = Genotype
)
) +
geom_col(
position = position_dodge(width = 0.8),
width = 0.7
) +
scale_fill_manual(
values = group_colors,
breaks = c("5XFAD", "B6SJLF1/J"),
drop = FALSE
) +
labs(
title = "How accurately did the mice respond?",
subtitle = "Probe-task comparison in the 3–6 month age group",
x = "Task condition",
y = "Average accuracy (%)",
fill = "Mouse group"
) +
theme_classic(base_size = 12)

# Save both figures as PNG files

scientific_file <- file.path(
figures_dir,
"probe_accuracy_scientific.png"
)

public_file <- file.path(
figures_dir,
"probe_accuracy_public.png"
)

ggsave(
filename = scientific_file,
plot = scientific_plot,
width = 9,
height = 6,
dpi = 300,
bg = "white"
)

ggsave(
filename = public_file,
plot = public_plot,
width = 9,
height = 6,
dpi = 300,
bg = "white"
)

# Display both plots

print(scientific_plot)
print(public_plot)

# Confirm that the files were saved

cat("Scientific plot saved:", file.exists(scientific_file), "\n")
cat("Public plot saved:", file.exists(public_file), "\n")
