# Parliamentarians

LUMACSS Capstone Project: Web app displaying the voting records of parliamentarians

## Subproject: *Data Mining in R* Capstone Project

Aim of this sub-project is to lay a foundation for the LUMACSS Capstone Project. The scope of this sub-project are final votes cast by parliamentarians of the Swiss National Council in the 51st legislative period. Details of this sub-project are provided by the [report](https://github.com/fabianaiolfi/Parliamentarians/tree/main/report).

The output of this sub-project are two Shiny web apps: - [Abstimmungsverhalten Nationalrät:innen 2020--2023](https://a88fuu-fabian-aiolfi.shinyapps.io/abstimmungsverhalten/) - [ChatGPT Output Evaluation](https://a88fuu-fabian-aiolfi.shinyapps.io/ChatGPT_Output_Evaluation/)

## File Structure

-   [`documentation`](https://github.com/fabianaiolfi/Parliamentarians/tree/main/documentation): Documents ChatGPT conversations.
-   [`report`](https://github.com/fabianaiolfi/Parliamentarians/tree/main/report): Contains the Data Mining Captstone Project report.
-   [`scripts`](https://github.com/fabianaiolfi/Parliamentarians/tree/main/scripts): R scripts used to download, process and display the data in the final Shiny web app.\
-   [`scripts/query_optimisation`](https://github.com/fabianaiolfi/Parliamentarians/tree/main/scripts/query_optimisation): R scripts used to create the Shiny web app that helps evaluate different OpenAI API natural language queries.

------------------------------------------------------------------------

## Scripts Documentation

-   00_sandbox: Tryouts
-   01_query_optimisation: How can ChatGPT be best queried to create sensible summaries?
-   02_chatgpt_summarisation: Pipeline to let ChatGPT create summaries of business descriptions
-   03_shiny_app: Create Shiny App which ChatGPT summarisation data
-   04_text2vec: Create embeddings using fasttext; Use all available information as features ([details](https://github.com/fabianaiolfi/Parliamentarians/blob/00f1a7fceb99fb1fdf9951c44bf74051d29cb2ec/scripts/text2vec/fasttext/04_embed.R#L115)); Use hierarchical clustering
- 05_chatgpt_tagging: Use ChatGPT to create tags for each item of business
- 06_all_features: Combine all features (including chatgpt summaries and chatgpt tags) into a single embedding and then cluster
- 07_BERTopic: …
- 08_main_tag_cluster: Create hierarchical clusters **within** main tag groups
- Futher options: Plain LDA

------------------------------------------------------------------------

## UI To Dos

- [ ] Group existing topics into larger über-topics
  - [ ] Either use tags provided by the parliament or topics in the [Worry Barometer](https://www.credit-suisse.com/about-us/en/reports-research/studies-publications/worry-barometer/download-center.html)
  - [ ] Maybe place über-topics into (another) dropdown, so to only ever display one über-topic at once
- [ ] Maybe add Table of Contents to top of page
- [x] Increase main dropdown size
- [ ] Speed up switching between parliamentarians
- [ ] Make site responsive
- [ ] See also Issues tagged `enhancement`
