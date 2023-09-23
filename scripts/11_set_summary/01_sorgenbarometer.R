

# Import Data -------------------------------------------------------------

# All businesses with ChatGPT tags
load(here("scripts", "05_chatgpt_tagging", "chatgpt_tagging_output", "all_businesses_eval.RData"))


# Sorgen Barometer -------------------------------------------------------------
# Add each item of business to a "Sorge" from the 2022 Sorgenbarometer

# Define terms for each "Sorge"
umwelt <- c("Umweltschutz", "Klimawandel", "Umweltkatastrophen", "Umwelt", "Landwirtschaft", "CO2", "Netto-Null", "Klima", "Klimaschutz") # Umweltschutz / Klimawandel / Umweltkatastrophen
ahv <- c("AHV", "Altersvorsorge") # AHV / Altersvorsorge
energiefragen <- c("Energiefragen", "Kernenergie", "AKW", "Kernkraftwerk", "Energie", "Strom") # Energiefragen / Kernenergie
europa <- c("EU", "Rahmenabkommen", "Europäisch", "Lissabon", "FADO") # Beziehung zu Europa, EU, Rahmenabkommen, Zugang zum europäischen Markt
inflation <- c("Inflation", "Geldentwertung", "Teuerung", "Hochpreisinsel") # Inflation / Geldentwertung / Teuerung
gesundheitsfragen <- c("Gesundheitsfragen", "Krankenkasse", "Prämien", "Gesundheit", "Krankenversicherung", "Arzneimitteln", "Arzt", "Medikament", "Generika") # Gesundheitsfragen / Krankenkasse / Prämien
versorgungssicherheit <- c("Versorgungssicherheit", "Versorgung") # Versorgungssicherheit (Energie, Medikamente, Nahrungsmittel)
ukraine <- c("Ukraine") # Der Krieg in der Ukraine
auslaender <- c("Ausländer", "Personenfreizügigkeit", "Zuwanderung", "Einwanderung", "Schengen", "Dublin", "Grenzgänger", "Einbürgerung", "Migration") # Ausländerinnen und Ausländer / Personenfreizügigkeit / Zuwanderung
fluechtlinge <- c("Flüchtlinge", "Asylfragen", "Asyl", "Einwanderung", "Integration", "Ausschaffung") # Flüchtlinge / Asylfragen
benzinpreis <- c("Benzinpreis", "Erdölpreis", "Diesel") # Benzin- / Erdölpreis
arbeitslosigkeit <- c("Arbeitslosigkeit", "Jugendarbeitslosigkeit", "Arbeitslos", "Arbeitslosenversicherung", "Arbeitsplätze") # Arbeitslosigkeit / Jugendarbeitslosigkeit
globalisierung <- c("Globalisierung", "Global", "Marktöffnung", "Informationsaustausch", "Bilateral", "International") # weltweite, globale Abhängigkeiten Wirtschaft / Globalisierung
neutralitaet <- c("Neutralität", "Neutral") # Verlust der Neutralität
wohnkosten <- c("Wohnkosten", "Mietpreise", "Miete", "Grundstück") # erhöhte Wohnkosten, Anstieg Mietpreise
corona <- c("Corona", "Pandemie", "covid", "COVID", "covid-19", "COVID-19") # Corona-Pandemie und ihre Folgen
sozial <- c("Sozialwerke", "sozial", "Familienzulagen", "Familie", "Jugendschutz", "Jugend", "Mutter", "Vater", "Arbeitsgesetz", "Arbeitnehmerrechte", "Arbeitnehmerschutz", "Entlasten", "Soziale Sicherheit", "Frauen") # soziale Sicherheit / Sicherung der Sozialwerke
armut <- c("Armut", "Mindestlohn", "Löhne") # neue Armut / Armut jüngerer Generationen
weltordnung <- c("Weltordnung") # neue Weltordnung, Aufstieg Chinas, der Westen unter Druck
zusammenleben <- c("Zusammenleben", "Toleranz", "Partnerschaft", "Polarisierung", "Gleichstellung") # Zusammenleben in der Schweiz / Toleranz

# Further Topics
sicherheit <- c("Militär", "Armee", "Polizei", "Stabilität", "NATO", "Munition", "Rüstung", "Terrorismus", "Frieden", "Grenzkontrollen", "Militärstrafprozess", "Kampfflugzeug", "Gripen", "Waffen")
kriminalitaet <- c("Geldwäscherei", "Kriminalität", "Menschenhandel", "Opfer", "Kinderpornografie", "Kinderprostitution", "Kindersextourismus", "Kinderverkauf", "Korruption")
verkehr <- c("Strassen", "Flugsicherheit", "Stau", "Autobahn", "SBB", "Klebevignette", "Luftfahrtgesetz", "Cargo sous terrain", "E-Vignette", "Autobahnvignette", "Eisenbahn", "Seilbahn", "Flug", "Gotthard", "Tunnel", "NEAT", "Güter", "Strasse", "S-Bahn", "Velo", "Auto", "Fahrrad", "Schiff")
datenschutz <- c("Datenschutz")
bildung <- c("Bildung", "Bildungsförderung", "Forschungsförderung", "Forschung", "Innovation", "Innovationsförderung", "CERN", "ETH", "Schule", "Universität", "Innosuisse")
menschenrechte <- c("Völkerrecht", "Kriegsverbrechen", "Zwangsarbeit")
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
