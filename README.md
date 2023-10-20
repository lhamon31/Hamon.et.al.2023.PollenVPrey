# Hamon.et.al.2023.PollenVPrey

These data correspond to a study examing the effects of pollen/prey supplementation on the reproductive success of a carnivorous plant, Dionaea muscipula. To do this, we supplied supplemental pollen and/or prey in a two-way factorial experiment to Dionaea muscipula plants in the field and recorded flower set, fruit set, and seed set. 
We conducted two trials of this experiment - one where plants were given supplemental prey in the previous growing season before seedset (Hamon_2023_DionaeaPollenVPrey_2019PollenVPrey.csv), and one where plants were given supplemental prey in the same growing season as seed production (Hamon_2023_DionaeaPollenVPrey_2020PollenVPrey.csv). 
We also investigated the self-compatibility, pollen-ovule ratio, and per-visit pollinator effectiveness of these species. To determine self compatibility, we supplied flowers with outcross pollen, geitonogamous pollen, autogamous pollen, or left flowers unpollinated and covered. 
To determine pollen-ovule ratio, we counted the number of pollen grains and ovules across a subset of plants. 
To measure pollinator effectiveness, we counted the number of pollen grains deposited by insect taxa after a single visit. 


## Description of the data and file structure
There are 5 data sets included here, all of which start with the name "Hamon_2023_DionaeaPollenVPrey_". 
- 'metadata': explanation of variable names.
- '2019PollenVPreyTrial': plant-level data and seed set collected for the 2019 pollen vs. prey supplementation trial.
- '2020PollenVPreyTrial': plant-level data and seed set collected for the 2020 pollen vs. prey supplementation trial.
- 'SelfCompatibility': plant-level traits and seed sets from the self compatibility experiment. 
- 'PollenCount': pollen count data used to calculate the pollen-ovule ratio.
- 'OvuleCount': ovule count data used to calculate the pollen-ovule ratio. 
- 'PollinatorEffectiveness': pollinator identification and pollen deposition data. 


## Sharing/Access information

N/A

## Code/Software

Analysis performed in R. Packages used include 'dplyr', 'tidyr', 'lme4', 'lmerTest', 'car', and 'emmeans'. 
