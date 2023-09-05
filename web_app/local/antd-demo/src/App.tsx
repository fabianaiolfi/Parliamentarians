import { Button } from 'antd';
import React from 'react';
import React, { useState } from 'react';
import React, { useState, useEffect } from 'react';
import { Card } from 'antd';


// const App: React.FC = () => (
//   <div className="App">
//     <Button type="primary">Button5</Button>
//   </div>
// );

async function fetchPersons() {
  return [
      { PersonNumber: '1', FirstName: 'John', LastName: 'Doe' },
      { PersonNumber: '2', FirstName: 'Jane', LastName: 'Doe' },
      // Add more persons here
  ];
}

async function fetchBusinessItems(personNumber) {
  // Replace this with actual fetching logic later
  return [
      { BusinessShortNumber: '1', Summary: 'Business 1' },
      { BusinessShortNumber: '2', Summary: 'Business 2' },
      // Add more business items here
  ];
}



function App() {
  
  const [persons, setPersons] = useState([]);  // For storing the list of persons
  const [selectedPerson, setSelectedPerson] = useState(null);  // For storing the selected person
  const [businessItems, setBusinessItems] = useState([]);  // For storing business items
  const uniqueTopics = [...new Set(businessItems.map(item => item.chatgpt_topic))];

  const groupedBusinessItems = uniqueTopics.map(topic => {
    // Filter items for this topic
    const itemsInTopic = businessItems.filter(item => item.chatgpt_topic === topic);

    // Find unique decisions within this topic
    const uniqueDecisions = [...new Set(itemsInTopic.map(item => item.DecisionText))];

    return (
        <div key={topic}>
            <h2>{topic}</h2>
            {uniqueDecisions.map(decision => {
                // Filter items for this decision within this topic
                const itemsInDecision = itemsInTopic.filter(item => item.DecisionText === decision);

                return (
                    <div key={decision}>
                        <h3>{decision}</h3>
                        {itemsInDecision.map(item => (
                            <div key={item.BusinessShortNumber}>
                                {/* Your item display logic here */}
                                {item.Summary}
                            </div>
                        ))}
                    </div>
                );
            })}
        </div>
    );
});


  useEffect(() => {
    async function fetchData() {
        const fetchedPersons = await fetchPersons();
        setPersons(fetchedPersons);
    }
    fetchData();
}, []);  // Empty dependency array means this useEffect runs once when the component mounts

useEffect(() => {
  if (selectedPerson !== null) {
      async function fetchData() {
          const fetchedItems = await fetchBusinessItems(selectedPerson);
          setBusinessItems(fetchedItems);
      }
      fetchData();
  }
}, [selectedPerson]);  // This useEffect runs whenever selectedPerson changes



  return (
    <div className="App">
        {/* Dropdown code */}
        <div id="business-container">
            {groupedBusinessItems}
        </div>
      
      <h1>Hello, React!</h1>
      {/* <Button type="primary">Ant Design Button</Button> */}

      <div id="business-container">
    {businessItems.map((item) => (
        <div key={item.BusinessShortNumber}>
            {item.Summary}
        </div>
    ))}
</div>


      {/* Dropdown for selecting a person */}
    <div id="person-selector">
        <label htmlFor="person-dropdown">Select a Person: </label>
        <select id="person-dropdown" onChange={(e) => setSelectedPerson(e.target.value)}>
    {persons.map((person) => (
        <option key={person.PersonNumber} value={person.PersonNumber}>
            {person.FirstName} {person.LastName}
        </option>
    ))}
</select>

    </div>

    {/* Container for displaying business items */}
    {/* <div id="business-items-container"> */}
        {/* Business items will be populated dynamically */}
    {/* </div> */}

    {itemsInDecision.map(item => (
    <Card key={item.BusinessShortNumber} title={item.BusinessShortNumber}>
        {/* Your item display logic here */}
        {item.Summary}
    </Card>
))}

    
    </div>
  );
}

export default App;
