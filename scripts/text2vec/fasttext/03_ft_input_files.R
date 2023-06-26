

# Create input files -----------------------------------------------------

df_colnames <- colnames(df)
df_colnames <- df_colnames[-1]

for (col in df_colnames) {
  write.table(
    df[[col]],
    sep = ",",
    here("scripts", "text2vec", "fasttext", "input_files", paste0(col, ".txt")),
    col.names = F, row.names = F, quote = F
  )
}