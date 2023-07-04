#cat(chatgpt_output_df$query_central_stmnt)

load(here("data", "all_businesses_and_tags_230703.RData"))


# Kategorisiere den Text und gebe nur die Kategorien zurück: (chatgpt_output_20230703_163500.RData) --------------------------------------------------------------

# 06.069
# - Terrorismusbekämpfung - Abkommen mit den Vereinigten Staaten
# 2
# 08.062
# Die Kategorien des Textes sind: - Arbeitslosenversicherungsgesetz - Beitragssatz - Leistungen - Entschuldung - Solidaritätsbeitrag - Arbeitslosigkeit - Arbeitsvermittlungszentren - Wiedereingliederung - Integrationsmaßnahmen - Finanzierungskonzept - Konjunkturzyklus - Darlehensschuld -
#   3
# 10.019
# - Raumplanungsgesetz - Volksinitiative - Landschaftsschutz - Zersiedelung - Kulturlandverlust - Siedlungsentwicklung - Richtpläne - Steuerung der Siedlungsentwicklung - Raum und Umwelt - Bauzonen - Neueinzonungen - Bauland
# 4
# 12.075
# - Abkommen - Dienstleistungen - Frankreich - CERN - Unternehmen - Recht - Gelände - Organisation - Genf - Schweiz - Territorialitätsprinzip - Mitarbeitende - Arbeitsbedingungen - soziale Konflikte - Demonstrationen - Streiks - Verhandlungen - Kantons Genf - Örtlichkeit
# 5
# 14.470
# Die Kategorien des Textes sind: - Stiftungsrecht - Stärkung des Stiftungsstandortes Schweiz




# "Gib dem Text zwischen 5 und 10 Kategorien. Jede Kategorie muss 1 bis 3 Wörter umfassen. Gebe nur die Kategorien zurück und zwar als kommagetrennte Liste:" (chatgpt_output_20230703_164642.RData) --------------------------------------------------------------

# 1
# 06.069
# 1. Terrorismusbekämpfung 2. Abkommen 3. Internationale Zusammenarbeit 4. Strafverfolgungsbehörden 5. Polizeizusammenarbeit 6. Ermittlungsgruppen 7. Informationsaustausch 8. Terrorismusfinanzierung 9. Rechtshilfe 10. Kooperation
# 2
# 08.062
# 1. Arbeitslosenversicherungsgesetz 2. Revision 3. Beitragssatz 4. Leistungen 5. Entschuldung 6. Solidaritätsbeitrag 7. Arbeitsvermittlungszentren 8. Integrationsmassnahmen 9. Finanzierungskonzept 10. Rechnungsausgleich
# 3
# 10.019
# 1. Volksinitiative 2. Raumplanungsgesetz 3. Landschaftsinitiative 4. Teilrevision 5. Zersiedelung 6. Kulturlandverlust 7. Siedlungsentwicklung 8. Richtpläne 9. Bauzonen 10. Kulturlandschutz
# 4
# 12.075
# 1. Abkommen 2. Dienstleistungen 3. Frankreich 4. CERN 5. Recht 6. Unternehmen 7. Territorialitätsprinzip 8. Arbeitsbedingungen 9. Konflikte 10. Verhandlungen
# 5
# 14.470
# 1. Stiftungsstandort 2. Änderungen des Stiftungsrechts 3. Kommission für Rechtsfragen 4. Vereinfachung von Änderungen 5. Bundesrat 6. Stärkung des Stiftungsstandortes 7. Stiftungsurkunde 8. Rechtsform der Stiftung 9. Flexibilität des geltenden Rechts 10. Modernisierung des Stiftungs



# "Gib dem Text zwischen 5 und 10 Kategorien. Jede Kategorie muss 1 bis 3 Wörter umfassen. Gebe nur die Kategorien als kommagetrennte Aufzählung zurück:\n" (chatgpt_output_20230703_212433.RData) --------------------------------------------------------------

