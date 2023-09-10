<script setup>
import { ref, computed } from 'vue'
import { Select } from 'ant-design-vue'
import 'ant-design-vue/dist/reset.css'

const names = ref(['Anna', 'Beda', 'Carl'])
const selectedName = ref('Anna')

const business_items = {
  '01': [{'Bsn': 'Nr. 01', 'Title': 'More taxes' } ],
  '02': [{'Bsn': 'Nr. 02', 'Title': 'Less immigration' } ], 
  '03': [{'Bsn': 'Nr. 03', 'Title': 'Public Transport' } ], 
  '04': [{'Bsn': 'Nr. 04', 'Title': 'Pension Fund' } ] 
}

const names_sbn = {
  Anna: ['01', '02'],
  Beda: ['02', '03', '04'],
  Carl: ['01', '04']
}

const selectedBusinessItems = computed(() => {
  const sbns = names_sbn[selectedName.value]
  return sbns.map(sbn => business_items[sbn]).flat()
})
</script>

<template>
  <a-select v-model:value="selectedName" style="width: 200px;">
    <a-select-option
      v-for="name in names"
      :key="name"
      :value="name"
    >
      {{ name }}
    </a-select-option>
  </a-select>

  <div v-for="item in selectedBusinessItems" :key="item.Bsn">
    <p>Business Item: {{ item.Bsn }}</p>
    <p>Title: {{ item.Title }}</p>
  </div>
</template>
