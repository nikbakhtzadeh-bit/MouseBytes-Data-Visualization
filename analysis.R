
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
    n = n(),  
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
    color = Genotype  
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
  labs(  
    title = "Probe accuracy across experimental schedules",  
    subtitle = "Age group 3–6 months; mean and 95% confidence intervals",  
    x = "Experimental schedule",  
    y = "Mean accuracy (%)",  
    color = "Genotype"  
  ) +  
 scale_color_manual(
  values = c(
    "5XFAD" = "black",
    "B6SJLF1/J" = "grey50"
  )
) +  
  theme_classic()  

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
    width = 0.7  
  ) +  
  labs(  
    title = "How accurately did the mice respond?",  
    subtitle = "Probe-task comparison in the 3–6 month age group",  
    x = "Task condition",  
    y = "Average accuracy (%)",  
    fill = "Mouse group"  
  ) +  
  scale_fill_manual(
  values = c(
    "5XFAD" = "black",
    "B6SJLF1/J" = "grey60"
  )
) +  
  theme_minimal(base_size = 12)  

# Save both figures in the figures folder  
ggsave(  
  "C:/Users/nikba/OneDrive/Desktop/Neuroscience_DataViz/figures/probe_accuracy_scientific.png",  
  plot = scientific_plot,  
  width = 9,  
  height = 6,  
  dpi = 300  
)  

ggsave(  
  "C:/Users/nikba/OneDrive/Desktop/Neuroscience_DataViz/figures/probe_accuracy_public.png",  
  plot = public_plot,  
  width = 9,  
  height = 6,  
  dpi = 300  
)  

# Display the scientific plot  
print(scientific_plot)

# Display the public-facing plot  
print(public_plot)
