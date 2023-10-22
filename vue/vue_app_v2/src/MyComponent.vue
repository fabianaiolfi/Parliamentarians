<script setup>

import { ref, watch, computed } from 'vue'
import { CheckCircleTwoTone, CloseCircleTwoTone, QuestionCircleTwoTone, FrownTwoTone } from '@ant-design/icons-vue';  // Import the icon

// Importing the JSON files
import WorryStatement from './worry_statement.json'
import NamesSearchSelect from './names.json'
import SorgenBSN from './sorgen_bsn.json'
import PersonBSNVote from './person_bsn_vote.json'
import BSNStatement from './bsn_summary_statement.json'
import bsnURL from './bsn_url.json'


// Update logic for dropdown selections
// Set up reactive properties to store the selected person, the selected topic, and the resulting values
const selectedPerson = ref("");
const resultingValues = ref([]);

// MainTopic Dropdown
const selectedMainTopic = ref("");  // Initialize to 'Alle Themen' or any default value

// Create a watcher or a method that triggers whenever selectedPerson or selectedMainTopic changes
watch([selectedPerson, selectedMainTopic], ([newPerson, newTopic]) => {
    if (newPerson && newTopic) {
        const topicValues = SorgenBSN[newTopic] || [];
        const personVotes = PersonBSNVote[newPerson] || {};
        
        const groupedVotes = {};
        
        for (const [behavior, votes] of Object.entries(personVotes)) {
            const filteredVotes = votes.filter(vote => 
                topicValues.some(topicValue => topicValue.split(', ').includes(vote))
            );
            if (filteredVotes.length) {
                groupedVotes[behavior] = filteredVotes;
            }
        }

        resultingValues.value = groupedVotes;

        console.log("Grouped votes:", resultingValues.value);
    } else {
        resultingValues.value = {};
    }
});

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
    const fullName = `${person.FirstName} ${person.LastName} (${person.PartyAbbreviation}, ${person.CantonName})`
    options.value.push({
        label: fullName,
        value: personNumber
    })
}

function handleMainTopicChange(topicValue) {
  console.log("Main Topic Changed:", topicValue);
  selectedMainTopic.value = topicValue;
}

function getIconForBehavior(behavior) {
  switch (behavior) {
    case "Stimmte für ":
      return CheckCircleTwoTone;
    case "Stimmte gegen ":
      return CloseCircleTwoTone;
    case "Enthielt sich in Bezug auf ":
      return QuestionCircleTwoTone;
    case "Keine Teilnahme in Bezug auf ":
      return FrownTwoTone;
    default:
      return null;
  }
}
// get the appropriate icon and its color based on the vote_statement
const icons = {
  CheckCircleTwoTone,
  CloseCircleTwoTone,
  QuestionCircleTwoTone,
  FrownTwoTone
};
const iconColors = {
  'Stimmte für ': '#52c41a',
  'Stimmte gegen ': '#eb2f96',
  'Enthielt sich in Bezug auf ': '#b4b4b4',
  'Keine Teilnahme in Bezug auf ': '#b4b4b4'
};

// collapse element stuff
const activeKey = ref(null);
function setActiveKey(key) {
  activeKey.value = activeKey.value === key ? null : key;
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

// Order the collapse elements in this sequence
const order = ["Stimmte für ", "Stimmte gegen ", "Enthielt sich in Bezug auf ", "Keine Teilnahme in Bezug auf "];
function getOrderedValues() {
    let ordered = {};
    const resultingData = resultingValues.value; // Access the underlying data here

    console.log("Actual Resulting Values:", resultingData);

    order.forEach(behavior => {
        if (resultingData[behavior]) {
            ordered[behavior] = resultingData[behavior];
        }
    });
    return ordered;
}

// Adjust the expand icon position
const expandIconPosition = ref('end');

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
        style="width: 450px"
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
      style="width: 450px">
      <a-select-option v-for="topic in availableTopics" :key="topic" :value="topic">
        {{ topicNameMapping[topic] || topic }}
      </a-select-option>
    </a-select>
    
    <div class="spacer" style="height: 40px;"></div>

    <!-- <h3>Zusammenfassung aller Abstimmungen zum Thema {{ topicNameMapping[selectedMainTopic] || selectedMainTopic }}</h3> -->
    <h3>Zusammenfassend</h3>

    <div v-if="selectedMainTopic !== 'Alle Themen' && selectedStatements[selectedMainTopic]">
      <a-card style="width: 100%;" :bordered="false">
        <h1>{{ selectedStatements[selectedMainTopic] }}</h1>
      </a-card>
    </div>

    <div class="spacer" style="height: 30px;"></div>

    <h3>Einzelne Abstimmungen</h3>

    <div v-if="Object.keys(getOrderedValues()).length">
      <div v-for="(votes, behavior) in getOrderedValues()" :key="behavior">
        <div v-for="vote in votes" :key="vote">
          <div v-if="BSNStatement[vote]">
            <a-collapse :style="{ backgroundColor: 'white' }" :active-key="activeKey === vote ? [vote] : []" @change="() => setActiveKey(vote)" :expand-icon-position="expandIconPosition">
              <a-collapse-panel :key="vote" :show-arrow="true">
                <!-- Custom title with dynamic icon -->
                <template #header>
                  <component
                    :is="getIconForBehavior(behavior)"
                    :two-tone-color="iconColors[behavior]"
                  /> {{ behavior + BSNStatement[vote][0].vote_statement }}
                </template>
                <p><b>{{ BSNStatement[vote][0].Title || 'Title not available' }}</b><br>{{ BSNStatement[vote][0].summary || 'Summary not available' }}</p>
                <small v-if="bsnURL[vote]">
                Details: <a :href="bsnURL[vote]" target="_blank">
                  parlament.ch 
                  <i class="material-icons" style="font-size: 0.8rem; vertical-align: -2.6px">open_in_new</i></a>
              </small>
              </a-collapse-panel>
            </a-collapse>
          </div>
          <div class="spacer" style="height: 10px;"></div>
        </div>
      </div>
    </div>

  </div>

</div>

</template>
