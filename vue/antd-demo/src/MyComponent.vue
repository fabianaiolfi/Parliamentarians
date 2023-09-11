<script setup>

import { ref, computed } from 'vue'

import names_sbn from './namesSBN.json'
const names = ref(Object.keys(names_sbn))
const selectedName = ref(names.value[0])

import business_items from './businessItems.json'

const selectedBusinessItems = computed(() => {
  const sbns = names_sbn[selectedName.value]
  // console.log("sbns:", sbns);
  // console.log("selectedName.value:", selectedName.value);
  // console.log("names_sbn:", names_sbn);
  // return sbns ? sbns.map(sbn => business_items[sbn]).flat() : [];
  return sbns.map(sbn => business_items[sbn]).flat()
})

// New Dropdown
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
    
    <!-- Old Dropdown -->
    <!-- <div style="text-align: left; margin-bottom: 20px;">
      <a-select v-model:value="selectedName" style="width: 400px;">
        <a-select-option
          v-for="name in names"
          :key="name"
          :value="name">
          {{ name }}
        </a-select-option>
      </a-select>
    </div> -->

    <!-- Cards -->
    <a-space direction="vertical" style="width: 100%;">
      <div v-for="item in selectedBusinessItems" :key="item.BusinessShortNumber">
        <a-card :title="item.Statement" :bordered="false" style="width: 100%">
          <p><b>{{ item.Title }}</b><br>{{ item.Summary }}</p>
          <small>{{ item.BusinessShortNumber_card }}</small>
        </a-card>
      </div>
    </a-space>
  </div>
</div>

</template>