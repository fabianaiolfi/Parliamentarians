
# ignore NumbaDeprecationWarning
import numba
import warnings
warnings.filterwarnings("ignore", category=numba.NumbaDeprecationWarning)

from bertopic import BERTopic
#from sklearn.datasets import fetch_20newsgroups

import csv
import re

from nltk.corpus import stopwords



# Import TSV as list of strings
with open('initial_situation.tsv', newline='') as f:
    reader = csv.reader(f, delimiter='\t')
    docs = [item.replace('\xa0', ' ') for sublist in reader for item in sublist]

# Remove punctuation
docs = [re.sub(r'[^\w\s]', '', doc) for doc in docs]

# Remove stopwords
german_stop_words = stopwords.words('german')

# Import custom stopwords file as list of strings
with open('../../data/custom_stopwords.txt', 'r') as f:
   custom_stopwords = f.readlines()

# remove whitespace characters like `\n` at the end of each line
custom_stopwords = [x.strip() for x in custom_stopwords]

# remove stopwords from docs
docs = [' '.join(word for word in doc.lower().split() if word not in german_stop_words) for doc in docs]
docs = [' '.join(word for word in doc.lower().split() if word not in custom_stopwords) for doc in docs]

# remove "na" from docs
docs = [doc for doc in docs if doc != "na"]


# print head of docs
#print(docs[:2])

# print size of docs
#print(len(docs)) # 18846

# BERTopic German model
topic_model = BERTopic(language="german", min_topic_size = 25, verbose = True)
#topic_model = BERTopic(language="german", min_topic_size=10).fit(docs)

topics, probs = topic_model.fit_transform(docs)
#topic_distr, _ = topic_model.approximate_distribution(docs)
#print(topic_distr)

# Export topic_distribution as CSV
# with open('topic_distribution.csv', 'w', newline='') as f:
#     writer = csv.writer(f)
#     writer.writerows(topic_distr)


# Print outputs

print("topic_model.get_topic_info()")
print(topic_model.get_topic_info())
print()

print("topic_model.get_topic(0)")
print(topic_model.get_topic(0))
print()

# extract information on a document level
print("topic_model.get_document_info(docs)")
print(topic_model.get_document_info(docs)) 
print()

# Number of topics
topic_info = topic_model.get_topic_info()
num_topics = topic_info.shape[0]
print(f"There are {num_topics} topics.")


hierarchical_topics = topic_model.hierarchical_topics(docs)
topic_model.visualize_hierarchy(hierarchical_topics=hierarchical_topics)



