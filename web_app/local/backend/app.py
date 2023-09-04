from flask import Flask, jsonify, request
from flask_cors import CORS


import json

app = Flask(__name__)
CORS(app)


# Function to load JSON data
def load_json_data(file_path):
    with open(file_path, 'r') as f:
        return json.load(f)

# Load the JSON data into Python dictionaries
all_businesses_web = load_json_data('../../../data/web/all_businesses_web.json')
voting_all_periods = load_json_data('../../../data/web/voting_all_periods.json')

# Assume the data is loaded as 'voting_all_periods'

@app.route('/api/persons', methods=['GET'])
def get_persons():
    unique_persons = set()
    for record in voting_all_periods:
        person_number = record['PersonNumber']
        first_name = record['FirstName']
        last_name = record['LastName']
        unique_persons.add((person_number, first_name, last_name))
    
    # Convert set to list of dictionaries for JSON serialization
    unique_persons_list = [
        {'PersonNumber': pn, 'FirstName': fn, 'LastName': ln} 
        for pn, fn, ln in unique_persons
    ]
    
    return jsonify(unique_persons_list)

@app.route('/api/business_items/<int:person_number>', methods=['GET'])
def get_business_items(person_number):
    # Filter voting records for the selected person
    person_votes = [record for record in voting_all_periods if record['PersonNumber'] == person_number]
    
    # Create a dictionary to hold the grouped business items
    grouped_business_items = {}
    
    for vote in person_votes:
        business_number = vote['BusinessShortNumber']
        decision_text = vote['DecisionText']
        
        # Find the corresponding business item
        business_item = next((item for item in all_businesses_web if item['BusinessShortNumber'] == business_number), None)
        
        if business_item:
            topic = business_item['chatgpt_topic']
            if topic not in grouped_business_items:
                grouped_business_items[topic] = {}
            
            if decision_text not in grouped_business_items[topic]:
                grouped_business_items[topic][decision_text] = []
            
            grouped_business_items[topic][decision_text].append(business_item)
    
    return jsonify(grouped_business_items)


# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True)
