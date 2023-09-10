<script setup>

import { ref, computed } from 'vue'

import names_sbn from './namesSBN.json'
const names = ref(Object.keys(names_sbn));
const selectedName = ref(names.value[0])

import business_items from './businessItems.json'

const selectedBusinessItems = computed(() => {
  const sbns = names_sbn[selectedName.value]
  return sbns.map(sbn => business_items[sbn]).flat()
})

</script>

<template>

<div style="background: #F5F5F5; padding: 0px; display: flex; flex-direction: column;">
  <!-- Wrapper for alignment -->
  <div style="width: 100%;">  <!-- Adjust the width to your liking -->
    <!-- Dropdown -->
    <div style="text-align: left; margin-bottom: 20px;">
      <a-select v-model:value="selectedName" style="width: 400px;">
        <a-select-option
          v-for="name in names"
          :key="name"
          :value="name">
          {{ name }}
        </a-select-option>
      </a-select>
    </div>

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

