<script setup>

import { ref, computed } from 'vue'
import { CheckCircleTwoTone, CloseCircleTwoTone, QuestionCircleTwoTone, FrownTwoTone } from '@ant-design/icons-vue';  // Import the icon

// Importing the JSON files
import names_sbn from './namesSBN.json'
const names = ref(Object.keys(names_sbn))
const selectedName = ref(names.value[0])
import voteStatement from './vote_statement.json'
import bsnURL from './bsn_url.json'

// Computed property for selectedBusinessItems based on vote_statement.json
const selectedVoteStatement = computed(() => {
  return voteStatement[selectedName.value] || []
})

// Function to assign a priority based on the starting text of vote_statement
function assignPriority(statement) {
  if (statement.startsWith("Stimmte für")) return 1;
  if (statement.startsWith("Stimmte gegen")) return 2;
  if (statement.startsWith("Enthielt sich")) return 3;
  if (statement.startsWith("Keine Teilnahme")) return 4;
  return 5; // Default priority for unrecognized statements
}

// Computed property to group cards by topic
const groupedByTopic = computed(() => {
  const grouped = {};
  const items = selectedVoteStatement.value;
  items.forEach(item => {
    const topic = item.chatgpt_topic || 'Unknown Topic';  // Replace 'Topic' with the actual key for the topic in your JSON
    if (!grouped[topic]) {
      grouped[topic] = [];
    }
    grouped[topic].push(item);
  });
  // Sort the cards within each group based on priority
for (const topic of Object.keys(grouped)) {
  grouped[topic].sort((a, b) => assignPriority(a.vote_statement) - assignPriority(b.vote_statement));
}

  return grouped;
});

// Select Search Dropdown
import NamesSearchSelect from './names_search_select.json'
const options = ref(NamesSearchSelect)
const value = selectedName; // Select first name on load

function handleChange(newValue) {
  selectedName.value = newValue;  // Update selectedName whenever the dropdown changes
}
const handleBlur = () => {
  console.log('blur');
};
const handleFocus = () => {
  console.log('focus');
};
const filterOption = (input, option) => {
  return option.value.toLowerCase().indexOf(input.toLowerCase()) >= 0;
};

// Make parliamentarian name nice in topic group title above cards
function formatName(name) {
  // Remove brackets and words within brackets
  const cleanedName = name.replace(/\(.*?\)/g, '').trim();
  // Upper case the first letter of every word
  return cleanedName.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
}
const formattedSelectedName = computed(() => formatName(selectedName.value));

// get the appropriate icon and its color based on the vote_statement
const icons = {
  CheckCircleTwoTone,
  CloseCircleTwoTone,
  QuestionCircleTwoTone,
  FrownTwoTone
};
const iconColors = {
  'Stimmte für': '#52c41a',
  'Stimmte gegen': '#eb2f96',
  'Enthielt sich': '#b4b4b4',
  'Keine Teilnahme': '#b4b4b4'
};
function getStatementStart(statement) {
  if (statement.startsWith("Stimmte für")) return 'Stimmte für';
  if (statement.startsWith("Stimmte gegen")) return 'Stimmte gegen';
  if (statement.startsWith("Enthielt sich")) return 'Enthielt sich';
  if (statement.startsWith("Keine Teilnahme")) return 'Keine Teilnahme';
  return null;
}
function getIconForStatement(statement) {
  if (statement.startsWith("Stimmte für")) return icons.CheckCircleTwoTone;
  if (statement.startsWith("Stimmte gegen")) return icons.CloseCircleTwoTone;
  if (statement.startsWith("Enthielt sich")) return icons.QuestionCircleTwoTone;
  if (statement.startsWith("Keine Teilnahme")) return icons.FrownTwoTone;
  return null;  // Default, no icon
}

// collapse element stuff
const activeKey = ref(null);
function setActiveKey(key) {
  activeKey.value = activeKey.value === key ? null : key;
}

</script>


<template>

<div style="background: #F5F5F5; padding: 0px; display: flex; flex-direction: column;">
  <!-- Wrapper for alignment -->
  <div style="width: 100%;">  <!-- Adjust the width to your liking -->
    <!-- New Dropdown -->
    <div style="text-align: left; margin-bottom: 20px;">
      <a-select
        v-model:value="value"
        show-search
        placeholder="Select a person"
        style="width: 400px"
        :options="options"
        :filter-option="filterOption"
        @focus="handleFocus"
        @blur="handleBlur"
        @change="handleChange"
      ></a-select>
    </div>
    
    <!-- Grouped Collapse -->
    <div v-for="(group, topic) in groupedByTopic" :key="topic">
    <div style="margin-bottom: 20px; margin-top: 40px;">
      <h3>Wie {{ formattedSelectedName }} über <b>{{ topic }}</b> abgestimmt hat</h3>
    </div>
    <a-space direction="vertical" style="width: 100%;">
      <div v-for="item in group" :key="item.BusinessShortNumber">
        <a-collapse :style="{ backgroundColor: 'white' }" :active-key="activeKey === item.BusinessShortNumber ? [item.BusinessShortNumber] : []" @change="() => setActiveKey(item.BusinessShortNumber)">
          <a-collapse-panel :key="item.BusinessShortNumber" :show-arrow="false">
            <!-- Custom title with dynamic icon -->
            <template #header>
              <component
                :is="getIconForStatement(item.vote_statement)"
                :two-tone-color="iconColors[getStatementStart(item.vote_statement)]"
              /> {{ item.vote_statement }}
            </template>
            <p><b>{{ item.Title || 'Title not available' }}</b><br>{{ item.chatgpt_summary || 'Summary not available' }}</p>
            <!-- <small>BSN: {{ item.BusinessShortNumber }}</small> -->
            <small>Details: <a :href="bsnURL[item.BusinessShortNumber]" target="_blank">parlament.ch <i class="material-icons" style="font-size: 0.8rem; vertical-align: -2.6px">open_in_new</i></a></small>
          </a-collapse-panel>
        </a-collapse>
      </div>
    </a-space>
  </div>

  </div>
</div>

</template>


