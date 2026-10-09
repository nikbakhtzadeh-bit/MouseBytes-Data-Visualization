
# MouseBytes 5-Choice Data Visualization
# Compare 5XFAD and B6SJLF1/J mice in the 3–6 month age group

library(ggplot2)
library(dplyr)

# Load the aggregated dataset
mydata <- read.csv(
  "C:/Users/nikba/OneDrive/Desktop/Neuroscience_DataViz/mousebytesdataset_version-1/Aggregated-Data/FB_AD_5Choice.csv"
)

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

# Remove extra spaces from age labels
probe_accuracy$Age <- trimws(probe_accuracy$Age)

# Focus on the 3–6 month age group
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

# Scientific-style visualization
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
    ci95 = qt(0.975, df = n - 1) * se,
    .groups = "drop"
  )

# Black-and-white scientific visualization
scientific_plot <- ggplot(
  summary_data,
  aes(
    x = Schedule_Name,
    y = mean_accuracy,
    shape = Genotype,
    group = Genotype
  )
) +
  geom_point(
    position = position_dodge(width = 0.4),
    size = 3.5,
    color = "black"
  ) +
  geom_errorbar(
    aes(
      ymin = mean_accuracy - ci95,
      ymax = mean_accuracy + ci95
    ),
    position = position_dodge(width = 0.4),
    width = 0.15,
    color = "black",
    linewidth = 0.7
  ) +
  scale_shape_manual(
    values = c("5XFAD" = 16, "B6SJLF1/J" = 17)
  ) +
  labs(
    title = "Probe accuracy across experimental schedules",
    subtitle = "Age group 3–6 months; mean and 95% confidence intervals",
    x = "Experimental schedule",
    y = "Mean accuracy (%)",
    shape = "Genotype"
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(
      angle = 25,
      hjust = 1,
      color = "black"
    ),
    axis.text.y = element_text(color = "black"),
    axis.title = element_text(color = "black"),
    legend.position = "top"
  )

# Black-and-white public-facing visualization
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
    width = 0.7,
    color = "black",
    linewidth = 0.4
  ) +
  scale_fill_manual(
    values = c(
      "5XFAD" = "grey75",
      "B6SJLF1/J" = "grey35"
    )
  ) +
  labs(
    title = "How accurately did the mice respond?",
    subtitle = "Probe-task comparison in the 3–6 month age group",
    x = "Task condition",
    y = "Average accuracy (%)",
    fill = "Mouse group"
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_text(
      angle = 25,
      hjust = 1,
      color = "black"
    ),
    axis.text.y = element_text(color = "black"),
    axis.title = element_text(color = "black"),
    legend.position = "top"
  )

# Save both figures in the figures folder
ggsave(
  "C:/Users/nikba/OneDrive/Desktop/Neuroscience_DataViz/figures/probe_accuracy_scientific.png",
  plot = scientific_plot,
  width = 9,
  height = 6,
  dpi = 300,
  bg = "white"
)

ggsave(
  "C:/Users/nikba/OneDrive/Desktop/Neuroscience_DataViz/figures/probe_accuracy_public.png",
  plot = public_plot,
  width = 9,
  height = 6,
  dpi = 300,
  bg = "white"
)

# Display the scientific plot
print(scientific_plot)

# Display the public-facing plot
print(public_plot)
