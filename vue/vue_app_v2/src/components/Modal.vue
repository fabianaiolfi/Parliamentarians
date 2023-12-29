<script>
import { ref, inject, computed } from 'vue';
import { CheckCircleTwoTone, CloseCircleTwoTone, QuestionCircleTwoTone, FrownTwoTone } from '@ant-design/icons-vue';  // Import the icon
//import BSNStatement from './bsn_summary_statement.json'
import NamesSearchSelect from '../names.json'

export default {
  setup() {
    const open = ref(false);

    const showModal = () => {
      open.value = true;
    };

    const handleOk = e => {
      console.log(e);
      open.value = false;
    };

    const selectedPerson = inject('selectedPerson');
    // const NamesSearchSelect = inject('NamesSearchSelect');

    const selectedPersonFullName = computed(() => {
      // Directly access NamesSearchSelect without .value
      if (selectedPerson.value && NamesSearchSelect[selectedPerson.value]) {
        const personInfo = NamesSearchSelect[selectedPerson.value][0];
        return `${personInfo.FirstName} ${personInfo.LastName}`;
      }
      return 'Name not available';
    });


    // Make showModal accessible from the parent
    return { open, showModal, handleOk, selectedPersonFullName };
  },

  props: {
    rowData: Object
  },

  components: {
    CheckCircleTwoTone,
    CloseCircleTwoTone,
    QuestionCircleTwoTone,
    FrownTwoTone
  },
};
</script>

<template>

  <a-modal v-model:open="open" width="1000px" @ok="handleOk" footer="">

    <div class="flex-container" style="margin-top: 20px; align-items: center;">
      <div class="flex-item" style="margin-right: 20px;">
        <p>
          <CheckCircleTwoTone
          two-tone-color="#52c41a"
          style="font-size: 60px;"
          />
        </p>
      </div>

      <div class="flex-item">
        <!-- <h1 style="color: #52c41a;">Valérie Piller Carrard (SP, Freiburg) stimmte für das Bundesgesetz über die Weiterbildung.</h1> -->
        <h1 style="color: #52c41a;">{{ selectedPersonFullName }} {{ rowData.statement }}</h1>
      </div>
    </div>

    <a-divider />
    
    <div>
      <small><strong>KURZ GEFASST</strong></small>
      <p>{{ rowData.summary }}</p>
    </div>
    
    <div style="margin-top: 20px;">

      <p>
        <div class="flex-container">
          <div class="flex-item">
            <small><strong>SCHLUSSRESULTAT</strong></small>
            <p style="color: #eb2f96;"><strong>Das Geschäft wurde abgelehnt</strong></p>
          </div>
          
          <div class="flex-item">
            <small><strong>JA</strong></small>
            <p style="color: #52c41a;"><strong>56</strong></p>
          </div>

          <div class="flex-item">
            <small><strong>NEIN</strong></small>
            <p style="color: #eb2f96;"><strong>77</strong></p>
          </div>

          <div class="flex-item">
            <small><strong>ENTHALTUNGEN</strong></small>
            <p style="color: #b4b4b4;"><strong>3</strong></p>
          </div>

          <div class="flex-item">
            <small><strong>KEINE TEILNAHME</strong></small>
            <p style="color: #b4b4b4;"><strong>2</strong></p>
          </div>
        </div>
      </p>
    </div>

    <a-divider />

    <small><strong>TITEL DES GESCHÄFTS</strong></small>
      <h3>{{ rowData.title }}</h3>

    <div class="flex-container" style="margin-top: 20px;">
      
      <div class="flex-item">
        <small><strong>ABSTIMMUNGSDATUM</strong></small>
        <p>12. Juni 2017</p>
      </div>

      <div class="flex-item">
        <small><strong>GESCHÄFTSTYP</strong></small>
        <p>Geschäft des Bundesrates</p>
      </div>

      <div class="flex-item">
        <small><strong>GESCHÄFT EINGEREICHT VON</strong></small>
        <p>Lombardi Filippo</p>
      </div>

      <div class="flex-item">
        <small><strong>GESCHÄFTSNUMMER</strong></small>
          <p>
            <a href="https://example.net/" target="_blank">12.015 <i class="material-icons" style="font-size: 0.8rem; vertical-align: -2px">open_in_new</i></a>
          </p>
      </div>
    </div>
      
    <a-divider />

    <small><strong>WARUM IST DIESES GESCHÄFT IN DER KATEGORIE «BILDUNG»?</strong></small>
    <p>…</p>
    
  </a-modal>

</template>


<style scoped>
.flex-container {
    display: flex; /* This enables flexbox */
    justify-content: flex-start; /* This spreads out the flex items evenly */
    align-items: top; /* This aligns items vertically */
}

.flex-item {
  margin-right: 40px; /* Adds space to the right of each item */
}
</style>
