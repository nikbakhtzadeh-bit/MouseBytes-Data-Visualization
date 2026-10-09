# MouseBytes 5-Choice Data Visualization

## Project overview

This project explores response accuracy in the five-choice serial reaction time task (5-CSRTT), a behavioural task used to study attention-related performance in mice. The analysis compares 5XFAD mice with B6SJLF1/J mice in the 3–6 month age category across selected probe-task schedules.

## Data source

The data come from the MouseBytes dataset, *Weston-Project: Alzheimer’s mouse models dataset*.

* Source: https://mousebytes.ca
* Dataset DOI: https://doi.org/10.7554/eLife.49630
* File used: `FB_AD_5Choice.csv`
* Data type: Aggregated behavioural data

## Analysis

The analysis selects records from the Probe session for the two genotypes and the 3–6 month age category. Accuracy values are averaged at the animal level for each experimental schedule.

## Visualizations

* `figures/probe_accuracy_scientific.png`: Group means with 95% confidence intervals.
* `figures/probe_accuracy_public.png`: A bar chart designed for a broader audience.

## Limitations

These figures are descriptive and do not establish statistically significant genotype differences or causal effects. Animals may contribute observations to multiple schedules. The suitability of the comparison strain and the interpretation of individual schedules should be verified against the dataset documentation before drawing biological conclusions.

## Reproducibility

The R script `analysis.R` contains the data selection, summary calculations, visualization code, and figure-export commands. The source dataset must be available at the file path expected by the script.
