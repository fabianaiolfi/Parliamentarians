# Parliamentarians
LUMACSS Capstone Project

## Project Description
- Web app displaying voting records of parliamentarians
- Aim: Generate short statements like “Almost always voted for stronger enforcement of immigration rules” ([source](https://www.theyworkforyou.com/mp/24878/nigel_adams/selby_and_ainsty/votes)).

## Subproject 1: *Data Mining in R* Capstone Project
Aim of this sub-project is to create an first data foundation for the web application. The scope of the data foundation for this sub-project are votes cast by parliamentarians of the Swiss National Council in the 51st legislative period. I will consider vote records cast from the winter session of 2019 until and including the spring session of 2023. To keep things simple I will focus on the final votes cast (“Schlussabstimmung”).

### Workflow
1. Get a list of all the businesses that were voted on in final votes in the defined period.
2. Clean data in preparation for ChatGPT API.
3. Calculate how many tokens in total and what potential ChatGPT API costs could be. Sample if necessary.
4. Clean ChatGPT output.
5. Retrieve a list of all 200 parliamentarians, including their voting records.
6. Link parliamentarian voting records with the ChatGPT output.

### File Structure
00_setup.R
01_parl_data.R
02_chatgpt_api.R
…
