# Load Locally Stored Parliamentary Data ---------------------------------------------------------------
# Only run this script if data has already been downloaded via 01_get_parl_data.R

load(here("data", "voting_legislative_period_51.RData"))
load(here("data", "business_legislative_period_51.RData"))
load(here("data", "member_council_legislative_period_51.RData"))


# Create Sample ---------------------------------------------------------------
# Only run this segment if you want to create a sample dataframe for testing purposes

# Always sample the same business items
# sample_sbn <- c("22.028", "22.030", "20.063", "20.064", "22.033")

# Create sample dataframe
# business_legislative_period_51 <- business_legislative_period_51 %>% 
#   filter(BusinessShortNumber %in% sample_sbn)