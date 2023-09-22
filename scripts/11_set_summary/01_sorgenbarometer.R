

# Import Data -------------------------------------------------------------

# All businesses with ChatGPT tags
load(here("scripts", "05_chatgpt_tagging", "chatgpt_tagging_output", "all_businesses_eval.RData"))


# Sorgen Barometer -------------------------------------------------------------
# Add each item of business to a "Sorge" from the 2022 Sorgenbarometer

# Define terms for each "Sorge"
umwelt <- c("Umweltschutz", "Klimawandel", "Umweltkatastrophen", "Umwelt") # Umweltschutz / Klimawandel / Umweltkatastrophen
ahv <- c("AHV", "Altersvorsorge") # AHV / Altersvorsorge
energiefragen <- c("Energiefragen", "Kernenergie", "AKW", "Kernkraftwerk", "Energie") # Energiefragen / Kernenergie
europa <- c("EU", "Rahmenabkommen", "Europäisch", "Lissabon", "FADO") # Beziehung zu Europa, EU, Rahmenabkommen, Zugang zum europäischen Markt
inflation <- c("Inflation", "Geldentwertung", "Teuerung") # Inflation / Geldentwertung / Teuerung
gesundheitsfragen <- c("Gesundheitsfragen", "Krankenkasse", "Prämien", "Gesundheit", "Krankenversicherung", "Arzneimitteln", "Arzt", "Medikament", "Generika") # Gesundheitsfragen / Krankenkasse / Prämien
versorgungssicherheit <- c("Versorgungssicherheit", "Versorgung") # Versorgungssicherheit (Energie, Medikamente, Nahrungsmittel)
ukraine <- c("Ukraine") # Der Krieg in der Ukraine
auslaender <- c("Ausländer", "Personenfreizügigkeit", "Zuwanderung", "Einwanderung", "Schengen", "Dublin", "Grenzgänger", "Einbürgerung") # Ausländerinnen und Ausländer / Personenfreizügigkeit / Zuwanderung
fluechtlinge <- c("Flüchtlinge", "Asylfragen", "Asyl", "Einwanderung", "Integration", "Ausschaffung") # Flüchtlinge / Asylfragen
benzinpreis <- c("Benzinpreis", "Erdölpreis", "Diesel") # Benzin- / Erdölpreis
arbeitslosigkeit <- c("Arbeitslosigkeit", "Jugendarbeitslosigkeit", "Arbeitslos", "Arbeitslosenversicherung") # Arbeitslosigkeit / Jugendarbeitslosigkeit
globalisierung <- c("Globalisierung", "Global", "Marktöffnung", "Informationsaustausch", "Bilateral") # weltweite, globale Abhängigkeiten Wirtschaft / Globalisierung
neutralitaet <- c("Neutralität", "Neutral") # Verlust der Neutralität
wohnkosten <- c("Wohnkosten", "Mietpreise", "Miete", "Grundstück") # erhöhte Wohnkosten, Anstieg Mietpreise
corona <- c("Corona", "Pandemie", "covid", "COVID", "covid-19", "COVID-19") # Corona-Pandemie und ihre Folgen
sozial <- c("Sozialwerke", "sozial", "Familienzulagen", "Familie", "Jugendschutz", "Jugend", "Mutter", "Vater", "Arbeitsgesetz", "Arbeitnehmerrechte", "Arbeitnehmerschutz", "Entlasten") # soziale Sicherheit / Sicherung der Sozialwerke
armut <- c("Armut") # neue Armut / Armut jüngerer Generationen
weltordnung <- c("Weltordnung") # neue Weltordnung, Aufstieg Chinas, der Westen unter Druck
zusammenleben <- c("Zusammenleben", "Toleranz", "Partnerschaft", "Polarisierung", "Gleichstellung") # Zusammenleben in der Schweiz / Toleranz

# Weitere Themen
# sicherheit: militär, polizei, stabilität, nato, waffen, munition
# kriminalität: geldwäscherei, 
# verkehr: strassen, flugsicherheit, stau, autobahn, sbb, 
# löhne?


# Function to check if any of the terms from a vector are substrings of chatgpt_tags_clean
is_in_vector <- function(tags_str, vec) {
  any(sapply(vec, function(v) str_detect(tags_str, fixed(v))))
}

# Add TRUE/FALSE column to all businesses for each "Sorge"
all_businesses_sorgen <- all_businesses_eval %>%
  select(BusinessShortNumber, Title, InitialSituation_clean, TagNames, chatgpt_summaries, chatgpt_tags_clean) %>% 
  rowwise() %>%
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
         zusammenleben = if_else(is_in_vector(chatgpt_tags_clean, zusammenleben), T, F))



