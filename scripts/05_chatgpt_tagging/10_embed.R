

# Setup -------------------------------------------------------------------

list_params <- list(command = 'print-sentence-vectors',
                    model = here("models", "cc.de.300.bin")) # https://dl.fbaipublicfiles.com/fasttext/vectors-crawl/cc.de.300.bin.gz


# Create Embeddings -------------------------------------------------------------------

res <- fasttext_interface(list_params,
                          path_input = here("scripts", "05_chatgpt_tagging", "input_files", "chatgpt_tags.txt"),
                          path_output = here("scripts", "05_chatgpt_tagging", "vec_files", "chatgpt_tags.txt"))


# Import Embeddings -------------------------------------------------------------------

chatgpt_tag_embeddings <- read_delim(here("scripts", "05_chatgpt_tagging", "vec_files", "chatgpt_tags.txt"), delim = " ", col_names = FALSE)
chatgpt_tag_embeddings$X301 <- NULL


# Add BusinessShortNumber -------------------------------------------------------------------

chatgpt_tag_embeddings$BusinessShortNumber <- all_businesses$BusinessShortNumber
chatgpt_tag_embeddings <- as.data.frame(chatgpt_tag_embeddings)
rownames(chatgpt_tag_embeddings) <- chatgpt_tag_embeddings$BusinessShortNumber
chatgpt_tag_embeddings$BusinessShortNumber <- NULL