# Get Parliamentary data

# Get all items of business from 51st legislative period ------------------

# Retrieve all BusinessShortNumber (i.e., Business IDs) from 51st legislative period
# vote_legislative_period_51 <- swissparl::get_data("Vote",
#                                                   Language = "DE",
#                                                   IdLegislativePeriod = 51)
# Save and load the data to prevent downloading the data every time
# save(vote_legislative_period_51, file = "data/vote_legislative_period_51.RData")
load("data/vote_legislative_period_51.RData")

# Get all Businesses from 51st legislative period (bsn: BusinessShortNumber)
bsn_legislative_period_51 <- vote_legislative_period_51$BusinessShortNumber
bsn_legislative_period_51 <- unique(bsn_legislative_period_51)

# business_legislative_period_51 <- swissparl::get_data("Business",
#                                                       Language = "DE",
#                                                       BusinessShortNumber = bsn_legislative_period_51)
# Save and load the data to prevent downloading the data every time
# save(business_legislative_period_51, file = "data/business_legislative_period_51.RData")
load("data/vote_legislative_period_51.RData")

# Get all votes from from 51st legislative period
# voting_legislative_period_51 <- swissparl::get_data("Voting",
#                                                     Language = "DE",
#                                                     BusinessShortNumber = bsn_legislative_period_51,
#                                                     Subject = "Schlussabstimmung")
# # Save and load the data to prevent downloading the data every time
# save(voting_legislative_period_51, file = "data/voting_legislative_period_51.RData")
load("data/voting_legislative_period_51.RData")

length(unique(voting_legislative_period_51$PersonNumber)) # 213
# make this match with 200 parliamentarians in 51st legislative?

# # Get all active NR parliamentarians
# all_MemberCouncil <- swissparl::get_data("MemberCouncil")#,
# #Language = "DE",
# #Active = TRUE,
# #Council = 1)
# #save(all_MemberCouncil, file = "all_MemberCouncil.RData")
# #load("all_MemberCouncil.RData")
# 
# nr_active <- all_MemberCouncil %>% 
#   filter(Language == "DE") %>% 
#   filter(Active == TRUE) %>% 
#   filter(Council == 1)



swissparl::get_variables("Business")

swissparl::get_glimpse("LegislativePeriod", rows = 20)
swissparl::get_glimpse("Voting", rows = 5)




IdLegislativePeriod

swissparl::get_variables("Session")

swissparl::get_variables("Voting")
swissparl::get_variables("Bill")