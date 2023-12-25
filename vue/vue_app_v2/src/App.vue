<script>
import { ref, onMounted } from 'vue';
import Modal from './components/Modal.vue';
import Table from './components/Table.vue';

export default {
  components: {
    Modal,
    Table,
  },
  provide() {
    return {
      showModal: this.showModal
    };
  },
  data() {
    return {
      selectedRep: null,
      repOptions: [
        // Populate this array with your options
        { value: 'rep1', label: 'Representative 1' },
        { value: 'rep2', label: 'Representative 2' },
        // ... other options
      ],
    };
  },

  methods: {
    showModal() {
      if (this.modalRef.value) {
        this.modalRef.value.showModal();
      }
    },
    handleChange(value) {
      // Handle the change event
      console.log(value);
    },
  },
};

const handleBlur = () => {
  console.log('blur');
};
const handleFocus = () => {
  console.log('focus');
};
const filterOption = (input, option) => {
    return option.label.toLowerCase().indexOf(input.toLowerCase()) >= 0;
}

</script>


<template>
  <a-layout class="layout">
    <a-layout-header>
    <div class="header-container" style="display: flex; justify-content: space-between; align-items: center;">
      <!-- Left-aligned items -->
      <div>
        <router-link to="/parlamentarier" class="nav-text">Check Your Rep</router-link>
        <a-select
          v-model="selectedRep"
          placeholder="Select a rep"
          style="width: 200px; margin-left: 20px;"
          @change="handleChange"
        >
          <a-select-option v-for="option in repOptions" :value="option.value" :key="option.value">
            {{ option.label }}
          </a-select-option>
        </a-select>
      </div>

      <!-- Right-aligned items -->
      <a-button type="link" class="info-button">
        <router-link to="/info">Info</router-link>
      </a-button>
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
