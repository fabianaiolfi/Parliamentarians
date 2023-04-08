# Get Parliamentary data through swissparl 

# Final votes from 51st legislative period ------------------------------------------------------------------------
voting_legislative_period_51 <- swissparl::get_data("Voting",
                                                    Language = "DE",
                                                    IdLegislativePeriod = 51,
                                                    Subject = "Schlussabstimmung")


# Business details of final votes from 51st legislative period ------------------------------------------------------
# Get all BusinessShortNumber (i.e., Business IDs) of final votes
bsn_legislative_period_51 <- unique(voting_legislative_period_51$BusinessShortNumber)

business_legislative_period_51 <- swissparl::get_data("Business",
                                                      Language = "DE",
                                                      BusinessShortNumber = bsn_legislative_period_51)


# Parliamentarians casting final votes in 51st legislative period ------------------------------------------------------
member_council_legislative_period_51 <- swissparl::get_data("MemberCouncil", Language = "DE") # Filtering in get_data() doesn't seem to work here
member_council_legislative_period_51 <- member_council_legislative_period_51 %>%
  filter(PersonNumber %in% unique(voting_legislative_period_51$PersonNumber))

# The National Council counts 200 members. However, this data set counts 213 people.
# The 13 remaining people are parliamentarians who resigned before the legislative period was over.
length(unique(member_council_legislative_period_51$PersonNumber))


# Store data locally ------------------------------------------------------
save(voting_legislative_period_51, file = "data/voting_legislative_period_51.RData")
save(business_legislative_period_51, file = "data/business_legislative_period_51.RData")
save(member_council_legislative_period_51, file = "data/member_council_legislative_period_51.RData")
