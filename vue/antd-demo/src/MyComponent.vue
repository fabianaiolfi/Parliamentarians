<script setup>

import { ref, computed } from 'vue'

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
      :value="name">
      {{ name }}
    </a-select-option>
  </a-select>
  <div><p> </p></div>

  <div style="background: #F5F5F5; padding: 0px">
    <a-space direction="vertical">
      <div v-for="item in selectedBusinessItems" :key="item.Bsn">
        <a-card :title="item.Title" :bordered="false" style="width: 300px">
          <p>Business Item: {{ item.Bsn }}</p>
        </a-card>
      </div>
    </a-space>
  </div>

  
</template>

