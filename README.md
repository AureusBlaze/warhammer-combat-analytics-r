# ⚔️ Warhammer 40k: Unit Economics & Monte Carlo Combat Analytics

An exploratory data analysis (EDA) and probabilistic combat simulation project written in **R** using `tidyverse` and `ggplot2`. This project evaluates tabletop unit efficiency, statistical correlation between attributes and point costs, and risk variance in army compositions.

---

## 📌 Project Overview

Tabletop army building in Warhammer 40,000 revolves around optimizing limited resource points. This project uses statistical modeling to answer key tactical questions:
1. **Are you overpaying for toughness?** Quantifies the correlation between defensive resilience and point costs.
2. **Which units offer the highest return on investment?** Compares raw damage potential (DPS) against deployment cost.
3. **How do factions position and maneuver?** Maps army units into four distinct movement and engagement doctrines.
4. **Is an elite 'Deathball' better than an endless 'Horde'?** Simulates 1,000 battles using binomial distributions to model DPS volatility and reliability.

---

## 📊 Analytical Breakdown

### 1. Toughness vs. Point Cost Correlation
- Evaluates Pearson correlation coefficient ($r$) between defensive resilience (`Toughness`) and resource cost (`Points`).
- Fits a linear regression trend line (`geom_smooth(method = "lm")`) across factions (Space Marines, Orks, Necrons, Aeldari, Tyranids, Tau) to identify cost scaling.

### 2. The Economy of War (DPS Efficiency)
- Derives metrics:
  $$\text{DPS} = \text{Attacks} \times \text{Damage}$$
  $$\text{Efficiency} = \frac{\text{DPS}}{\text{Points}} \times 100$$
- Labels units above the linear regression threshold as **High Value / Cost Effective** and units below as **Overpriced / Luxury**.

### 3. Tactical Profile Mapping (Range vs. Speed)
Divides the engagement spectrum into four quadrants:
- 🎯 **Kiting Snipers**: High speed, long range (harass and avoid engagement).
- ⚡ **Rush Attackers**: High speed, close range (aggressive flankers and chargers).
- 🛡️ **Melee Tanks**: Low speed, close range (objective holders and frontline sponges).
- 💥 **Artillery**: Low speed, long range (stationary fire support).

### 4. Monte Carlo Combat Simulation (DPS Stability)
Simulates $n = 1,000$ volleys comparing:
- **Swarm Horde**: 50 attacks per volley, 10 damage each ($p = 0.50$ hit probability).
- **Elite Deathball**: 5 attacks per volley, 100 damage each ($p = 0.50$ hit probability).

Generates probability density curves (`geom_density`) around the expected mean (250 Damage), showing how high-stakes elite units suffer from outcome variance while horde units guarantee consistent damage output.

---

## 📁 Repository Structure

```
warhammer-combat-analytics-r/
├── .gitignore               # Ignores R session caches (.RData, .Rhistory)
├── README.md                # Project documentation and statistical breakdown
├── main.R                   # Primary R analysis and simulation script
├── warhammer_stats.csv      # Core unit statistics dataset
└── data/                    # Raw dataset archives
    ├── Warhammer_Stats.csv
    └── Warhammer_DataSet_Archive.zip
```

---

## 🚀 Quick Start

### 1. Prerequisites
Make sure **R** (version 4.0+) is installed. Install the required R packages:

```r
install.packages("tidyverse")
```

### 2. Clone the Repository
```bash
git clone https://github.com/AureusBlaze/warhammer-combat-analytics-r.git
cd warhammer-combat-analytics-r
```

### 3. Run the Analysis

#### From Terminal / CLI
```bash
Rscript main.R
```

#### From RStudio
1. Open `main.R` in RStudio.
2. Set working directory to the project folder (`Session > Set Working Directory > To Source File Location`).
3. Run the script (`Ctrl + Shift + Enter` or `Source`).

---

## 🛠️ Tech Stack
- **R** (Statistical computing & modeling)
- **tidyverse** (Data manipulation with `dplyr` & reading with `readr`)
- **ggplot2** (Data visualization & probability density estimation)
