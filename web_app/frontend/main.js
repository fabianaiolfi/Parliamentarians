// Function to populate the person dropdown
function populateDropdown(persons) {
    const dropdown = document.getElementById('person-dropdown');
    persons.forEach(person => {
        const option = document.createElement('option');
        option.value = person.PersonNumber;
        option.text = `${person.FirstName} ${person.LastName}`;
        dropdown.appendChild(option);
    });
}

// Function to display business items
function displayBusinessItems(data) {
    const container = document.getElementById('business-items-container');
    container.innerHTML = ''; // Clear previous content

    // Loop through topics
    for (const [topic, decisions] of Object.entries(data)) {
        const topicDiv = document.createElement('div');
        topicDiv.className = 'topic-heading';
        topicDiv.textContent = topic;

        // Loop through decision texts
        for (const [decisionText, items] of Object.entries(decisions)) {
            const decisionDiv = document.createElement('div');
            decisionDiv.className = 'decision-heading';
            decisionDiv.textContent = decisionText;

            // Create cards for each business item
            const cards = items.map(item => {
                const card = document.createElement('div');
                card.className = 'business-item-card';
                // card.textContent = item.chatgpt_summary;
                card.textContent = item.chatgpt_vote_yes;
                return card;
            });

            // Append everything
            decisionDiv.append(...cards);
            topicDiv.appendChild(decisionDiv);
        }

        container.appendChild(topicDiv);
    }
}

// Fetch list of persons when the page loads
fetch('http://127.0.0.1:5000/api/persons')
    .then(response => response.json())
    .then(data => populateDropdown(data));

// Event listener for dropdown change
document.getElementById('person-dropdown').addEventListener('change', function() {
    const personNumber = this.value;

    // Fetch business items for the selected person
    fetch(`http://127.0.0.1:5000/api/business_items/${personNumber}`)
        .then(response => response.json())
        .then(data => displayBusinessItems(data));
});
