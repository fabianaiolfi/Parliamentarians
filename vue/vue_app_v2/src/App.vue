<script>
import { ref, provide } from 'vue';
import NamesSearchSelect from './names.json'
import Modal from './components/Modal.vue';
import Table from './components/Table.vue';

const open = ref(false);

const showModal = () => {
  open.value = true;
};


export default {
  components: {
    Modal,
    Table,
  },

  methods: {
    handleFocus() {
      // console.log('focus');
    },
    handleBlur() {
      // console.log('focus');
    },
  },

  setup() {
    const selectedPerson = ref(null);
    const isModalVisible = ref(false);

    const toggleModal = () => {
      isModalVisible.value = !isModalVisible.value;
    };

    // Provide selectedPerson
    provide(
      'selectedPerson', selectedPerson,
      'showModal', showModal
    );

    // Populate options from NamesSearchSelect
    const options = ref([]);
    for (const personNumber in NamesSearchSelect) {
      const person = NamesSearchSelect[personNumber][0];
      const fullName = `${person.FirstName} ${person.LastName} (${person.PartyAbbreviation}, ${person.CantonName})`;
      options.value.push({
        label: fullName,
        value: personNumber
      });
    }

    // Method to handle change
    const handleChange = (value) => {
      console.log('Person selected:', value);
      selectedPerson.value = value;
    };

    const filterOption = (input, option) => {
    return option.label.toLowerCase().indexOf(input.toLowerCase()) >= 0;
  }

    return {
      options,
      isModalVisible,
      toggleModal,
      filterOption,
      handleChange,
      selectedPerson,
    };
  },
};
</script>


<template>
  <a-layout class="layout">
    <a-layout-header>
    <div class="header-container" style="display: flex; justify-content: space-between; align-items: center;">
      <!-- Left-aligned items -->
      <div>
        <router-link to="/parliamentarian" class="nav-text"></router-link>
        <a-select
          v-model:value="selectedPerson"
          show-search
          placeholder="Wähle eine:n Parlamentarier:in aus"
          style="width: 450px"
          :options="options"
          :filter-option="filterOption"
          size="large"
          @focus="handleFocus"
          @blur="handleBlur"
          @change="handleChange"
    ></a-select>
      </div>
      <a-button type="link" class="info-button" @click="toggleModal">Info</a-button>
      </div>
    </a-layout-header>
    
    <a-layout-content style="padding: 0 50px">
      
    <div :style="{ background: '#F5F5F5', padding: '24px', minHeight: '280px' }">
      <router-view />
    </div>
    </a-layout-content>

    <div>
      <Modal ref="modalRef"/>
    </div>

    <!-- Info Modal -->
    <a-modal v-model:visible="isModalVisible" title="Info" footer="">
      <div>
        <p>Diese Seite ist in Bearbeitung.</p>
      </div>
    </a-modal>

    <a-layout-footer style="text-align: center">
    </a-layout-footer>
  </a-layout>
</template>

<style scoped>
.nav-text {
  color: white;
  margin-right: 16px;
}

.info-button {
  color: white;
}

.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}

::v-deep .ant-menu-item-selected {
  color: #ffffff !important;
  background-color: #001529 !important;
}

.site-layout-content {
  min-height: 280px;
  padding: 24px;
  background: #fff;
}
#components-layout-demo-top .logo {
  /* float: left; */
  width: 120px;
  height: 31px;
  margin: 16px 24px 16px 0;
  background: rgba(255, 255, 255, 0.3);
}
.ant-row-rtl #components-layout-demo-top .logo {
  float: right;
  margin: 16px 0 16px 24px;
}

[data-theme='dark'] .site-layout-content {
  background: #141414;
}
</style>

<style>

body {
  background-color: #F5F5F5;
}

</style>
