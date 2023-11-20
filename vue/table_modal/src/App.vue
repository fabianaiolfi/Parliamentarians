<template>
  <div id="app">
    <my-table></my-table>
  </div>
</template>

<script>
import MyTable from './components/MyTable.vue'; // Ensure the path is correct

export default {
  name: 'App',
  components: {
    MyTable // Registering the MyTable component
  }
}
</script>

<style>
/* Add your global styles here */
</style>
