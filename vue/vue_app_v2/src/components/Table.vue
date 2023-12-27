<template>
  
  <div>
    <a-radio-group v-model:value="tablefilter">
      <a-radio-button value="all">Alle Abstimmungen</a-radio-button>
      <a-radio-button value="yes"><CheckCircleTwoTone two-tone-color="#52c41a"/> Ja</a-radio-button>
      <a-radio-button value="no"><CloseCircleTwoTone two-tone-color="#eb2f96"/> Nein</a-radio-button>
      <a-radio-button value="abstain"><QuestionCircleTwoTone two-tone-color="#b4b4b4"/> Enthaltung</a-radio-button>
      <a-radio-button value="no_participation"><FrownTwoTone two-tone-color="#b4b4b4"/> Keine Teilnahme</a-radio-button>
    </a-radio-group>
  </div>

  <div class="spacer" style="height: 10px;"></div>

  <a-table 
    :columns="columns"
    :data-source="filteredTableData"
    :pagination="false"
    :show-header="false"
    size="middle"
    v-if="filteredTableData.length > 0"
    >
  
    <template #bodyCell="{ record, column }">
      <div @click="props.openModal" style="cursor: pointer;">

        <!-- Existing conditions for 'entscheid' and 'action' columns -->
        <template v-if="column.key === 'entscheid'">
          <p><CheckCircleTwoTone /></p>
        </template>
        <template v-else-if="column.key === 'action'">
          <span>
            <a-button type="default" shape="circle" @click="handleAction"><InfoCircleOutlined /></a-button>
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

  <!-- Show custom empty state when there is no data -->
  <a-empty v-else :image="simpleImage" :description="null">
    <div v-html="descriptionHtml"></div>
  </a-empty>

</template>

<script lang="ts" setup>

// import { CheckCircleOutlined, SmileOutlined, DownOutlined } from '@ant-design/icons-vue';
// import Modal from './Modal.vue';
import { ref, defineProps, computed, PropType } from 'vue';
import { CheckCircleTwoTone, InfoCircleOutlined, CloseCircleTwoTone, QuestionCircleTwoTone, FrownTwoTone } from '@ant-design/icons-vue';
import { Empty } from 'ant-design-vue';
import jsonData from '../bsn_summary_statement.json';

// Define props
const props = defineProps({
  openModal: Function,
  resultingValues: {
    type: Array as PropType<VoteItem[]>,
    default: () => []
  }
});

const tablefilter = ref('all'); // Default table filter value
const originalTableData = ref([]); // This should be your unfiltered table data
const simpleImage = Empty.PRESENTED_IMAGE_SIMPLE;

const descriptionHtml = computed(() => {
  return 'Keine Abstimmungen vorhanden.<br>Wähle einen anderen Filter oder ein anderes Themengebiet.';
});

const filteredTableData = computed(() => {
  switch (tablefilter.value) {
    case 'all': // Alle Abstimmungen
      return props.resultingValues;
    case 'yes': // Ja
      return props.resultingValues.filter(item => item.behavior.startsWith('Stimmte für'));
    case 'no': // Nein
      return props.resultingValues.filter(item => item.behavior.startsWith('Stimmte gegen'));
    case 'abstain': // Enthaltung
      return props.resultingValues.filter(item => item.behavior.startsWith('Enthielt sich'));
    case 'no_participation': // Keine Teilnahme
      return props.resultingValues.filter(item => item.behavior.startsWith('Keine Teilnahme'));
    default:
      return props.resultingValues;
  }
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

interface VoteItem {
  behavior: string; // Define the properties expected in each item
  // Add other properties as needed
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
    title: 'Status',
    dataIndex: 'status',
    key: 'status',
    width: '10px',
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
