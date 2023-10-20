
# All Businesses Preprocessing ----------------------------------------

# Remove all "Aussenwirtschaftspolitik Berichte"
all_businesses_eval <- all_businesses_eval %>%
  dplyr::filter(!str_detect(Title, "Aussenwirtschaftspolitik"))


# Sorgen Barometer -------------------------------------------------------------

# Add each item of business to a "Sorge" from the 2022 Sorgenbarometer

# Define terms for each "Sorge"
umwelt <- c("Umweltschutz", "Klimawandel", "Umweltkatastrophen", "Umwelt", "Landwirtschaft", "CO2", "Netto-Null", "Klima", "Klimaschutz", "Tierschutz", "Gewässer", "Landschaft", "Naturschutz", "Mineralölsteuergesetz", "Gentechnik", "Geschützte Arten", "Jagdgesetz", "Windenergieanlagen") # Umweltschutz / Klimawandel / Umweltkatastrophen
ahv <- c("AHV", "Altersvorsorge", "IV") # AHV / Altersvorsorge
energiefragen <- c("Energiefragen", "Kernenergie", "AKW", "Kernkraftwerk", "Energie", "Strom") # Energiefragen / Kernenergie
europa <- c("EU", "Rahmenabkommen", "Europäisch", "Lissabon", "FADO") # Beziehung zu Europa, EU, Rahmenabkommen, Zugang zum europäischen Markt
inflation <- c("Inflation", "Geldentwertung", "Teuerung", "Hochpreisinsel") # Inflation / Geldentwertung / Teuerung
gesundheitsfragen <- c("Gesundheitsfragen", "Krankenkasse", "Prämien", "Gesundheit", "Krankenversicherung", "Arzneimitteln", "Arzt", "Medikament", "Generika", "Drogen", "Pflegefachpersonen", "Pflegeberufe", "Medizinalcannabis", "Organspende", "Ambulante Grundversorgung") # Gesundheitsfragen / Krankenkasse / Prämien
versorgungssicherheit <- c("Versorgungssicherheit", "Versorgung", "Ernährungssicherheit") # Versorgungssicherheit (Energie, Medikamente, Nahrungsmittel)
ukraine <- c("Ukraine") # Der Krieg in der Ukraine
auslaender <- c("Ausländer", "Personenfreizügigkeit", "Zuwanderung", "Einwanderung", "Schengen", "Dublin", "Grenzgänger", "Einbürgerung", "Migration", "Schwarzarbeit") # Ausländerinnen und Ausländer / Personenfreizügigkeit / Zuwanderung
fluechtlinge <- c("Flüchtlinge", "Asylfragen", "Asyl", "Einwanderung", "Integration", "Ausschaffung") # Flüchtlinge / Asylfragen
benzinpreis <- c("Benzinpreis", "Erdölpreis", "Diesel") # Benzin- / Erdölpreis
arbeitslosigkeit <- c("Arbeitslosigkeit", "Jugendarbeitslosigkeit", "Arbeitslos", "Arbeitslosenversicherung", "Arbeitsplätze") # Arbeitslosigkeit / Jugendarbeitslosigkeit
globalisierung <- c("Globalisierung", "Global", "Marktöffnung", "Informationsaustausch", "Bilateral") # weltweite, globale Abhängigkeiten Wirtschaft / Globalisierung
neutralitaet <- c("Neutralität", "Neutral") # Verlust der Neutralität
wohnkosten <- c("Wohnkosten", "Mietpreise", "Miete", "Grundstück", "Referenzzins") # erhöhte Wohnkosten, Anstieg Mietpreise
corona <- c("Corona", "Pandemie", "covid", "COVID", "covid-19", "COVID-19", "Covid") # Corona-Pandemie und ihre Folgen
sozial <- c("Sozialwerke", "sozial", "Familienzulagen", "Familie", "Jugendschutz", "Jugend", "Mutter", "Vater", "Arbeitsgesetz", "Arbeitnehmerrechte", "Arbeitnehmerschutz", "Entlasten", "Soziale Sicherheit", "Frauen", "Einkommensverteilung", "Behinderung", "KESB", "Kinderbetreuung") # soziale Sicherheit / Sicherung der Sozialwerke
armut <- c("Armut", "Mindestlohn", "Löhne") # neue Armut / Armut jüngerer Generationen
weltordnung <- c("Weltordnung") # neue Weltordnung, Aufstieg Chinas, der Westen unter Druck
zusammenleben <- c("Zusammenleben", "Toleranz", "Partnerschaft", "Polarisierung", "Gleichstellung", "Geschlechtsänderung") # Zusammenleben in der Schweiz / Toleranz

