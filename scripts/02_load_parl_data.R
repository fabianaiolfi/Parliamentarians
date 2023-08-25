
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
