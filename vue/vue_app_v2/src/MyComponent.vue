<script setup>
import { ref, watch, computed, inject, onMounted } from 'vue'
import { useRoute } from 'vue-router';
import Table from './components/Table.vue'; // Adjust the import path as necessary
import { selectedPersonId } from './store.js'; // Update the path accordingly
import WorryStatement from './worry_statement.json'
import NamesSearchSelect from './names.json'
import SorgenBSN from './sorgen_bsn.json'
import PersonBSNVote from './person_bsn_vote.json'
import BSNStatement from './bsn_summary_statement.json'
import SimpleComponent from './SimpleComponent.vue';

const value1 = ref(null); // Or the default value
const selectedTopic = ref(null); // New v-model for select component
const route = useRoute();
const selectedPerson = ref(null);
const cardStatement = ref(''); // Holds the statement for the a-card
const selectedMainTopic = ref("");
const uniqueMainTopics = ref([]);
const selectedStatements = ref({})
const options = ref([])
const availableTopics = ref([]);
const excludedTopics = ['ahv', 'umwelt', 'energiefragen'];

const updateSelectedPerson = () => {
      const personId = route.query.personId;
      if (personId && NamesSearchSelect[personId]) {
        const personData = NamesSearchSelect[personId][0];
        const fullName = `${personData.FirstName} ${personData.LastName} (${personData.PartyAbbreviation}, ${personData.CantonName})`;
        selectedPerson.value = { label: fullName, value: personId };
      } else {
        selectedPerson.value = null;
      }
      return {
        selectedPerson
      }
    };
    onMounted(updateSelectedPerson);
    watch(route, updateSelectedPerson);

const handleRouteChange = () => {
  console.log("Route changed, personId:", route.query.personId);
  const personId = route.query.personId;
  if (personId && NamesSearchSelect[personId]) {
    selectedPersonId.value = personId;
    updateSelectedPerson(); // Update selected person details
    fetchAndSetRelatedData(personId); // Fetch and set related data like topics
  } else {
    resetComponentState();
  }
};

const fetchAndSetRelatedData = (personId) => {
  console.log("Available topics:", availableTopics.value);
  console.log("Selected statements:", selectedStatements.value);
  if (WorryStatement[personId]) {
    const personData = WorryStatement[personId][0]; // Assuming each personId has only one entry in WorryStatement
    availableTopics.value = Object.keys(personData);
    selectedMainTopic.value = null;
    selectedTopic.value = null;
    cardStatement.value = ''; // Reset the card statement
  } else {
    availableTopics.value = [];
    selectedMainTopic.value = null;
    selectedTopic.value = null;
    cardStatement.value = ''; // Reset the card statement
  }
};

onMounted(() => {
  availableTopics.value = ['test1', 'test2']; // Test data
  console.log("Mounted - available topics:", availableTopics.value);
});

watch(availableTopics, (newVal, oldVal) => {
  console.log("availableTopics changed:", newVal);
}, { deep: true });

const topicOptions = computed(() => availableTopics.value.map(topic => ({ label: topic, value: topic })));



const filteredTopics = computed(() => {
  return availableTopics.value.filter(topic => !excludedTopics.includes(topic));
});

const resetComponentState = () => {
  selectedPerson.value = null;
  selectedTopic.value = null;
  value1.value = null;
  resultingValues.value = [];
};

onMounted(handleRouteChange);

watch(() => route.query.personId, handleRouteChange, { immediate: true });

const updateComponentState = () => {
  const personId = route.query.personId;
  if (personId && NamesSearchSelect[personId]) {
    selectedPersonId.value = personId;
  } else {
  }
};

onMounted(updateComponentState);

watch(selectedTopic, (newVal) => {
  if (newVal) {
    value1.value = null; // Reset radio buttons when a topic is selected
  }
});

watch(value1, (newVal) => {
  if (newVal) {
    handleMainTopicChange(newVal); // Call the same function as the select component
    selectedTopic.value = null; // Reset the select component to show the placeholder
    console.log("Selected Topic from Radio:", newVal);
  }
});

watch(selectedTopic, (newVal) => {
  if (newVal) {
    value1.value = null; // Unselect radio buttons if the topic is selected from the dropdown
  }
});

const handleMainTopicChange = (topicValue) => {
  console.log("Main Topic Changed:", topicValue);
  selectedMainTopic.value = topicValue;
  selectedTopic.value = topicValue;

  if (WorryStatement[selectedPersonId.value] && WorryStatement[selectedPersonId.value][0][topicValue]) {
    cardStatement.value = WorryStatement[selectedPersonId.value][0][topicValue];
  } else {
    cardStatement.value = 'No statement available for this topic.';
  }
};

watch(selectedMainTopic, (newTopic) => {
  if (newTopic) {
    const statement = selectedStatements.value[newTopic];
    if (statement) {
      cardStatement.value = statement;
    } else {
      cardStatement.value = '';
    }
  } else {
    cardStatement.value = '';
  }
});

const topicValue = ref('');
const resultingValues = ref([]);
const showModal = inject('showModal');

