# Speech to Text - R Shiny Dashboard

This project was done for the Masters program of Business Analytics at Hult International Business School. The scope of the project was to select a topic, interview a group of people using a speech to text application, then analyze the words used to arrive, and arrive at conclusion.

## File Context
- "fre_#" (1-9): Excel files that contain the frequency by tokens for each question.
- server/ ui: These R files, together, allow you to open the Shiny app.

## Project Theme
This project was based on the question:

**"How do our studies and previous experiences affect out job hunt?"**

## Process Workflow

- We created 9 questions based on the topic above.
- 26 participants were interviewed
- Used Speech to Text App all  respondant answers on text
- Tokenized each word and ranked them by frequency
- Removed stop words such as "the", "a", "and", etc.
- Created different visualizations per question to analyze what words stood out
- Used 'bing' sentiment analysis package to analyze the sentiment of the words used
- Created interactive Shiny app to share the visuals

## Questions Used and Visualizations Used

1. Tell me about your previous work experience
   - Word Cloud using Bing Sentiment Analysis

2. Where and what did you study for your undergraduate degree
   - Analyzed the frequency of bigrams, or two words used the most together.

3. Where were you born, and where did you grow up?
   - Analyzed the frequency of bigrams, or two words used the most together.

4. What countries and cities are you looking to apply or work in?
   - Analyzed the frequency of bigrams, or two words used the most together.

5. Do you need sponsorship or change of visa status to work in the places you are applying in?
   - Analyzed the frequency of bigrams, or two words used the most together.

6. How is your job search going?
   - Word Cloud using Bing Sentiment Analysis

7. What are some industries and companies you are looking to apply for?
   - Analyzed the frequency of bigrams, or two words used the most together.

8. What roles are you looking at?
   - Analyzed the frequency of bigrams, or two words used the most together.

9. Do you have a job offer?
   - Pie chart displaying the yes and no responses

## Key Takeaways

1. Analyst was the most popular role
2. Rather positive sentiment on job search
3. Big US cities as main targets
4. China, India, and Africa most frequent nationalities/regions.

## About the respondants

Since this questionnaire and project was done with other Masters students here are some characteristics of the audience:

- We were located in San Francisco
- Our university has campuses in Boston, New York, and San Francisco
- Many of the respondants were international students
- Many of the respondants are pursuing analyst careers
- Participants are between 23 and 40 y/o.


## What is sentiment analysis/ What is Bing Lexicon?
Sentiment analysis is an approach to understanding opinions of people through text and the words used. There are multiple tools (lexicons) available to do sentiment analysis:
- NRC: This is a technique used to categorize words into eight emotions by association (anger, fear, trust, surprise, sadness, joy, and disgust).
- AFINN: is a rating from -5 to +5 that categorizes words based on how positive or how negative it is.
- **Bing:** This is the technique used in this analysis, it is the simplest tool as it only categorizes words in either positive or negative.



