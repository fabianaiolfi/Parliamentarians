<script setup>

import { ref, watch, computed, inject } from 'vue'
import { CheckCircleTwoTone, CloseCircleTwoTone, QuestionCircleTwoTone, FrownTwoTone } from '@ant-design/icons-vue';  // Import the icon
import Table from './components/Table.vue'; // Adjust the import path as necessary

// Importing the JSON files
import WorryStatement from './worry_statement.json'
import NamesSearchSelect from './names.json'
import SorgenBSN from './sorgen_bsn.json'
import PersonBSNVote from './person_bsn_vote.json'
import BSNStatement from './bsn_summary_statement.json'
import BSNsentsData from './bsn_sents.json'
import TopicAssWords from './topics_associated_words.json'
import bsnURL from './bsn_url.json'

const topicValue = ref('');

// Update logic for dropdown selections
// Set up reactive properties to store the selected person, the selected topic, and the resulting values
// const selectedPerson = ref("");
const resultingValues = ref([]);
const showModal = inject('showModal');
const selectedPerson = inject('selectedPerson');
const selectedPersonId = inject('selectedPerson');

const selectedPersonName = computed(() => {
  if (selectedPersonId.value && NamesSearchSelect[selectedPersonId.value]) {
    const person = NamesSearchSelect[selectedPersonId.value][0];
    return `${person.FirstName} ${person.LastName}`;
  }
  return 'No person selected';
});

const selectedPersonPartyCanton = computed(() => {
  if (selectedPersonId.value && NamesSearchSelect[selectedPersonId.value]) {
    const person = NamesSearchSelect[selectedPersonId.value][0];
    return `${person.CantonName}, ${person.PartyAbbreviation}`;
  }
  return '';
});

const selectedPersonImgURL = computed(() => {
  if (selectedPersonId.value) {
    // Replace the URL below with the correct pattern using selectedPersonId.value
    const person = NamesSearchSelect[selectedPersonId.value][0];
    return `${person.img_url}`;
  }
  return ''; // Default image or empty string
});

// MainTopic Dropdown
const selectedMainTopic = ref("");  // Initialize to 'Alle Themen' or any default value

// Create a watcher or a method that triggers whenever selectedPerson or selectedMainTopic changes
watch([selectedPerson, selectedMainTopic], ([newPerson, newTopic]) => {
    const groupedVotes = {}; // Declare groupedVotes at the top of the watch callback

    if (newPerson && newTopic) {
        const topicValues = SorgenBSN[newTopic] || [];
        const personVotes = PersonBSNVote[newPerson] || {};
        
        // Now groupedVotes is accessible within this block
        for (const [behavior, votes] of Object.entries(personVotes)) {
            const filteredVotes = votes.filter(vote => 
                topicValues.some(topicValue => topicValue.split(', ').includes(vote))
            );
            if (filteredVotes.length) {
                groupedVotes[behavior] = filteredVotes;
            }
        }

    } else {
        resultingValues.value = {};
    }


const tableData = [];
    for (const [behavior, votes] of Object.entries(groupedVotes)) {
        votes.forEach(businessNumber => {
            const voteData = BSNStatement[businessNumber];
            if (voteData && voteData.length > 0) {
                // Assuming each businessNumber has an array of items, and you're interested in the first one
                const voteStatement = voteData[0].vote_statement;
                //tableData.push({ behavior, businessNumber, vote_statement: voteStatement });
                tableData.push({
                behavior,
                businessNumber,
                vote_statement: voteStatement,
                concatenatedValue: behavior + ' ' + voteStatement // Concatenate here
            });
            }
        });
    }
    resultingValues.value = tableData;
});

