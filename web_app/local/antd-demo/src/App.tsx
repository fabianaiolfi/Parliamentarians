import { Button } from 'antd';
import React from 'react';
import React, { useState } from 'react';


// const App: React.FC = () => (
//   <div className="App">
//     <Button type="primary">Button5</Button>
//   </div>
// );

function App() {
  
  const [persons, setPersons] = useState([]);  // For storing the list of persons
  const [selectedPerson, setSelectedPerson] = useState(null);  // For storing the selected person

  return (
    <div className="App">
      
      <h1>Hello, React!</h1>
      {/* <Button type="primary">Ant Design Button</Button> */}

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
    <div id="business-items-container">
        {/* Business items will be populated dynamically */}
    </div>
    
    </div>
  );
}

export default App;