# Further Topics
sicherheit <- c("Militär", "Armee", "Polizei", "Stabilität", "NATO", "Munition", "Rüstung", "Terrorismus", "Frieden", "Grenzkontrollen", "Militärstrafprozess", "Kampfflugzeug", "Gripen", "Waffen", "Terror", "Al-Qaïda", "Kriegsmaterialgesetz")
kriminalitaet <- c("Geldwäscherei", "Kriminalität", "Menschenhandel", "Opfer", "Kinderpornografie", "Kinderprostitution", "Kindersextourismus", "Kinderverkauf", "Korruption", "Gewalt", "Drogen", "Straftat", "GovWare", "Verbrechen")
verkehr <- c("Strassen", "Flugsicherheit", "Stau", "Autobahn", "SBB", "Klebevignette", "Luftfahrtgesetz", "Cargo sous terrain", "E-Vignette", "Autobahnvignette", "Eisenbahn", "Seilbahn", "Flug", "Gotthard", "Tunnel", "NEAT", "Güter", "Strasse", "S-Bahn", "Velo", "Auto", "Fahrrad", "Schiff", "Verkehrsmedizinische Untersuchung")
datenschutz <- c("Datenschutz", "Daten")
bildung <- c("Bildung", "Bildungsförderung", "Forschungsförderung", "Forschung", "Innovation", "Innovationsförderung", "CERN", "ETH", "Schule", "Universität", "Innosuisse")
menschenrechte <- c("Völkerrecht", "Kriegsverbrechen", "Zwangsarbeit", "Menschenrechte")
medien <- c("Service Public", "Radio", "Fernsehen", "TV", "SRG", "Empfangsgebühr", "Presse", "Zeitungen", "Zeitschriften")

# Function to check if any of the terms from a vector are substrings of chatgpt_tags_clean
is_in_vector <- function(tags_str, vec) {
  any(sapply(vec, function(v) str_detect(tags_str, fixed(v))))
}

# Add TRUE/FALSE column to all businesses for each "Sorge"
all_businesses_sorgen <- all_businesses_eval %>%
  select(BusinessShortNumber, Title, InitialSituation_clean, TagNames, chatgpt_summaries, chatgpt_tags_clean) %>% 
  rowwise() %>%
  # Sorgen
  mutate(umwelt = if_else(is_in_vector(chatgpt_tags_clean, umwelt), T, F),
         ahv = if_else(is_in_vector(chatgpt_tags_clean, ahv), T, F),
         energiefragen = if_else(is_in_vector(chatgpt_tags_clean, energiefragen), T, F),
         europa = if_else(is_in_vector(chatgpt_tags_clean, europa), T, F),
         inflation = if_else(is_in_vector(chatgpt_tags_clean, inflation), T, F),
         gesundheitsfragen = if_else(is_in_vector(chatgpt_tags_clean, gesundheitsfragen), T, F),
         versorgungssicherheit = if_else(is_in_vector(chatgpt_tags_clean, versorgungssicherheit), T, F),
         ukraine = if_else(is_in_vector(chatgpt_tags_clean, ukraine), T, F),
         auslaender = if_else(is_in_vector(chatgpt_tags_clean, auslaender), T, F),
         fluechtlinge = if_else(is_in_vector(chatgpt_tags_clean, fluechtlinge), T, F),
         benzinpreis = if_else(is_in_vector(chatgpt_tags_clean, benzinpreis), T, F),
         arbeitslosigkeit = if_else(is_in_vector(chatgpt_tags_clean, arbeitslosigkeit), T, F),
         globalisierung = if_else(is_in_vector(chatgpt_tags_clean, globalisierung), T, F),
         neutralitaet = if_else(is_in_vector(chatgpt_tags_clean, neutralitaet), T, F),
         wohnkosten = if_else(is_in_vector(chatgpt_tags_clean, wohnkosten), T, F),
         corona = if_else(is_in_vector(chatgpt_tags_clean, corona), T, F),
         sozial = if_else(is_in_vector(chatgpt_tags_clean, sozial), T, F),
         armut = if_else(is_in_vector(chatgpt_tags_clean, armut), T, F),
         weltordnung = if_else(is_in_vector(chatgpt_tags_clean, weltordnung), T, F),
         zusammenleben = if_else(is_in_vector(chatgpt_tags_clean, zusammenleben), T, F),
         # Further topics
         sicherheit = if_else(is_in_vector(chatgpt_tags_clean, sicherheit), T, F),
         kriminalitaet = if_else(is_in_vector(chatgpt_tags_clean, kriminalitaet), T, F),
         verkehr = if_else(is_in_vector(chatgpt_tags_clean, verkehr), T, F),
         datenschutz = if_else(is_in_vector(chatgpt_tags_clean, datenschutz), T, F),
         bildung = if_else(is_in_vector(chatgpt_tags_clean, bildung), T, F),
         menschenrechte = if_else(is_in_vector(chatgpt_tags_clean, menschenrechte), T, F),
         medien = if_else(is_in_vector(chatgpt_tags_clean, medien), T, F))


