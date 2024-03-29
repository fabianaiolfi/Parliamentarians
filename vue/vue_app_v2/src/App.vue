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
  
  data() {
    return {
      showDiv: true,
    };
  },

  methods: {
    personSelected() {
      if (this.selectedPerson) {
        this.$emit('person-selected');
      }
    },
    hideDiv() {
      this.showDiv = false;
    },
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
    const showDiv = ref(true); // Initialize showDiv as true

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
      if (value) {
        showDiv.value = false;
      }
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
      showDiv
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
        <a-select
          class="custom-select-placeholder"
          v-model:value="selectedPerson"
          show-search
          placeholder="Finde eine:n Nationalrät:in"
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

      <div v-if="showDiv" class="centered-container">
        <h1 style="font-size: 60px; font-weight: bold;">Check Your Rep</h1>
        <h1 style="font-size: 32px; font-weight: bold;">Wie stimmen Nationalrät:innen ab?</h1>
      </div>


      
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
        <p>«Check Your Rep» ist im Rahmen eines <a href="https://www.unilu.ch/en/study/study-programmes/masters-degrees/faculty-of-humanities-and-social-sciences/lucerne-master-in-computational-social-sciences-lumacss/#section=c113738" target="_blank">LUMACSS Capstone Projekts</a> an der Universität Luzern entstanden.</p>
        <p>Daten zu den Abstimmungen werden von <a href="https://github.com/zumbov2/swissparl" target="_blank">swissparl</a> bereit gestellt. Es werden nur Schlussabstimmungen analysiert. Die Zusammenfassungen stammen von <a href="https://openai.com/gpt-4" target="_blank">GPT-4</a>. Es werden ausschliesslich Nationalrät:innen aus der Legislaturperiode 2019–2023 berücksichtigt. Die Themen werden dem aktuellen <a href="https://www.credit-suisse.com/about-us/de/research-berichte/studien-publikationen/sorgenbarometer/download-center.html" target="_blank">Sorgenbarometer</a> entnommen.</p>
        <h3>Fragen, Anregungen, Kontakt</h3>
        <p>Fabian Aiolfi<br>
        fabian.aiolfi [at] gmail.com</p>
        <small>Letzte Aktualisierung: 31. Dezember 2023</small>
      </div>
    </a-modal>

    <a-layout-footer style="text-align: center">
    </a-layout-footer>
  </a-layout>
</template>

<style scoped>

.custom-select-placeholder /deep/ .ant-select-selection-placeholder {
  color: #222 !important;
  /* font-weight: bold !important; */
}


.centered-container {
    text-align: center; /* Center-align the text */
    padding-top: 60px; /* Adjust as needed for spacing from the top */
}

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
