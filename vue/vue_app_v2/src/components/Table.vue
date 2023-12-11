<template>
  <a-table :columns="columns" :data-source="tableData" :showHeader="true" style="margin-left: 30px; margin-right: 30px;">
    <!-- :pagination="false" remove pagination later on -->

    <template #bodyCell="{ column, record }">
      <div @click="props.openModal" style="cursor: pointer;">
        <template v-if="column.key === 'entscheid'">
          <p><CheckCircleTwoTone /></p>
        </template>
        <template v-else-if="column.key === 'action'">
          <span>
            <a-button type="default" shape="circle"><InfoCircleOutlined /></a-button>
          </span>
        </template>
        <template v-else>
          <!-- Add handling for other columns here if needed -->
          {{ record[column.dataIndex] }}
        </template>
      </div>
    </template>

  </a-table>
</template>

<script lang="ts" setup>

import { CheckCircleOutlined, SmileOutlined, DownOutlined } from '@ant-design/icons-vue';
//import Modal from './Modal.vue';

import { ref } from 'vue';
import { CheckCircleTwoTone, InfoCircleOutlined, CloseCircleTwoTone, QuestionCircleTwoTone, FrownTwoTone } from '@ant-design/icons-vue';
import jsonData from '../bsn_summary_statement.json';

// Define props
const props = defineProps({
  openModal: Function
});

const open = ref(false);

const handleOk = e => {
  console.log(e);
  open.value = false;
};

const setup = () => {
  return { open, handleOk };
};

interface DataItem {
  vote_statement: string;
  //name: string;
  // Define other fields as needed
}

const tableData = ref<DataItem[]>([]);

// Processing the JSON data
tableData.value = Object.values(jsonData).flat().map(item => ({
  vote_statement: item.vote_statement,
  //name: item.Title,  // Adjust according to your needs
  // other fields...
}));

const columns = [
  {
    title: 'Entscheid',
    dataIndex: 'name',
    key: 'entscheid',
    width: '100px',
    filters: [
      {
        text: 'Ja',
        value: 'Ja',
      },
      {
        text: 'Nein',
        value: 'Nein',
      },
      {
        text: 'Enthaltung',
        value: 'Enthaltung',
      },
      {
        text: 'Keine Teilnahme',
        value: 'Keine Teilnahme',
      },
    ],
    onFilter: (value, record) => {
      switch (value) {
        case 'Ja':
          return record.vote_statement.startsWith('der');
        case 'Nein':
          return record.vote_statement.startsWith('die');
        case 'Enthaltung':
          return record.vote_statement.startsWith('das');
        case 'Keine Teilnahme':
          return record.vote_statement.startsWith('ein');
        default:
          return true;
      }
    },
  },
  {
    title: '',
    dataIndex: 'vote_statement',
    key: 'vote_statement',
  },
  {
    title: '',
    key: 'action',
    align: 'right',
  },
];

</script>
