<script setup>

import { ref, computed } from 'vue'

// Importing the JSON files
import names_sbn from './namesSBN.json'
const names = ref(Object.keys(names_sbn))
const selectedName = ref(names.value[0])
import business_items from './businessItems.json'
import voteStatement from './vote_statement.json'

// Computed property for selectedBusinessItems based on namesSBN.json
const selectedBusinessItems = computed(() => {
  const sbns = names_sbn[selectedName.value]
  return sbns.map(sbn => business_items[sbn]).flat()
})

// Computed property for selectedBusinessItems based on vote_statement.json
const selectedVoteStatement = computed(() => {
  return voteStatement[selectedName.value] || []
})

// Select Search Dropdown
import NamesSearchSelect from './names_search_select.json'
const options = ref(NamesSearchSelect)
const value = selectedName; // Select first name on load

function handleChange(newValue) {
  selectedName.value = newValue;  // Update selectedName whenever the dropdown changes
}
const handleBlur = () => {
  console.log('blur');
};
const handleFocus = () => {
  console.log('focus');
};
const filterOption = (input, option) => {
  return option.value.toLowerCase().indexOf(input.toLowerCase()) >= 0;
};
</script>

<template>

<div style="background: #F5F5F5; padding: 0px; display: flex; flex-direction: column;">
  <!-- Wrapper for alignment -->
  <div style="width: 100%;">  <!-- Adjust the width to your liking -->
    <!-- New Dropdown -->
    <div style="text-align: left; margin-bottom: 20px;">
      <a-select
        v-model:value="value"
        show-search
        placeholder="Select a person"
        style="width: 400px"
        :options="options"
        :filter-option="filterOption"
        @focus="handleFocus"
        @blur="handleBlur"
        @change="handleChange"
      ></a-select>
    </div>

    <!-- Cards -->
    <a-space direction="vertical" style="width: 100%;">
      <div v-for="item in selectedVoteStatement" :key="item.BusinessShortNumber">
        <a-card :title="item.vote_statement" :bordered="false" style="width: 100%">
          <p><b>{{ item.Title || 'Title not available' }}</b><br>{{ item.chatgpt_summary || 'Summary not available' }}</p>
          <small>BSN: {{ item.BusinessShortNumber }}</small>
        </a-card>
      </div>
    </a-space>
  </div>
</div>

</template>