
# Load all businesses
load(here("data", "all_businesses_and_summaries.RData"))

# Load vector dataframe
#load(here("data", "all_vecs_230703.Rda"))


# Setup Dataframe, one main tag per line
df <- all_businesses %>% 
  select(-c(ID, Language, BusinessType, BusinessTypeAbbreviation, DraftText, DocumentationText, MotionText, FederalCouncilResponseText, FederalCouncilProposal, FederalCouncilProposalDate, FederalCouncilProposalText, BusinessStatus, BusinessStatusText, BusinessStatusDate, ResponsibleDepartment, ResponsibleDepartmentAbbreviation, IsLeadingDepartment, Tags, Category, Modified, SubmissionDate, SubmissionCouncil, SubmissionCouncilAbbreviation, SubmissionSession, SubmissionLegislativePeriod, FirstCouncil1, FirstCouncil1Abbreviation, FirstCouncil2, FirstCouncil2Name, FirstCouncil2Abbreviation)) %>% 
  mutate(main_tag = TagNames) %>% # Save main tag
  mutate(main_tag = gsub("\\|.*", "", main_tag)) %>%
  separate_rows(main_tag, sep = "\\|") %>% # Transform column to have one tag per row
  mutate(TagNames = gsub("\\|", " ", TagNames))

table(df$main_tag)

# Create vector of main tags
main_tags <- df %>% 
  select(main_tag) %>% distinct(main_tag)
main_tags <- as.vector(main_tags$main_tag)


# Add BusinessShortNumber to vectors
combined_vecs$BusinessShortNumber <- all_businesses$BusinessShortNumber


# Example dataframe with most amount of topics
df_subset <- df %>% dplyr::filter(main_tag == "Sicherheitspolitik")


# Create vector of BusinessShortNumbers
finanzwesen_bsn <- df_subset %>% select(BusinessShortNumber)
finanzwesen_bsn <- as.vector(finanzwesen_bsn$BusinessShortNumber)


# Filter for finanzwesen_bsn
finanzwesen_vectors <- combined_vecs %>% dplyr::filter(BusinessShortNumber %in% finanzwesen_bsn)
finanzwesen_vectors$BusinessShortNumber <- NULL


####### clustering

# Prepare DF ---------------------------------------------------------------------

finanzwesen_vectors_scaled <- scale(finanzwesen_vectors)
finanzwesen_vectors_scaled <- as.data.frame(finanzwesen_vectors_scaled)


# Hierarchical clustering ---------------------------------------------------------------------
# https://www.statology.org/hierarchical-clustering-in-r/

# Compute distance matrix
d <- dist(finanzwesen_vectors_scaled[,c(1:300)], method = "euclidean")
d <- as.dist(d)

# Perform hierarchical clustering using Ward's method
final_clust <- hclust(d, method = "ward.D2")
#final_clust <- hclust(d, method = "average") # somewhat interesting results


# Cut the dendrogram into k clusters
groups <- cutree(final_clust, k = 10)

# Append cluster labels to df
df_subset <- cbind(df_subset, cluster = groups)
#all_businesses_cluster <- all_businesses

df_subset %>% 
  dplyr::filter(cluster == floor(runif(1, min = 1, max = 11))) %>%
  # dplyr::filter(cluster == 3) %>%
  select(BusinessShortNumber, cluster, TagNames, Title, InitialSituation, chatgpt_summaries) %>%
  View()
