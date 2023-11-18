<script>
import { ref } from 'vue';

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
};
</script>

<template>

  <a-modal v-model:open="open" width="1000px" title="Basic Modal" @ok="handleOk">
      <p>Some contents...</p>
      <p>Some contents...</p>
      <p>Some contents...</p>
    </a-modal>

</template>
