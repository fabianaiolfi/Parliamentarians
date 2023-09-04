
# Load all businesses for web ------------------------------

load(here("data", "all_businesses_web.RData"))
load(here("data", "voting_legislative_period_47.RData"))
load(here("data", "voting_legislative_period_48.RData"))
load(here("data", "voting_legislative_period_49.RData"))
load(here("data", "voting_legislative_period_50.RData"))
load(here("data", "voting_legislative_period_51.RData"))

voting_all_periods <- rbind(voting_legislative_period_47,
                            voting_legislative_period_48,
                            voting_legislative_period_49,
                            voting_legislative_period_50,
                            voting_legislative_period_51)

rm(voting_legislative_period_47,
      voting_legislative_period_48,
      voting_legislative_period_49,
      voting_legislative_period_50,
      voting_legislative_period_51)

voting_all_periods <- voting_all_periods %>% 
  select(PersonNumber, FirstName, LastName, CantonName, DecisionText, BusinessShortNumber)


# Export for Web ------------------------------

# Assuming all_businesses_web and voting_all_periods are your dataframes
write_json(all_businesses_web, here("data", "web", "all_businesses_web.json"))
write_json(voting_all_periods, here("data", "web", "voting_all_periods.json"))
