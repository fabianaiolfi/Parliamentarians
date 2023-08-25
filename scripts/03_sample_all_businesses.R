
# Create Sample ---------------------------------------------------------------

# Create a sample dataframe for testing purposes

# Always sample the same business items
set.seed(42)
sample_sbn <- all_businesses %>% select(BusinessShortNumber) %>% slice_sample(n = 5)
sample_sbn <- as.vector(sample_sbn$BusinessShortNumber)

# Create sample dataframe
all_businesses <- all_businesses %>%
  dplyr::filter(BusinessShortNumber %in% sample_sbn)

# all_businesses %>% select(BusinessShortNumber)
# A tibble: 5 × 1
# BusinessShortNumber
# <chr>              
# 1 06.069             
# 2 08.062             
# 3 10.019             
# 4 12.075             
# 5 14.470 
