<script>
import { ref, onMounted, watch } from 'vue';
import Modal from './components/Modal.vue';
import Table from './components/Table.vue';
import NamesSearchSelect from './names.json'
import Vuex from 'vuex';
// import { createStore } from 'vuex';
// import { mapState } from 'vuex';

// // Vuex store
// const store = createStore({
//   state: {
//     selectedPerson: null,
//     selectedMainTopic: null
//   },
//   mutations: {
//     setSelectedPerson(state, payload) {
//       state.selectedPerson = payload;
//     },
//     setSelectedMainTopic(state, topic) {
//       state.selectedMainTopic = topic;
//     }
//   }
// });

import { useStore } from 'vuex';

const store = useStore();

const onPersonSelected = (personId) => {
  store.commit('setSelectedPerson', personId);
};

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
    const options = []; // Initialize options as an empty array

    // Populate options from NamesSearchSelect
    for (const personNumber in NamesSearchSelect) {
      const person = NamesSearchSelect[personNumber][0]; // Assuming this structure based on your code
      const fullName = `${person.FirstName} ${person.LastName} (${person.PartyAbbreviation}, ${person.CantonName})`;
      options.push({
        label: fullName,
        value: personNumber
      });
    }

    return {
      selectedPerson: '', // Default value for selected person
      options, // The populated options for your select component
    };
  },

  methods: {
    onPersonSelected(personId) {
    this.$store.commit('setSelectedPerson', personId);
  },
    updateContent() {
    if (this.selectedPerson && this.selectedMainTopic) {
      // Logic to update resultingValues...
    }
  },
  handleMainTopicChange(value) {
    this.$store.commit('setSelectedMainTopic', value);
  },
    handlePersonChange(value) {
    this.$store.commit('setSelectedPerson', value);
  },
    onSelectPerson(person) {
    this.$store.commit('setSelectedPerson', person);
  },
  onSelectMainTopic(topic) {
    this.$store.commit('setSelectedMainTopic', topic);
  },
  computed: {
  ...Vuex.mapState(['selectedPerson', 'selectedMainTopic']),
},
    handleChange(value) {
      this.$emit('person-selected', value);
    },
    handleTopicChange(value) {
    this.$emit('topic-selected', value);
  },
    handleFocus() {
    },
    handleBlur() {
    },
    handlePersonSelected(selectedPerson) {
      // this.selectedPerson = selectedPerson;
    },

    filterOption(input, option) {
      return option.label.toLowerCase().indexOf(input.toLowerCase()) >= 0;
  },

    showModal() {
      if (this.modalRef.value) {
        this.modalRef.value.showModal();
      }
    },
},

  filterOption(input, option) {
      // Implement your search filter logic here
      // This usually involves matching the input with the option label
      return option.label.toLowerCase().indexOf(input.toLowerCase()) > -1;
    },
    handleFocus() {
    },
    handleBlur() {
    },
    handleChange(value) {
      // console.log('Selected:', value);
    },
  
    watch: {
  selectedPerson(newPerson, oldPerson) {
    this.updateContent();
  },
  selectedMainTopic(newTopic, oldTopic) {
    this.updateContent();
  }
},
};


</script>


<template>
  <a-layout class="layout">
    <a-layout-header>
    <div class="header-container" style="display: flex; justify-content: space-between; align-items: center;">
      <!-- Left-aligned items -->
      <div>
        <router-link to="/parlamentarier" class="nav-text">Check Your Rep</router-link>
        <a-select
          v-model:value="selectedPerson"
          show-search
          placeholder="Select a person"
          style="width: 450px"
          :options="options"
          :filter-option="filterOption"
          size="large"
          @focus="handleFocus"
          @blur="handleBlur"
          @change="handleChange"
          @person-selected="selectedPerson = $event"
          @topic-selected="selectedMainTopic = $event"
    ></a-select>
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
