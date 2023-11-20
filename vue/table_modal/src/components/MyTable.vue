<template>
  <a-table :dataSource="data" :columns="columns">
    <template v-slot:action="{ record }">
      <a @click="showMyModal(record)">More Information</a>
    </template>
  </a-table>
  <MyModal :isVisible="isMyModalVisible" :content="modalContent" @update:isVisible="handleModalVisibility"></MyModal>
</template>

<script>
import MyModal from './MyModal.vue'; // Adjust the path as necessary

export default {
  components: {
    MyModal
  },
  data() {
    return {
      data: [
        {
          key: '1',
          name: 'John Brown',
        },
        {
          key: '2',
          name: 'Jim Green',
        },
        {
          key: '3',
          name: 'Joe Black',
        },
      ],
      columns: [
        // Define your table columns here
        { title: 'Name', dataIndex: 'name', key: 'name' },
        // Other columns...
        { title: 'Action', key: 'action', slots: { customRender: 'action' } },
      ],
      isMyModalVisible: false,
      modalContent: '',
    };
  },
  methods: {
    showMyModal(record) {
      console.log("showMyModal")
      this.modalContent = `More information about ${record.name}`;
      this.isMyModalVisible = true;
    },
    handleModalVisibility(value) {
      console.log("handleModalVisibility")
      this.isMyModalVisible = value;
      if (!value) {
        this.resetModalContent();
      }
    },
    resetModalContent() {
      console.log("resetModalContent")
      this.modalContent = ''; // Reset any modal-specific data
    }
  }
};
</script>