# 06.069
# 1. Terrorismusbekämpfung 2. UNO-Übereinkommen 3. Strafverfolgungsbehörden 4. Operative Working Arrangement (OWA) 5. Polizeizusammenarbeit 6. Terrorismusfinanzierung 7. Ermittlungsgruppen 8. Informationsaustausch 9. Rechtshilfebereich 10. Staatsvertrag
# 2
# 08.062
# 1. Arbeitslosenversicherung 2. Beitragssatz 3. Leistungen 4. Revision 5. Finanzierung 6. Entschuldung 7. Versicherungsprinzip 8. Sparmassnahmen 9. Effizienz 10. Solidaritätsbeitrag
# 3
# 10.019
# 1. Volksinitiative 2. Raumplanungsgesetz 3. Landschaftsinitiative 4. Teilrevision 5. Zersiedelung 6. Kulturlandverlust 7. Siedlungsentwicklung 8. Richtpläne 9. Bauzonen 10. Kantone
# 4
# 12.075
# 1. Abkommen 2. Dienstleistungen 3. Schweiz 4. Frankreich 5. CERN 6. Recht 7. Territorialitätsprinzip 8. Unternehmen 9. Arbeitsbedingungen 10. Konflikte
# 5
# 14.470
# 1. Stiftungsrecht 2. Änderungen 3. Stifterrechte 4. Stiftungsurkunde 5. Bundesrat 6. Stärkung 7. Rechtskommission 8. Flexibilität 9. Modernisierung 10. Schweiz


# "Hier ist ein Dokument mit einem Titel. Gib dem Dokument 5 bis 10 Kategorien. Jede Kategorie muss 1 bis 3 Wörter umfassen. Gib nur die Kategorien zurück:\n (chatgpt_output_20230703_213415.RData) --------------------------------------------------------------

# 06.069
# 1. Terrorismusbekämpfung 2. Internationale Zusammenarbeit 3. UNO-Übereinkommen 4. Operative Working Arrangement (OWA) 5. Polizeizusammenarbeit 6. Terrorismusfinanzierung 7. Ermittlungsgruppen 8. Informationsaustausch 9. Rechtshilfebereich 10. Strafverfahren
# 2
# 08.062
# 1. Arbeitslosenversicherung 2. Revision 3. Beitragssatz 4. Leistungen 5. Entschuldung 6. Finanzierungskonzept 7. ALV (Arbeitslosenversicherung) 8. Rechnungsausgleich 9. Sparmassnahmen 10. Wiedereingliederungsmassnahmen
# 3
# 10.019
# 1. Raumplanungsgesetz 2. Teilrevision 3. Volksinitiative 4. Landschaftsinitiative 5. Zersiedelung 6. Kulturlandverlust 7. Siedlungsentwicklung 8. Richtpläne 9. Bauzonen 10. Kulturlandschutz
# 4
# 12.075
# 1. Abkommen 2. Dienstleistungen 3. Frankreich 4. CERN 5. Recht
# 5
# 14.470
# 1. Stiftungsrecht 2. Änderungen 3. Stifterrechte 4. Stiftungsurkunde 5. Bundesrat 6. Stärkung des Stiftungsstandortes 7. Parlamentarische Initiative 8. Rechtsform der Stiftung 9. Flexibilität des geltenden Rechts 10. Modernisierung des Rechts



# Hier ist ein Dokument mit einem Titel. Gib dem Dokument 5 bis 10 Kategorien. Jede Kategorie muss 1 bis 3 Wörter umfassen. Gib nur die Kategorien zurück:\n (chatgpt_output_20230703_214511.RData) --------------------------------------------------------------

# Combine all the text into a single character vector
all_tags <- paste(all_businesses$chatgpt_tags, collapse = " ")

# Split the combined text into individual words
words <- unlist(strsplit(all_tags, "\\d+\\.\\s"))
words <- gsub('\n', '', words) # remove \n
words <- gsub('\\s$', '', words) # remove trailing whitespace

# Count the occurrences of each word
word_counts <- table(words)
word_counts <- as.data.frame(word_counts)













