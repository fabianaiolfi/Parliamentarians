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

  methods: {
    showModal() {
      if (this.modalRef.value) {
        this.modalRef.value.showModal();
      }
    }
  },
  
  setup() {
    const modalRef = ref(null);
    const tableRef = ref(null);

    const showModal = () => {
      if (modalRef.value) {
        modalRef.value.showModal();
      }
    };

    onMounted(() => {
      // This ensures that modalRef is available after the component has been mounted
      //console.log(modalRef.value); // You can remove this line after verifying
    });

    return { tableRef, modalRef, showModal };
  },
};
</script>


<template>
  <a-layout class="layout">
    <a-layout-header>
      <div class="logo" />
      <a-menu
        theme="dark"
        mode="horizontal"
        :style="{ lineHeight: '64px' }"
      >
      <a-menu-item key="1"><router-link to="/parlamentarier">Parlamentarier:innen</router-link></a-menu-item>
      <a-menu-item key="2"><router-link to="/info">Info</router-link></a-menu-item>
        <!-- <a-menu-item key="1">Parlamentarier:innen</a-menu-item> -->
        <!-- <a-menu-item key="2">Info</a-menu-item> -->
        <!-- <a-menu-item key="3">nav 3</a-menu-item> -->
      </a-menu>
    </a-layout-header>
    <a-layout-content style="padding: 0 50px">
      <a-breadcrumb style="margin: 16px 0">
        <!-- <a-breadcrumb-item>Home</a-breadcrumb-item> -->
        <!-- <a-breadcrumb-item>List</a-breadcrumb-item> -->
        <!-- <a-breadcrumb-item>App</a-breadcrumb-item> -->
      </a-breadcrumb>
      <div :style="{ background: '#F5F5F5', padding: '24px', minHeight: '280px' }">
        <router-view />
      </div>
    </a-layout-content>

    <div>
      <Modal ref="modalRef"/>
      <!-- <Table :open-modal="showModal" /> -->
    </div>

    <a-layout-footer style="text-align: center">
    </a-layout-footer>
  </a-layout>
</template>

<style scoped>

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
  float: left;
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
