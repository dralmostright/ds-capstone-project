Coursera Data Science Specialization : Capstone Project
========================================================
title : Coursera Capstone Project
author: Suman Adhikari
date: Nov-27-2017
autosize: true
transition: rotate

The Capstone Project 
========================================================
The Objective of this project was to develop a text prediction model and deploy the model via shiny app, which predicts the next possible words based on the user input words.

Presentation highlights:

- Methodology used in developing Algorithm
- Alogorithm response time and accuracy
- Shiny app manual

Data, Models and Alogrithm 
========================================================
- The data used for bulding model was obtained from [HC Corpora Capstone Dataset](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip) which consists of 3 Sets of data taken from sources Blog , News , Twitter.
- The data was sampled randomly to sample size of 10% of toatl data size and sample data was divided in to 80% training and 20% testing data.
- Sample Data was cleaned, lower-cased, removing links, twitter handles, punctuations, numbers and extra whitespaces etc..
- N-gram (2,3,4) were modeled for both respective traning and test sets.
- Perplexity for each model was measured against test data set, with higher the n-gram lower the perplexity.

Data, Models and Alogrithm  contd..
========================================================
- N-gram model with stupid back-off strategy was used for final prediction algorithm.
  - i.e take n-gram input and search in (n+1)-gram model if no match found backoff to n-gram model, similar approach is carried out until a match is found and if still no match found, top unigram words are retruned.
- Various methods of improving the prediction accuracy and speed were explored e.g removing terms with count < 2, splitting joined words and average response time is 1 sec.  


Data Product : Shiny App manual
========================================================
<div style="font-size: 0.6em;"><p>The shiny app interface for data products can be reached via : <a href="https://dralmostright.shinyapps.io/data_science_capstone_project_shiny_app/">Shiny App</a></p>

<p>Please follow the steps as depicted in below snapshot for using app or refer to Use Manual tab in shiny app. When ever you start typing words, word suggestion start to appear.</p>
</div>

<div align="center">
<img src="shiny-app.png" height=450>
</div>

