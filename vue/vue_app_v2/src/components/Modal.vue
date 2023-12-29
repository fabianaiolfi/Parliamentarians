<script>
import { ref, inject, computed } from 'vue';
import { CheckCircleTwoTone, CloseCircleTwoTone, QuestionCircleTwoTone, FrownTwoTone } from '@ant-design/icons-vue';  // Import the icon
import NamesSearchSelect from '../names.json'

export default {
  props: {
    rowData: Object, // Define rowData as a prop
  },
  setup(props) {

    const formattedDate = computed(() => {
      if (props.rowData && props.rowData.voteDate) {
        const date = new Date(props.rowData.voteDate);
        return date.toLocaleDateString('de-DE', {
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        });
      }
      return '';
    });

    const voteResultTextStyle = computed(() => {
      return {
        color: props.rowData.voteResultText.includes("angenommen") ? '#52c41a' : '#eb2f96'
      };
    });

    const concatenatedValueClass = computed(() => {
      if (formattedConcatenatedValue.value.includes("stimmte für")) {
        return 'text-green';
      } else if (formattedConcatenatedValue.value.includes("stimmte gegen")) {
        return 'text-red';
      } else if (formattedConcatenatedValue.value.includes("enthielt sich") || formattedConcatenatedValue.value.includes("keine Teilnahme")) {
        return 'text-gray';
      }
        return ''; // Default class if none of the conditions are met
    });

    const iconData = computed(() => {
      if (formattedConcatenatedValue.value.includes("stimmte für")) {
        return { component: CheckCircleTwoTone, color: "#52c41a" };
      } else if (formattedConcatenatedValue.value.includes("stimmte gegen")) {
        return { component: CloseCircleTwoTone, color: "#eb2f96" };
      } else if (formattedConcatenatedValue.value.includes("enthielt sich")) {
        return { component: QuestionCircleTwoTone, color: "#b4b4b4" };
      } else if (formattedConcatenatedValue.value.includes("keine Teilnahme")) {
        return { component: FrownTwoTone, color: "#b4b4b4" };
      }
      return {}; // Default case
    });

    const open = ref(false);

    const showModal = () => {
      open.value = true;
    };

    const handleOk = e => {
      console.log(e);
      open.value = false;
    };

    const selectedPerson = inject('selectedPerson');

    const selectedPersonFullName = computed(() => {
      if (selectedPerson.value && NamesSearchSelect[selectedPerson.value]) {
        const personInfo = NamesSearchSelect[selectedPerson.value][0];
        return `${personInfo.FirstName} ${personInfo.LastName} (${personInfo.PartyAbbreviation}, ${personInfo.CantonName})`;
      }
      return 'Name not available';
    });

    const formattedConcatenatedValue = computed(() => {
  if (props.rowData && props.rowData.concatenatedValue) {
    let value = props.rowData.concatenatedValue.charAt(0).toLowerCase() + props.rowData.concatenatedValue.slice(1);

    // Check if the string contains "keine Teilnahme in Bezug auf"
    const searchString = "keine Teilnahme in Bezug auf";
    if (value.includes(searchString)) {
      value = value.replace(searchString, `bekundete ${searchString}`);
    }

    return value;
  }
  return '';
});


    // Combine all the reactive data and methods to be returned from the setup function
    return { open, showModal, handleOk, selectedPersonFullName, formattedConcatenatedValue,
      concatenatedValueClass, iconData, voteResultTextStyle, formattedDate };
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
        <component
          :is="iconData.component"
          :two-tone-color="iconData.color"
          style="font-size: 60px;"
        />
      </p>
      </div>

      <div class="flex-item">
        <h1 :class="concatenatedValueClass">{{ selectedPersonFullName }} {{ formattedConcatenatedValue }}</h1>
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
            <p :style="voteResultTextStyle"><strong>{{ rowData.voteResultText }}</strong></p>
          </div>
          
          <div class="flex-item">
            <small><strong>JA</strong></small>
            <p style="color: #52c41a;"><strong>{{ rowData.voteYes }}</strong></p>
          </div>

          <div class="flex-item">
            <small><strong>NEIN</strong></small>
            <p style="color: #eb2f96;"><strong>{{ rowData.voteNo }}</strong></p>
          </div>

          <div class="flex-item">
            <small><strong>ENTHALTUNGEN</strong></small>
            <p style="color: #b4b4b4;"><strong>{{ rowData.voteAbstention }}</strong></p>
          </div>

          <div class="flex-item">
            <small><strong>KEINE TEILNAHME</strong></small>
            <p style="color: #b4b4b4;"><strong>{{ rowData.voteNoParticipation }}</strong></p>
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
        <p>{{ formattedDate }} </p>
      </div>

      <div class="flex-item">
        <small><strong>GESCHÄFTSTYP</strong></small>
        <p>{{ rowData.businessType }}</p>
      </div>

      <div class="flex-item">
        <small><strong>GESCHÄFT EINGEREICHT VON</strong></small>
        <p>{{ rowData.submittedBy }}</p>
      </div>

      <div class="flex-item">
        <small><strong>GESCHÄFTSNUMMER</strong></small>
          <p>
            <a href="https://example.net/" target="_blank">{{ rowData.businessShortNumber }} <i class="material-icons" style="font-size: 0.8rem; vertical-align: -2px">open_in_new</i></a>
          </p>
      </div>
    </div>
      
    <!-- <a-divider /> -->

    <!-- <small><strong>WARUM IST DIESES GESCHÄFT IN DER KATEGORIE «BILDUNG»?</strong></small> -->
    <!-- <p>…</p> -->
    
  </a-modal>

</template>


<style>

.text-green {
  color: #52c41a;
}
.text-red {
  color: #eb2f96;
}
.text-gray {
  color: #b4b4b4;
}

.flex-container {
    display: flex; /* This enables flexbox */
    justify-content: flex-start; /* This spreads out the flex items evenly */
    align-items: top; /* This aligns items vertically */
}

.flex-item {
  margin-right: 40px; /* Adds space to the right of each item */
}
</style>