const handleAction = () => {
  showModal();
};

const selectedPersonName = computed(() => {
  if (selectedPersonId.value && NamesSearchSelect[selectedPersonId.value]) {
    const person = NamesSearchSelect[selectedPersonId.value][0];
    return `${person.FirstName} ${person.LastName}`;
  }
  return '';
});


const selectedPersonPartyCanton = computed(() => {
  if (selectedPersonId.value && NamesSearchSelect[selectedPersonId.value]) {
    const person = NamesSearchSelect[selectedPersonId.value][0];
    return `${person.PartyAbbreviation}, ${person.CantonName}`;
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

watch([selectedPerson, selectedMainTopic], ([newPerson, newTopic]) => {
  console.log("Updated resultingValues in MyComponent:", resultingValues.value);
    const groupedVotes = {}; // Declare groupedVotes at the top of the watch callback

    if (newPerson && newTopic) {
        const topicValues = SorgenBSN[newTopic] || [];
        const personVotes = PersonBSNVote[newPerson] || {};
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
                const voteStatement = voteData[0].vote_statement;
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

watch(selectedPerson, (newValue) => {
  if (newValue) {
    selectedStatements.value = WorryStatement[newValue] ? WorryStatement[newValue][0] : {};
    availableTopics.value = Object.keys(selectedStatements.value);
  } else {
    selectedStatements.value = {};
    availableTopics.value = [];
  }
});

watch(selectedPersonId, (newPersonId) => {
  if (newPersonId && NamesSearchSelect[newPersonId]) {
    const personData = NamesSearchSelect[newPersonId][0];
    selectedPerson.value = newPersonId;
    
    // Now, update the topics based on the selected person
    const personTopics = WorryStatement[newPersonId];
    if (personTopics) {
      availableTopics.value = Object.keys(personTopics[0]);
    } else {
      availableTopics.value = [];
    }
  } else {
    selectedPerson.value = null;
    availableTopics.value = [];
  }
}, { immediate: true });

for (const personNumber in NamesSearchSelect) {
    const person = NamesSearchSelect[personNumber][0]
    const fullName = `${person.FirstName} ${person.LastName} (${person.PartyAbbreviation}, ${person.CantonName})`
    options.value.push({
        label: fullName,
        value: personNumber
    })
}

const handleChange = (value) => {
    selectedStatements.value = WorryStatement[value] ? WorryStatement[value][0] : {};
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

for (const statements of Object.values(WorryStatement)) {
    for (const topic of Object.keys(statements[0])) {
        if (!uniqueMainTopics.value.includes(topic)) {
            uniqueMainTopics.value.push(topic);
        }
    }
}

const order = ["Stimmte für ", "Stimmte gegen ", "Enthielt sich in Bezug auf ", "Keine Teilnahme in Bezug auf "];
function getOrderedValues() {
    let ordered = {};
    const resultingData = resultingValues.value;

    console.log("Actual Resulting Values:", resultingData);

    order.forEach(behavior => {
        if (resultingData[behavior]) {
            ordered[behavior] = resultingData[behavior];
        }
    });
    return ordered;
}

</script>

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

<div style="background: #F5F5F5; padding: 0px; display: flex; flex-direction: column;" v-if="selectedPerson">
  <div style="width: 100%;"> 
    <div class="spacer" style="height: 30px;"></div>
    <h3>Wähle ein Themengebiet aus</h3>

    <div id="app">
      <SimpleComponent :resultingValues="resultingValues" />
    </div>

    
    <!-- <div>
    <a-select v-model:value="selectedTopic" style="width: 450px">
      <a-select-option v-for="topic in availableTopics" :key="topic" :value="topic">
        {{ topic }}
      </a-select-option>
    </a-select>
  </div> -->


<!-- <div class="spacer" style="height: 30px;"></div> -->

    <!-- <div class="container">
      <a-radio-group v-model:value="value1" button-style="solid" class="topic-radio-group">
        <a-radio-button value="umwelt">Umwelt</a-radio-button>
        <a-radio-button value="ahv">AHV</a-radio-button>
        <a-radio-button value="energiefragen">Energie</a-radio-button>
      </a-radio-group>
      <a-select
      v-model:value="selectedTopic"
      @change="handleMainTopicChange"
      placeholder="Weitere Themen"
      :class="{ 'active-select': selectedTopic, 'custom-select': true }"
      style="width: 450px">
      <a-select-option v-for="topic in filteredTopics" :key="topic" :value="topic">
        {{ topicNameMapping[topic] || topic }}
        {{ topic }}
      </a-select-option>
    </a-select>
    </div> -->
    
    <!-- <div class="spacer" style="height: 10px;"></div> -->
    
    <!-- <div>
      <a-card v-if="cardStatement.value" style="width: 100%;" :bordered="false">
        <h1>{{ cardStatement.value }}</h1>
      </a-card>
    </div> -->
    <!-- <div class="spacer" style="height: 30px;"></div> -->
  </div>
</div>
<!-- <Table :resultingValues="resultingValues" :open-modal="showModal" v-if="value1 || selectedTopic" /> -->
</template>
