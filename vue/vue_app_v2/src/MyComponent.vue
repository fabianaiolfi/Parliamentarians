<script setup>

import { ref, computed } from 'vue'

// Importing the JSON files
import WorryStatement from './worry_statement.json'
import NamesSearchSelect from './names.json'

// MainTopic Dropdown
const selectedMainTopic = ref();  // Initialize to 'Alle Themen' or any default value

// Assuming WorryStatement is already imported
const uniqueMainTopics = ref([]);

const selectedStatements = ref({})
const options = ref([])  // We'll populate this shortly

const availableTopics = ref([]);

const topicNameMapping = {
  zusammenleben: "Zusammenleben in der Schweiz / Toleranz",
  globalisierung: "weltweite, globale Abhängigkeiten Wirtschaft / Globalisierung",
  sicherheit: "Sicherheit",
  menschenrechte: "Menschenrechte",
  sozial: "Soziale Sicherheit / Sicherung der Sozialwerke",
  bildung: "Bildung",
  verkehr: "Verkehr",
  kriminalitaet: "Kriminalität",
  europa: "Beziehung zu Europa, EU, Rahmenabkommen, Zugang zum europäischen Markt",
  auslaender: "Ausländerinnen und Ausländer / Personenfreizügigkeit / Zuwanderung",
  fluechtlinge: "Flüchtlinge / Asylfragen",
  umwelt: "Umweltschutz / Klimawandel / Umweltkatastrophen",
  wohnkosten: "erhöhte Wohnkosten, Anstieg Mietpreise",
  datenschutz: "Datenschutz",
  gesundheitsfragen: "Gesundheitsfragen / Krankenkasse / Prämien",
  ahv: "AHV / Altersvorsorge",
  inflation: "Inflation / Geldentwertung / Teuerung",
  energiefragen: "Energiefragen / Kernenergie",
  versorgungssicherheit: "Versorgungssicherheit (Energie, Medikamente, Nahrungsmittel)",
  medien: "Medien",
  arbeitslosigkeit: "Arbeitslosigkeit / Jugendarbeitslosigkeit",
  neutralitaet: "Verlust der Neutralität",
  armut: "Neue Armut / Armut jüngerer Generationen",
  corona: "Corona-Pandemie und ihre Folgen",
  ukraine: "Der Krieg in der Ukraine"
};


// Transform the imported JSON into dropdown options
for (const personNumber in NamesSearchSelect) {
    const person = NamesSearchSelect[personNumber][0]
    const fullName = `${person.FirstName} ${person.LastName} (${person.CantonName})`
    options.value.push({
        label: fullName,
        value: personNumber
    })
}

// Main Topic Dropdown
function handleMainTopicChange(newValue) {
  selectedMainTopic.value = newValue;
}

const handleChange = (value) => {
    selectedStatements.value = WorryStatement[value] ? WorryStatement[value][0] : {};

    // Update available topics for the selected name
    availableTopics.value = Object.keys(selectedStatements.value);
}


const handleBlur = () => {
  console.log('blur');
};
const handleFocus = () => {
  console.log('focus');
};
const filterOption = (input, option) => {
    return option.label.toLowerCase().indexOf(input.toLowerCase()) >= 0;
}

// Gather all topics
for (const statements of Object.values(WorryStatement)) {
    for (const topic of Object.keys(statements[0])) {
        if (!uniqueMainTopics.value.includes(topic)) {
            uniqueMainTopics.value.push(topic);
        }
    }
}

</script>

<template>

<div style="background: #F5F5F5; padding: 0px; display: flex; flex-direction: column;">
  <!-- Wrapper for alignment -->
  <div style="width: 100%;">  <!-- Adjust the width to your liking -->
    <h3>Wähle eine:n Parlamentarier:in</h3>
    <!-- Select Parliamentarian Dropdown -->
    <div style="text-align: left; margin-bottom: 20px;">
      <a-select
        v-model:value="selectedPerson"
        show-search
        placeholder="Select a person"
        style="width: 400px"
        :options="options"
        :filter-option="filterOption"
        size="large"
        @focus="handleFocus"
        @blur="handleBlur"
        @change="handleChange"
      ></a-select>
    </div>

    <!-- Main Topic Dropdown -->
    <h4>Wähle ein Themengebiet</h4>
    <a-select
      @change="handleMainTopicChange"
      style="width: 400px">
      <a-select-option v-for="topic in availableTopics" :key="topic" :value="topic">
        {{ topicNameMapping[topic] || topic }}
      </a-select-option>
    </a-select>
    
    <div class="spacer" style="height: 40px;"></div>

    <h3>Zusammenfassung aller Abstimmungen</h3>

    <div v-if="selectedMainTopic !== 'Alle Themen' && selectedStatements[selectedMainTopic]">
      <a-card style="width: 75%;" :bordered="false">
        <h4>{{ selectedStatements[selectedMainTopic] }}</h4>
      </a-card>
    </div>

    <div class="spacer" style="height: 30px;"></div>

    <h3>Einzelne Abstimmungen</h3>
  
  </div>

</div>

</template>
