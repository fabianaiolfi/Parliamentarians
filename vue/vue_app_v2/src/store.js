// store.js
import Vuex from 'vuex';

export default new Vuex.Store({
  state: {
    selectedPerson: null,
    selectedMainTopic: null,
    // Other state as needed...
  },
  mutations: {
    setSelectedPerson(state, person) {
      state.selectedPerson = person;
    },
    setSelectedMainTopic(state, topic) {
      state.selectedMainTopic = topic;
    },
    // Other mutations...
  },
  actions: {
    // Optional: actions for asynchronous operations...
  }
});
