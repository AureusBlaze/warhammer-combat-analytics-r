
# Warhammer 40k units correlations between,stats (Toughness) and point costs.

library(tidyverse)

w40k_data <- read_csv("warhammer_stats.csv")

head(w40k_data)

w40k_processed <- w40k_data %>%
  filter(Faction %in% c("Space Marines", "Orks", "Necrons", "Aeldari", "Tyranids", "Tau")) %>%
mutate(
  DPS = Attacks * Damage,          # Raw Damage Output
  Efficiency = DPS / Points * 100, # How much damage per 100 Resources?
  Role = ifelse(Range > 20, "Ranged", "Melee"), # Classify units
  LogPoints = log(Points)
)

head(w40k_processed)

faction_stats <- w40k_processed %>%
  group_by(Faction) %>%
  summarise(
    Avg_Toughness = mean(Toughness),       # the average strength of units in each faction
    Avg_Points = mean(Points),             # the average cost of units per faction
    Spread_Strength = sd(Strength),        # the variation of unit strength in the same faction (Standard Deviation)
    Count = n()                            # how many Units each faction has
  ) %>%
  arrange(desc(Avg_Toughness))             # Sort by toughest faction

print(faction_stats)

# close to +1 means as toughness goes up cost also goes up.
# close to 0 means that toughness and cost are not related.
#close to -1 means that as toughness goes up, cost goes down.
correlation_r <- cor(w40k_processed$Toughness, w40k_processed$Points)
print(paste("The correlation between Toughness and Points is:", round(correlation_r, 2)))

ggplot(w40k_processed, aes(x = Toughness, y = Points, color = Faction)) +
  geom_jitter(size = 4, alpha = 0.7) +     # Draw points (jitter prevents overlapping)
  geom_smooth(method = "lm", linewidth = .5, se = FALSE, color = "purple", linetype = "dashed") + # Add a trend line
  labs(
    title = "Does Toughness cost more Points?",
    subtitle = paste("Correlation r =", round(correlation_r, 2)),
    x = "Unit Toughness",
    y = "Points Cost"
  ) +
  theme_minimal()



# The Economy of War (DPS vs Points)
  ggplot(w40k_processed, aes(x = Points, y = DPS, color = Faction)) +
  geom_point(size = 5, alpha = 0.7) +
  geom_text(aes(label = Unit), vjust = -1, size = 3, check_overlap = TRUE) +
  
  # Units that are ABOVE the line are "High Value", and below is "Overpriced"
  geom_smooth(method = "lm", se = FALSE, color = "grey", linetype = "dashed") +
  
  labs(
    title = "Damage Output vs. Resource Cost",
    subtitle = "Units above the dashed line are 'Cost Effective'",
    x = "Resource Cost (Points)",
    y = "Raw DPS (Attacks * Damage)"
  ) +
  theme_minimal()


  # (Speed vs Range)
  ggplot(w40k_processed, aes(x = Range, y = Speed, color = Faction)) +
  
  # The Battlefield
  geom_point(size = 4) +
  
  # Divide the graph into 4 quadrants
  geom_vline(xintercept = 20, linetype="dotted") + # Range divider
  geom_hline(yintercept = 7, linetype="dotted") +  # Speed divider
  geom_text(aes(label = Unit), vjust = -1, size = 3, check_overlap = TRUE) +
  
  # Annotate the Quadrants (The "Meta")
  annotate("text", x=50, y=12, label="KITING SNIPERS", color="gray50", fontface="bold") +
  annotate("text", x=5, y=12, label="RUSH ATTACKERS", color="gray50", fontface="bold") +
  annotate("text", x=5, y=5, label="MELEE TANKS", color="gray50", fontface="bold") +
  annotate("text", x=50, y=5, label="ARTILLERY", color="gray50", fontface="bold") +
  
  labs(
    title = "Tactical Profile: How does the faction move?",
    x = "Engagement Range",
    y = "Movement Speed"
  ) +
  theme_minimal()


# Scenario: Who is more reliable? in 1000 simulated battles
# A Horde of 50 weak units vs. A Squad of 5 super-units.
set.seed(123) # Lock the randomness

# Horde: 50 attacks per volley, 10 damage each
horde_attacks <- rbinom(n = 1000, size = 50, prob = 0.50) 
horde_damage  <- horde_attacks * 10  # Convert hits to Damage

# Elite: 5 attacks per volley, 100 damage each
elite_attacks <- rbinom(n = 1000, size = 5, prob = 0.50)
elite_damage  <- elite_attacks * 100 # Convert hits to Damage

# 2. Combine into one table for the graph
combat_sim <- data.frame(
  Damage = c(horde_damage, elite_damage),
  ArmyType = c(rep("Horde (50 x 10dmg)", 1000), rep("Elite (5 x 100dmg)", 1000))
)
  ggplot(combat_sim, aes(x = Damage, fill = ArmyType)) +
  geom_density(alpha = 0.6) + 
  
  # The average line (250 Damage)
  geom_vline(xintercept = 250, linetype="dashed", linewidth=1) +
  
  scale_fill_manual(values = c("gold", "purple")) + # Gold for Elites, Purple for Horde
  
  labs(
    title = "DPS Stability",
    subtitle = "Why 'Deathballs' are risky: High Volatility vs. Consistent Swarms",
    x = "Total Damage Dealt in One Volley",
    y = "Frequency (Probability)"
  ) +
  theme_minimal()