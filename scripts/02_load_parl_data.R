
# Legislative Periods
leg_periods <- c(47, 48, 49, 50, 51)

# Load Locally Stored Parliamentary Data ---------------------------------------------------------------
# Only run this script if data has already been downloaded via 01_get_parl_data.R

load(here("data", "voting_legislative_period_51.RData"))
load(here("data", "member_council_legislative_period_51.RData"))

for (i in leg_periods) {
  load(here("data", paste0("business_legislative_period_", i, ".RData")))
}

all_businesses <- rbind(business_legislative_period_47,
                        business_legislative_period_48,
                        business_legislative_period_49,
                        business_legislative_period_50,
                        business_legislative_period_51)

rm(business_legislative_period_47,
      business_legislative_period_48,
      business_legislative_period_49,
      business_legislative_period_50,
      business_legislative_period_51)

# Store data locally ------------------------------------------------------
#save(all_businesses, file = here("data", "all_businesses.RData"))

# Create Sample ---------------------------------------------------------------
# Only run this segment if you want to create a sample dataframe for testing purposes

# Always sample the same business items
# set.seed(42)
# sample_sbn <- all_businesses %>% select(BusinessShortNumber) %>% slice_sample(n = 5)
# sample_sbn <- as.vector(sample_sbn$BusinessShortNumber)

# Create sample dataframe
# all_businesses <- all_businesses %>%
#   dplyr::filter(BusinessShortNumber %in% sample_sbn)
# 
# all_businesses %>% select(BusinessShortNumber)
# A tibble: 5 × 1
# BusinessShortNumber
# <chr>              
# 1 06.069             
# 2 08.062             
# 3 10.019             
# 4 12.075             
# 5 14.470 

