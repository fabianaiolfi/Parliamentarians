<template>
    <div class="landing-page">
      <h1>Welcome to Our Website</h1>
      <a-select
        v-model:value="selectedPerson"
        show-search
        placeholder="Wähle eine:n Parlamentarier:in aus"
        style="width: 450px"
        :options="options"
        :filter-option="filterOption"
        size="large"
        @change="handleChange"
      ></a-select>
    </div>
  </template>
  
  <script>
  import { ref, computed } from 'vue';
  import { useRouter } from 'vue-router';
  import NamesSearchSelect from './names.json';
  import { selectedPersonId } from './store.js';

  
  export default {

    setup() {
    const router = useRouter();
  
      const options = computed(() => {
        return Object.entries(NamesSearchSelect).map(([personNumber, personData]) => {
          const person = personData[0];
          const fullName = `${person.FirstName} ${person.LastName} (${person.PartyAbbreviation}, ${person.CantonName})`;
          return { label: fullName, value: personNumber };
        });
      });
  
      const handleChange = (value) => {
        console.log('Selected ID before update:', selectedPersonId.value);
        selectedPersonId.value = value;
        console.log('Selected ID after update:', selectedPersonId.value);
        router.push({ path: '/parliamentarian', query: { personId: value } });
        };
  
      const filterOption = (input, option) => {
        return option.label.toLowerCase().indexOf(input.toLowerCase()) >= 0;
      };
  
      return {
       // selectedPerson,
        options,
        handleChange,
        filterOption,
      };
    },
  };
  </script>
  
  <style>
  /* Your CSS here */
  </style>
  