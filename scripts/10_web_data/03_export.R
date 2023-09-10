
# Export for Web ------------------------------

#write_json(all_businesses_web, here("data", "web", "all_businesses_web.json"))
#write_json(voting_all_periods_edit, here("data", "web", "voting_all_periods.json"))


# Export for vue ------------------------------

# Convert vue DF to a named list
voting_all_periods_vue <- setNames(as.list(voting_all_periods_vue$value), voting_all_periods_vue$key)
all_businesses_vue <- setNames(all_businesses_vue$data, all_businesses_vue$BusinessShortNumber)

# Convert the named list to JSON
voting_all_periods_vue <- toJSON(voting_all_periods_vue, auto_unbox = TRUE)
all_businesses_vue <- toJSON(all_businesses_vue, auto_unbox = TRUE)

# Optionally, write the JSON to a file
write(voting_all_periods_vue, here("vue", "antd-demo", "src", "namesSBN.json"))
write(all_businesses_vue, here("vue", "antd-demo", "src", "businessItems.json"))
