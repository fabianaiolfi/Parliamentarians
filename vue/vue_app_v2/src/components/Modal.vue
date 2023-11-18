<script>
import { ref } from 'vue';
import { CheckCircleTwoTone, CloseCircleTwoTone, QuestionCircleTwoTone, FrownTwoTone } from '@ant-design/icons-vue';  // Import the icon

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

    // Make showModal accessible from the parent
    return { open, showModal, handleOk };
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
        <h1 style="color: #52c41a;">Valérie Piller Carrard (SP, Freiburg) stimmte für das Bundesgesetz über die Weiterbildung.</h1>
      </div>
    </div>

    <a-divider />
    
    <div>
      <small><strong>KURZ GEFASST</strong></small>
      <p>Das neue Gesetz soll die Qualität der Weiterbildung verbessern und lebenslanges Lernen fördern.</p>
    </div>
    
    <div style="margin-top: 20px;">
      <!-- <small><strong>SCHLUSSRESULTAT</strong></small>
      <p style="color: #eb2f96;">
        <strong>Das Geschäft wurde abgelehnt</strong>
      </p> -->

      <p>
        <div class="flex-container">
          <div class="flex-item">
            <small><strong>SCHLUSSRESULTAT</strong></small>
            <p style="color: #eb2f96;"><strong>Das Geschäft wurde abgelehnt</strong></p>
          </div>
          
          <div class="flex-item">
            <small><strong>JA</strong></small>
            <p style="color: #52c41a;">56</p>
          </div>

          <div class="flex-item">
            <small><strong>NEIN</strong></small>
            <p style="color: #eb2f96;">77</p>
          </div>

          <div class="flex-item">
            <small><strong>ENTHALTUNGEN</strong></small>
            <p style="color: #b4b4b4;">3</p>
          </div>

          <div class="flex-item">
            <small><strong>KEINE TEILNAHME</strong></small>
            <p style="color: #b4b4b4;">2</p>
          </div>
        </div>
      </p>
    </div>

    <a-divider />

    <small><strong>TITEL DES GESCHÄFTS</strong></small>
      <h3>Bundesgesetz über die Weiterbildung</h3>

    <div class="flex-container" style="margin-top: 20px;">
      <!-- <div class="flex-item">
        <small><strong>TITEL DES GESCHÄFTS</strong></small>
        <p>Bundesgesetz über die Weiterbildung Bundesgesetz über die Weiterbildung Bundesgesetz über die Weiterbildung</p>
      </div> -->
      
      <div class="flex-item">
        <small><strong>DATUM</strong></small>
        <p>12. Juni 2017</p>
      </div>

      <div class="flex-item">
        <small><strong>GESCHÄFTSTYP</strong></small>
        <p>Geschäft des Bundesrates</p>
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