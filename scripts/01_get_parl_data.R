# Get Parliamentary data through swissparl

# Legislaturperioden der Bundesversammlung (https://de.wikipedia.org/wiki/Legislaturperiode#Schweiz)
# 1999–2003 (46.) No entries found!
# 2003–2007 (47.)
# 2007–2011 (48.)
# 2011–2015 (49.)
# 2015–2019 (50.)
# 2019–2023 (51.)

# Run this script to download parliamentary through the swissparl wrapper
# Warning: Takes around 15-30 minutes

# Final votes from a legislative period ------------------------------------------------------------------------
voting_legislative_period_50 <- swissparl::get_data("Voting",
                                                    Language = "DE",
                                                    IdLegislativePeriod = 50,
                                                    Subject = "Schlussabstimmung")


# Business details of final votes from a legislative period ------------------------------------------------------
# Get all BusinessShortNumber (i.e., Business IDs) of final votes
bsn_legislative_period_50 <- unique(voting_legislative_period_50$BusinessShortNumber)

business_legislative_period_50 <- swissparl::get_data("Business",
                                                      Language = "DE",
                                                      BusinessShortNumber = bsn_legislative_period_50)


# Parliamentarians casting final votes in a legislative period ------------------------------------------------------
member_council <- swissparl::get_data("MemberCouncil", Language = "DE") # Filtering in get_data() doesn't seem to work here
member_council_legislative_period_50 <- swissparl::get_data("MemberCouncil", Language = "DE") # Filtering in get_data() doesn't seem to work here
member_council_legislative_period_50 <- member_council_legislative_period_50 %>%
  filter(PersonNumber %in% unique(voting_legislative_period_50$PersonNumber))

# The National Council counts 200 members. However, this data set counts 213 people.
# The 13 remaining people are parliamentarians who resigned before the legislative period was over.
length(unique(member_council_legislative_period_50$PersonNumber))


# Store data locally ------------------------------------------------------
save(voting_legislative_period_50, file = here("data", "voting_legislative_period_50.RData"))
save(business_legislative_period_50, file = here("data", "business_legislative_period_50.RData"))
save(member_council_legislative_period_50, file = here("data", "member_council_legislative_period_50.RData"))
save(member_council, file = here("data", "member_council.RData"))
