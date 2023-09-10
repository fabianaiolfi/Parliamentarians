import React, { useState, useEffect } from 'react';
import { Card } from 'antd';


// const App: React.FC = () => (
//   <div className="App">
//     <Button type="primary">Button5</Button>
//   </div>
// );

async function fetchPersons() {
  try {
      // const response = await fetch('/api/persons');
      const response = await fetch('http://localhost:5000/api/persons');
      if (!response.ok) {
          throw new Error(`HTTP error ${response.status}`);
      }
      const data = await response.json();
      return data;
  } catch (error) {
      console.error('Failed to fetch persons:', error);
      return [];
  }
}


async function fetchBusinessItems(personNumber: number | null) {
  // const response = await fetch(`/api/business_items/${personNumber}`);
  const response = await fetch(`http://localhost:5000/api/business_items/${personNumber}`);
  const data = await response.json();
  return data;
}


function App() {

  interface BusinessItem {
    chatgpt_topic: string;
    DecisionText: string;
    BusinessShortNumber: string;
    Summary: string;
    // ... other properties
  }

  // Define an interface for the person object
interface Person {
  PersonNumber: number;  
  FirstName: string;
  LastName: string;
  // ... other fields
}
  
  const [persons, setPersons] = useState<Person[]>([]);  // For storing the list of persons
  const [selectedPerson, setSelectedPerson] = useState<string | null>(null);  // For storing the selected person
  //const [businessItems, setBusinessItems] = useState([]);  // For storing business items
  const [businessItems, setBusinessItems] = useState<BusinessItem[]>([]);
  const uniqueTopics = [...new Set(businessItems.map(item => item.chatgpt_topic))];
  


  const groupedBusinessItems = uniqueTopics.map((topic) => {
    // Filter items for this topic
    const itemsInTopic = businessItems.filter((item) => item.chatgpt_topic === topic);
  
    // Find unique decisions within this topic
    const uniqueDecisions = [...new Set(itemsInTopic.map((item) => item.DecisionText))];
  
    return (
      <div key={topic}>
        <h2>{topic}</h2>
        {uniqueDecisions.map((decision) => {
          // Filter items for this decision within the topic
          const itemsInDecision = itemsInTopic.filter((item) => item.DecisionText === decision);
  
          return (
            <div key={decision}>
              <h3>{decision}</h3>
              {itemsInDecision.map((item) => (
                <Card key={item.BusinessShortNumber} title={item.BusinessShortNumber}>
                  {/* Your item display logic here */}
                  {item.Summary}
                </Card>
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
          const fetchedItems = await fetchBusinessItems(Number(selectedPerson));
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

    {/* {itemsInDecision.map(item => ( */}
    {/* <Card key={item.BusinessShortNumber} title={item.BusinessShortNumber}> */}
        {/* Your item display logic here */}
        {/* {item.Summary} */}
    {/* </Card> */}
{/* ))} */}

    
    </div>
  );
}

export default App;
