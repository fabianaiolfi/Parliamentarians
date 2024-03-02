# Parliamentarians

LUMACSS Capstone Project: Web app displaying the voting records of parliamentarians  
v1.0: http://142.93.168.218/check-your-rep

## Pipeline: From Raw Parliamentary Data to Voting Behaviour Summary

### 1. [Download Parliamentary data](https://github.com/fabianaiolfi/Parliamentarians/blob/main/scripts/01_get_parl_data.R) through [swissparl](https://github.com/zumbov2/swissparl)
- `Business`: Data on items of business, e.g., title, description, and unique identifier
- `Voting`: MP voting behaviour on final votes (“Schlussabstimmungen”). How did every MP vote on each item of business?
- `MemberCouncil`: Data on each MP, e.g., party and canton

### 2. [Use ChatGPT to generate summaries and vote statements for each item of business](https://github.com/fabianaiolfi/Parliamentarians/blob/main/scripts/02_chatgpt_summarisation)
ChatGPT prompt:
```
Das ist ein Parlamentsgeschäft:
[InitialSituation of item of business]
Beantworte diese 2 Fragen. Verwende dabei Einfache Sprache, maximal 15 Wörter und maximal 1 Satz.
1. Welche zentrale Aussage soll ein:e Wähler:in von diesem Text mitnehmen?
2. Vervollständige diesen Satz, damit er zum Geschäft passt: '[Politiker X] stimmt für … '
```

### 3. [Use ChatGPT to tag each item of business](https://github.com/fabianaiolfi/Parliamentarians/blob/main/scripts/05_chatgpt_tagging)
ChatGPT prompt:
```
Hier ist ein Dokument mit einem Titel. Gib dem Dokument 5 bis 10 Kategorien. Jede Kategorie muss 1 bis 3 Wörter umfassen. Gib nur die Kategorien zurück:
[Title of item of business]
[InitialSituation of item of business]
```

### 4. [Link items of business to Sorgenbarometer](https://github.com/fabianaiolfi/Parliamentarians/tree/main/scripts/11_chatgpt_sorgenbarometer)
- Manually retrieve all worries (“Sorgen”) from the last [Worry Barometer](https://www.credit-suisse.com/about-us/en/reports-research/studies-publications/worry-barometer/download-center.html)
- Use the tags from step 3 to [assign items of business to all worries](https://github.com/fabianaiolfi/Parliamentarians/blob/main/scripts/11_chatgpt_sorgenbarometer/02_preprocessing.R#L9-L108)
- Using ChatGPT, generate a summary of an MP’s voting behaviour *for each worry*. Here is an example prompt for a single MP and a single worry:
```
Verwende 1 bis 2 Sätze und Einfache Sprache, um das Abstimmungsverhalten von Ada Marra zum Thema «Neue Armut / Armut jüngerer Generationen» zusammen zu fassen. Alle Punkte habe einen Bezug zum Thema:
- Stimmte gegen die Ablehnung der Mindestlohn-Initiative.
- Stimmte für die Ratifikation des internationalen Arbeitsübereinkommens Nr. 189 zum Schutz von Hausangestellten.
- Stimmte für die Weiterführung der internationalen Zusammenarbeit der Schweiz von 2017 bis 2020.
- Stimmte gegen die stärkere Besteuerung von Kapitaleinkommen.
```

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
- 11_chatgpt_sorgenbarometer: Use the [Worry Barometer](https://www.credit-suisse.com/about-us/en/reports-research/studies-publications/worry-barometer/download-center.html) to group items of business. Then get ChatGPT summaries of voting record based on these groups.
- Futher options: Plain LDA

------------------------------------------------------------------------

## To Dos

### NLP
- [x] Setup further ChatGPT prompts that summarise a parliamentarian's voting behaviour; Summarise sets of votes, e.g. economic votes or specific policy dimensions. In short, make the items of business more accessible to users > Done: Grouped by Worry Barometer topics
- [ ] Group existing topics into larger über-topics
  - [x] Either use tags provided by the parliament or topics in the [Worry Barometer](https://www.credit-suisse.com/about-us/en/reports-research/studies-publications/worry-barometer/download-center.html)
  - [ ] Maybe place über-topics into (another) dropdown, so to only ever display one über-topic at once
  - [ ] [Fix faulty business item categorisations](https://github.com/fabianaiolfi/Parliamentarians/blob/d4864887646ac2d40570d4758eabc19623974aed/documentation/Feedback.txt#L3)
  - [ ] [Look into strange worry barometer formulations](https://github.com/fabianaiolfi/Parliamentarians/blob/d4864887646ac2d40570d4758eabc19623974aed/documentation/Feedback.txt#L13)
- [ ] Generate data on all parliamentarians from last legislatory period to wrap up project for the end of the year

### UI
#### Must
- [x] Increase main dropdown size
- [x] Replace Collapse with Modal
- [ ] Find better way to display Worries Selector/Dropdown
- [ ] Naming / Branding / Logo
- [x] About Page

#### Should
- [ ] Add Table of Contents to top of profile page
- [ ] Apply Swiss punctuation and spelling: `ß` > `ss`, `"` > `«`, etc.

#### Could
- [ ] Speed up switching between parliamentarians
- [ ] Make site responsive
- [ ] See also Issues tagged `[enhancement](https://github.com/fabianaiolfi/Parliamentarians/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)`
