<template>
  <a-table :columns="columns" :data-source="data">
    <template #headerCell="{ column }">
      <template v-if="column.key === 'name'">
        <span>
          <smile-outlined />
          Name
        </span>
      </template>
    </template>

    <template #bodyCell="{ column, record }">
      <template v-if="column.key === 'name'">
        <a>
          {{ record.name }}
        </a>
      </template>
      <template v-else-if="column.key === 'tags'">
        <span>
          <a-tag
            v-for="tag in record.tags"
            :key="tag"
            :color="tag === 'loser' ? 'volcano' : tag.length > 5 ? 'geekblue' : 'green'"
          >
            {{ tag.toUpperCase() }}
          </a-tag>
        </span>
      </template>
      <template v-else-if="column.key === 'action'">
        <span>
          <a>Details</a>
          <div>
            <a-button type="primary" @click="props.openModal">Open Modal</a-button>
            <!-- <Modal ref="modalRef"/> -->
          </div>
        </span>
      </template>
      <!-- <Modal v-model:visible="showModal">
        <Modal ref="modalRef"/>
      </Modal> -->
    </template>
  </a-table>
</template>

<script lang="ts" setup>

import { SmileOutlined, DownOutlined } from '@ant-design/icons-vue';
import Modal from './Modal.vue';

import { ref } from 'vue';
import { CheckCircleTwoTone, CloseCircleTwoTone, QuestionCircleTwoTone, FrownTwoTone } from '@ant-design/icons-vue';

// Define props
const props = defineProps({
  openModal: Function
});

const open = ref(false);

// const showModal = () => {
//   open.value = true;
// };

const handleOk = e => {
  console.log(e);
  open.value = false;
};

const setup = () => {
  // Make showModal accessible from the parent
  //return { open, showModal, handleOk };
  return { open, handleOk };
};

const columns = [
  {
    name: 'Name',
    dataIndex: 'name',
    key: 'name',
  },
  {
    title: 'Age',
    dataIndex: 'age',
    key: 'age',
  },
  {
    title: 'Address',
    dataIndex: 'address',
    key: 'address',
  },
  {
    title: 'Tags',
    key: 'tags',
    dataIndex: 'tags',
  },
  {
    title: 'Action',
    key: 'action',
  },
];

const data = [
  {
    key: '1',
    name: 'John Brown',
    age: 32,
    address: 'New York No. 1 Lake Park',
    tags: ['nice', 'developer'],
  },
  {
    key: '2',
    name: 'Jim Green',
    age: 42,
    address: 'London No. 1 Lake Park',
    tags: ['loser'],
  },
  {
    key: '3',
    name: 'Joe Black',
    age: 32,
    address: 'Sidney No. 1 Lake Park',
    tags: ['cool', 'teacher'],
  },
];
</script>

