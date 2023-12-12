<template>
  <a-table :columns="columns" :data-source="props.resultingValues" :pagination="false">
    <template #bodyCell="{ record, column }">
      <div @click="props.openModal" style="cursor: pointer;">

        <!-- Existing conditions for 'entscheid' and 'action' columns -->
        <template v-if="column.key === 'entscheid'">
          <p><CheckCircleTwoTone /></p>
        </template>
        <template v-else-if="column.key === 'action'">
          <span>
            <a-button type="default" shape="circle"><InfoCircleOutlined /></a-button>
          </span>
        </template>

        <!-- New condition for 'status' column -->
        <template v-else-if="column.key === 'status'">
          <span v-if="record.behavior.startsWith('Stimmte für')">
            <CheckCircleTwoTone two-tone-color="#52c41a"/>
          </span>
          <span v-else-if="record.behavior.startsWith('Stimmte gegen')">
            <CloseCircleTwoTone two-tone-color="#eb2f96"/>
          </span>
          <span v-else-if="record.behavior.startsWith('Enthielt sich')">
            <QuestionCircleTwoTone two-tone-color="#b4b4b4"/>
          </span>
          <span v-else-if="record.behavior.startsWith('Keine Teilnahme')">
            <FrownTwoTone two-tone-color="#b4b4b4"/>
          </span>
        </template>

        <!-- Default case for other columns -->
        <template v-else>
          {{ record[column.dataIndex] }}
        </template>

      </div>
    </template>
  </a-table>
</template>

<script lang="ts" setup>

//import { CheckCircleOutlined, SmileOutlined, DownOutlined } from '@ant-design/icons-vue';
//import Modal from './Modal.vue';
import { defineProps } from 'vue';


import { ref, h } from 'vue';
import { CheckCircleTwoTone, InfoCircleOutlined, CloseCircleTwoTone, QuestionCircleTwoTone, FrownTwoTone } from '@ant-design/icons-vue';
import jsonData from '../bsn_summary_statement.json';

// Define props
const props = defineProps({
  openModal: Function,
  resultingValues: Array
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

tableData.value = Object.entries(jsonData).flatMap(([businessNumber, votes]) => {
  return votes.map(vote => ({
    businessNumber: businessNumber,
    vote_statement: vote.vote_statement,
  }));
});

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
          return record.concatenatedValue.startsWith('Stimmte für');
        case 'Nein':
          return record.concatenatedValue.startsWith('Stimmte gegen');
        case 'Enthaltung':
          return record.concatenatedValue.startsWith('Enthielt sich');
        case 'Keine Teilnahme':
          return record.concatenatedValue.startsWith('Keine Teilnahme');
        default:
          return true;
      }
    },
  },
  {
    title: 'Status',
    key: 'status',
  },
  {
    title: 'Concatenated Value',
    dataIndex: 'concatenatedValue',
    key: 'concatenatedValue',
  },

  {
    title: '',
    key: 'action',
    align: 'right',
  },
];

</script>
