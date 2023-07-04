
# Embedding: Create input files

all_businesses$chatgpt_tags <- gsub("\\d+\\.\\s", "", all_businesses$chatgpt_tags)

write.table(
  all_businesses$chatgpt_tags,
  sep = ",",
  here("scripts", "chatgpt_tagging", "input_files", "chatgpt_tags.txt"),
  col.names = F, row.names = F, quote = F
)