# Add Vote Statement and Sorge to the same dataframe; Each vote_statement is associated with a Sorge
vote_statement <- vote_statement_vue %>% select(PersonNumber, BusinessShortNumber, vote_statement)

all_businesses_sorgen_merge <- all_businesses_sorgen %>% 
  select(-Title, -InitialSituation_clean, -TagNames, -chatgpt_summaries, -chatgpt_tags_clean)

# Make some manual adjustments, because of NAs in chatgpt_tags_clean
all_businesses_sorgen_merge$sicherheit[all_businesses_sorgen_merge$BusinessShortNumber == "12.073"] <- TRUE
all_businesses_sorgen_merge$kriminalitaet[all_businesses_sorgen_merge$BusinessShortNumber == "12.065"] <- TRUE
all_businesses_sorgen_merge$sicherheit[all_businesses_sorgen_merge$BusinessShortNumber == "21.069"] <- TRUE

vote_statement <- vote_statement %>% 
  left_join(all_businesses_sorgen_merge, by = "BusinessShortNumber")

vote_statement <- vote_statement %>%
  pivot_longer(cols = c(-PersonNumber, -BusinessShortNumber, -vote_statement), names_to = "sorge", values_to = "value") %>%
  dplyr::filter(value) %>%
  select(-value)

# Create prompt for each person and for each topic

prompt_vote_statement_sorge <- vote_statement %>% 
  select(-BusinessShortNumber) %>% 
  mutate(vote_statement = paste0("- ", vote_statement)) %>% # Add bullet point infront of each vote statement
  group_by(PersonNumber, sorge) %>% 
  mutate(prompt = paste(vote_statement, collapse = "\n")) %>%
  ungroup() %>% 
  select(-vote_statement) %>% 
  distinct(PersonNumber, sorge, .keep_all = T) %>% 
  left_join(person_number_index, by = "PersonNumber") %>% 
  mutate(sorge_long = case_when(sorge == "zusammenleben" ~ "Zusammenleben in der Schweiz / Toleranz",
                                sorge == "globalisierung" ~ "weltweite, globale Abhängigkeiten Wirtschaft / Globalisierung",
                                sorge == "sicherheit" ~ "Sicherheit",
                                sorge == "menschenrechte" ~ "Menschenrechte",
                                sorge == "sozial" ~ "Soziale Sicherheit / Sicherung der Sozialwerke",
                                sorge == "bildung" ~ "Bildung",
                                sorge == "verkehr" ~ "Verkehr",
                                sorge == "kriminalitaet" ~ "Kriminalität",
                                sorge == "europa" ~ "Beziehung zu Europa, EU, Rahmenabkommen, Zugang zum europäischen Markt",
                                sorge == "auslaender" ~ "Ausländerinnen und Ausländer / Personenfreizügigkeit / Zuwanderung",
                                sorge == "fluechtlinge" ~ "Flüchtlinge / Asylfragen",
                                sorge == "umwelt" ~ "Umweltschutz / Klimawandel / Umweltkatastrophen",
                                sorge == "wohnkosten" ~ "erhöhte Wohnkosten, Anstieg Mietpreise",
                                sorge == "datenschutz" ~ "Datenschutz",
                                sorge == "gesundheitsfragen" ~ "Gesundheitsfragen / Krankenkasse / Prämien",
                                sorge == "ahv" ~ "AHV / Altersvorsorge",
                                sorge == "inflation" ~ "Inflation / Geldentwertung / Teuerung",
                                sorge == "energiefragen" ~ "Energiefragen / Kernenergie",
                                sorge == "versorgungssicherheit" ~ "Versorgungssicherheit (Energie, Medikamente, Nahrungsmittel)",
                                sorge == "medien" ~ "Medien",
                                sorge == "arbeitslosigkeit" ~ "Arbeitslosigkeit / Jugendarbeitslosigkeit",
                                sorge == "neutralitaet" ~ "Verlust der Neutralität",
                                sorge == "armut" ~ "Neue Armut / Armut jüngerer Generationen",
                                sorge == "corona" ~ "Corona-Pandemie und ihre Folgen",
                                sorge == "ukraine" ~ "Der Krieg in der Ukraine")) %>% 
  mutate(prompt = paste0("Verwende 1 bis 2 Sätze und Einfache Sprache, um das Abstimmungsverhalten von ", 
                         FirstName, " ", LastName, 
                         " zum Thema «", sorge_long, 
                         "» zusammen zu fassen. Alle Punkte habe einen Bezug zum Thema:\n",
                         prompt))
