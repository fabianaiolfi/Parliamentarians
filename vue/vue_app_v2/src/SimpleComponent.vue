<template>

    <div>
    <a-select
    v-model:value="selectedTopic"
    style="width: 450px"
    placeholder="Wähle ein Themengebiet aus"
    >
      <a-select-option v-for="topic in availableTopics" :key="topic" :value="topic">
        {{ topic }}
      </a-select-option>
    </a-select>

    <div>
      <a-card v-if="selectedStatement">
        <h1>{{ selectedStatement }}</h1>
      </a-card>
    </div>

    <pre>{{ props.resultingValues }}</pre>

  </div>

  <Table :resultingValues="resultingValues" :open-modal="showModal" v-if="selectedTopic" />

  </template>
  
  <script setup>
import { ref, onMounted, computed, watch, defineProps } from 'vue';
import { useRoute } from 'vue-router';
import WorryStatement from './worry_statement.json';
import Table from './components/Table.vue'; // Adjust the import path as necessary
import SorgenBSN from './sorgen_bsn.json'
import PersonBSNVote from './person_bsn_vote.json'
import BSNStatement from './bsn_summary_statement.json'

const route = useRoute();
const dynamicPersonId = computed(() => route.query.personId);
const availableTopics = ref(['Loading topics...']);
const selectedTopic = ref(null);
// const selectedStatement = ref('');
// const resultingValues = ref([]);

const props = defineProps({
  resultingValues: Array
});

console.log("Received resultingValues in SimpleComponent:", props.resultingValues);

const fetchAndSetAvailableTopics = (personId) => {
  if (WorryStatement[personId]) {
    const personData = WorryStatement[personId][0];
    availableTopics.value = Object.keys(personData);
  } else {
    console.log("No data found for personId:", personId);
    availableTopics.value = []; // Reset topics if no data is found
  }
};

const selectedStatement = computed(() => {
  if (selectedTopic.value && WorryStatement[dynamicPersonId.value] && WorryStatement[dynamicPersonId.value][0][selectedTopic.value]) {
    return WorryStatement[dynamicPersonId.value][0][selectedTopic.value];
  }
  return null; // Return null if no statement is found
});

// const resultingValues = computed(() => {
//   if (selectedTopic.value && dynamicPersonId.value) {
//     // Process data for the table based on the selected person and topic
//     // Similar to the logic you had in your watcher
//     // Return the processed data
//   }
//   return []; // Return an empty array if no data
// });

// This static test works
// const resultingValues = ref([
//   { behavior: 'Stimmte für', vote_statement: 'Example Statement 1' },
//   { behavior: 'Stimmte gegen', vote_statement: 'Example Statement 2' },
//   // Add more test items as needed
// ]);

const resultingValues = ref([]);

watch(dynamicPersonId, (newPersonId) => {
  if (newPersonId && PersonBSNVote[newPersonId]) {
    const personVotes = PersonBSNVote[newPersonId];
    const tableData = [];

    for (const [behavior, businessNumbers] of Object.entries(personVotes)) {
      businessNumbers.forEach(businessNumber => {
        const bsnData = BSNStatement[businessNumber];
        if (bsnData && bsnData.length > 0) {
          const { Title, summary, vote_statement } = bsnData[0];
          tableData.push({
            behavior,
            title: Title,
            summary,
            vote_statement,
            // Add other fields as necessary
          });
        }
      });
    }

    resultingValues.value = tableData;
  } else {
    resultingValues.value = [];
  }
});




// Watch for changes in dynamicPersonId
watch(dynamicPersonId, (newPersonId) => {
  console.log("Person ID changed to:", newPersonId);
  fetchAndSetAvailableTopics(newPersonId);
  selectedTopic.value = null; // Reset the selected topic
});

watch([dynamicPersonId, selectedTopic], ([newPersonId, newTopic]) => {
  if (newPersonId && newTopic && PersonBSNVote[newPersonId] && PersonBSNVote[newPersonId][newTopic]) {
    const businessNumbers = PersonBSNVote[newPersonId][newTopic];
    const tableData = businessNumbers.flatMap(businessNumber => {
      const bsnData = BSNStatement[businessNumber];
      return bsnData && bsnData.length > 0
        ? bsnData.map(data => ({
            behavior: newTopic,
            title: data.Title,
            summary: data.summary,
            vote_statement: data.vote_statement,
            // ... other fields as necessary
          }))
        : [];
    });

    resultingValues.value = tableData;
  } else {
    resultingValues.value = [];
  }
});


onMounted(() => {
  fetchAndSetAvailableTopics(dynamicPersonId.value);
});
</script>

  
  <style>
  /* Add styles if needed */
  </style>
  