// Watcher to react to changes in selectedPerson
watch(selectedPerson, (newVal, oldVal) => {
  if (newVal) {
    const statements = WorryStatement[newVal] ? WorryStatement[newVal][0] : {};
    availableTopics.value = Object.keys(statements);
  } else {
    availableTopics.value = [];
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
  bildung: "Bildung und Forschung",
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


//////////// ASSOCIATED WORDS ///////////////

// This computed property will automatically update when topicValue changes
const associatedWords = computed(() => {
  // Check if the topicValue exists as a key in TopicAssWords
  if (selectedMainTopic.value && TopicAssWords.hasOwnProperty(selectedMainTopic.value)) {
    // Return the array of words associated with the selected topic
    return TopicAssWords[selectedMainTopic.value];
  }
  // If the selected topic is not in the JSON, return an empty array or a default set of words
  return [];
})

watch(associatedWords, (newValue, oldValue) => {
      console.log("Associated Words changed from:", oldValue, "to:", newValue);
    });

// Make BSNsentsData reactive
const BSNsents = ref(BSNsentsData)

// Assuming 'associatedWords' and 'BSNsents' are reactive and available in the scope
const findSentencesForVote = (vote) => {
  let voteSentences = [];
  // Get the sentences for the specific 'vote' if they exist
  const voteRelatedSentences = BSNsents.value[vote];

  if (voteRelatedSentences && associatedWords.value.length > 0) {
    // Filter the sentences for this vote based on associated words
    voteSentences = voteRelatedSentences.filter(sentence =>
      associatedWords.value.some(word => sentence.toLowerCase().includes(word.toLowerCase()))
    );
  }
  return voteSentences;
};

// HIGHLIGHT ASSOCIATED WORDS //

const sentences = ref([]);
const sentencesForVotes = ref({});

const updateSentencesForVote = (vote) => {
      // Initialize an empty array for this vote if it doesn't exist yet
      if (!sentencesForVotes.value[vote]) {
        sentencesForVotes.value[vote] = [];
      }

  // Assuming BSNsents.value[vote] is an array of sentences for this vote
  const sents = BSNsents.value[vote];
  if (Array.isArray(sents)) {
    sents.forEach(sentence => {
      if (associatedWords.value.some(word => sentence.includes(word))) {
        sentencesForVotes.value[vote].push(sentence);
      }
    });
  }
};

// Iterate over each vote to populate sentences
const populateSentencesForAllVotes = () => {
  for (const vote in BSNsents.value) {
    updateSentencesForVote(vote);
  }
};

// Initial population
populateSentencesForAllVotes();

// Watch for changes in associatedWords to update the sentences for each vote
watch(associatedWords, () => {
  // Clear the current sentences
  sentencesForVotes.value = {};
  // Repopulate the sentences
  populateSentencesForAllVotes();
});

function highlightAssociatedWords(sentence, associatedWords) {
  let highlightedSentence = sentence;
  
  // Sort associatedWords by length in descending order to avoid overriding matches within longer words
  const sortedAssociatedWords = [...associatedWords].sort((a, b) => b.length - a.length);

  sortedAssociatedWords.forEach((word) => {
    const regex = new RegExp(`${word}`, 'gi'); // Remove the word boundary to match partial words
    highlightedSentence = highlightedSentence.replace(regex, `<span class="highlight">$&</span>`);
  });

  return highlightedSentence;
}

////////////////////////////////////


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

// Define your method as a standalone function
const highlightWords = (vote, contextKey, associatedWordKey) => {
  if (!BSNStatement[vote] || BSNStatement[vote].length === 0) {
        console.warn("Data not available for vote: ", vote);
        return '';
      }

      let context = BSNStatement[vote][0][contextKey];
      let word = BSNStatement[vote][0][associatedWordKey];
      if (!context || !word) return context || '';

      let highlighted = context.replace(new RegExp(`\\b${word}\\b`, 'gi'), match => `<span class="highlight">${match}</span>`);
      return highlighted;
    }



</script>

<style>

.highlight {
  background-color: yellow;
}
.em-dash {
  color: #b9b9b9;
  transform: translateY(25%);
}

.person-container {
  display: flex;
  align-items: flex-start; /* Aligns items at the top */
}

.person-image {
  margin-right: 20px; /* Adds some space between the image and the text */
}

</style>

<template>

  <div>
    <div class="person-container">
    <img :src="selectedPersonImgURL" width="120" class="person-image">
    <div>
      <h1>{{ selectedPersonName }}</h1>
      <h3>{{ selectedPersonPartyCanton }}</h3>
    </div>
  </div>
  </div>

<div style="background: #F5F5F5; padding: 0px; display: flex; flex-direction: column;">
  <!-- Wrapper for alignment -->
  <div style="width: 100%;">  <!-- Adjust the width to your liking -->
    <!-- <h3>Wähle eine:n Parlamentarier:in</h3> -->
    <!-- Select Parliamentarian Dropdown -->
    <!-- <div style="text-align: left; margin-bottom: 20px;"> -->
    <!--  <a-select
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
    </div> -->

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

    <!-- <h3>Einzelne Abstimmungen</h3> -->

    <div v-if="Object.keys(getOrderedValues()).length">
      <div v-for="(votes, behavior) in getOrderedValues()" :key="behavior">
        <div v-for="vote in votes" :key="vote">
          {{ console.log("Current vote: ", vote) }}
          <!-- <div v-if="BSNStatement[vote]"> -->
          <div v-if="BSNStatement && BSNStatement[vote] && BSNStatement[vote].length">
            <a-collapse :style="{ backgroundColor: 'white' }" :active-key="activeKey === vote ? [vote] : []" @change="() => setActiveKey(vote)" :expand-icon-position="expandIconPosition">
              <a-collapse-panel :key="vote" :show-arrow="true">
                <!-- Custom title with dynamic icon -->
                <template #header>
                  <component
                    :is="getIconForBehavior(behavior)"
                    :two-tone-color="iconColors[behavior]"
                  /> {{ behavior + BSNStatement[vote][0].vote_statement }}
                </template>
                <small><strong>TITEL DES GESCHÄFTS</strong></small>
                <h3>{{ BSNStatement[vote][0].Title || 'Title not available' }}</h3>
                <a-divider />
                <small><strong>KURZ GEFASST</strong></small>
                <p>{{ BSNStatement[vote][0].summary || 'Summary not available' }}</p>
                <a-divider />
                <small><strong>AUS DER OFFIZIELLEN ZUSAMMENFASSUNG</strong></small>
                  <div v-for="(sentence, index) in sentencesForVotes[vote]" :key="index">
                    <div v-html="highlightAssociatedWords(sentence, associatedWords)"></div>
                    <p class="em-dash">&#8212;</p>
                  </div>
                <small v-if="bsnURL[vote]">
                Weitere Informationen: <a :href="bsnURL[vote]" target="_blank">
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

<Table :resultingValues="resultingValues" :open-modal="showModal" />


</template>
