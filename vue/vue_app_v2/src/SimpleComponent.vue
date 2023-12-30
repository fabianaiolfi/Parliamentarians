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

  </div>

  </template>
  
  <script setup>
import { ref, onMounted, computed, watch } from 'vue';
import { useRoute } from 'vue-router';
import WorryStatement from './worry_statement.json';

const route = useRoute();
const dynamicPersonId = computed(() => route.query.personId);
const availableTopics = ref(['Loading topics...']);
const selectedTopic = ref(null);
const selectedStatement = ref('');

const fetchAndSetAvailableTopics = (personId) => {
  if (WorryStatement[personId]) {
    const personData = WorryStatement[personId][0];
    availableTopics.value = Object.keys(personData);
  } else {
    console.log("No data found for personId:", personId);
    availableTopics.value = []; // Reset topics if no data is found
  }
};

// Watch for changes in dynamicPersonId
watch(dynamicPersonId, (newPersonId) => {
  console.log("Person ID changed to:", newPersonId);
  fetchAndSetAvailableTopics(newPersonId);
  selectedTopic.value = null; // Reset the selected topic
});

watch(selectedTopic, (newTopic) => {
  if (newTopic && WorryStatement[dynamicPersonId.value] && WorryStatement[dynamicPersonId.value][0][newTopic]) {
    selectedStatement.value = WorryStatement[dynamicPersonId.value][0][newTopic];
  } else {
    selectedStatement.value = null;
  }
});

onMounted(() => {
  fetchAndSetAvailableTopics(dynamicPersonId.value);
});
</script>

  
  <style>
  /* Add styles if needed */
  </style>
  