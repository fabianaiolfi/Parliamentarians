<script setup>

import { ref, computed } from 'vue'

// Importing the JSON files
import WorryStatement from './worry_statement.json'
import NamesSearchSelect from './names.json'

// MainTopic Dropdown
const selectedMainTopic = ref('Alle Themen');  // Initialize to 'Alle Themen' or any default value

// Assuming WorryStatement is already imported
const uniqueMainTopics = ref([]);

const selectedStatements = ref({})
const options = ref([])  // We'll populate this shortly

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
      style="width: 300px"
      placeholder="Alle Themen">
      <a-select-option value="Alle Themen">Alle Themen</a-select-option>
      <a-select-option v-for="topic in uniqueMainTopics" :key="topic" :value="topic">
        {{ topic }}
      </a-select-option>
    </a-select>
    
    <div class="spacer" style="height: 30px;"></div>

    <div v-if="selectedMainTopic !== 'Alle Themen' && selectedStatements[selectedMainTopic]">
      <a-card style="width: 100%;" :bordered="false">
        <h3>{{ selectedStatements[selectedMainTopic] }}</h3>
      </a-card>
    </div>

    <div v-else>
      <div v-for="(text, key) in selectedStatements" :key="key">
        <strong>{{ key }}</strong>
        <p>{{ text }}</p>
      </div>
    </div>
  
  </div>

</div>

</template>
