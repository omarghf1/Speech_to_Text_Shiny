library(textreadr)
library(tidytext)
library(stopwords)
library(dplyr)
library(tidyverse)
library(stringr)
library(ggplot2)
library(tidyr)
library(scales)
library(readr)
library(reshape2)
library(wordcloud)
library(igraph)
library(ggraph)
library(shinydashboard)
library(tidytext)
library(tm)
library(topicmodels)


survey <- read_document(file="Speech Simulation.txt")
survey_results <- c(survey)

#################################################
################## BUILD DTM ####################
#################################################

a <- 26 #how many observations to you have
b <- 9 #how many variables do you have
my_df <- as.data.frame(matrix(nrow=a, ncol=b)) 

for(z in 1:b){
  for(i in 1:a){
    my_df[i,z]<- survey_results[i*b+z-b] 
  }
}

my_txt <- my_df
my_txt <- substr(my_txt, start=11 , stop = 10000)

#custom stop words
cust_stop <- data_frame(
  word = c("uh", "yeah", "lot", "um","ah"), 
  lexicon = rep("custom", each = 5)
)




#################### DEFINE VARIABLES #################

##### DATAFRAME #######
q1 <- my_df$V1
q1 <- as.data.frame(q1)
colnames(q1) <- c("text")
q1 <- data.frame(lapply(q1, as.character), stringsAsFactors=FALSE)

##### DATAFRAME #######
q2 <- my_df$V2
q2 <- as.data.frame(q2)
colnames(q2) <- c("text")
q2 <- data.frame(lapply(q2, as.character), stringsAsFactors=FALSE)

##### DATAFRAME #######
q3 <- my_df$V3
q3 <- as.data.frame(q3)
colnames(q3) <- c("text")
q3 <- data.frame(lapply(q3, as.character), stringsAsFactors=FALSE)

##### DATAFRAME #######
q4 <- my_df$V4
q4 <- as.data.frame(q4)
colnames(q4) <- c("text")
q4 <- data.frame(lapply(q4, as.character), stringsAsFactors=FALSE)

##### DATAFRAME #######
q5 <- my_df$V5
q5 <- as.data.frame(q5)
colnames(q5) <- c("text")
q5 <- data.frame(lapply(q5, as.character), stringsAsFactors=FALSE)


##### DATAFRAME #######
q6 <- my_df$V6
q6 <- as.data.frame(q6)
colnames(q6) <- c("text")
q6 <- data.frame(lapply(q6, as.character), stringsAsFactors=FALSE)

##### DATAFRAME #######
q7 <- my_df$V7
q7 <- as.data.frame(q7)
colnames(q7) <- c("text")
q7 <- data.frame(lapply(q7, as.character), stringsAsFactors=FALSE)

##### DATAFRAME #######
q8 <- my_df$V8
q8 <- as.data.frame(q8)
colnames(q8) <- c("text")
q8 <- data.frame(lapply(q8, as.character), stringsAsFactors=FALSE)

##### DATAFRAME #######
q9 <- my_df$V9
q9 <- as.data.frame(q9)
colnames(q9) <- c("text")
q9 <- data.frame(lapply(q9, as.character), stringsAsFactors=FALSE)

combined_questons <- bind_rows(
  mutate(q1, question = "q1"),
  mutate(q2, question = "q2"),
  mutate(q3, question = "q3"),
  mutate(q4, question = "q4"),
  mutate(q5, question = "q5"),
  mutate(q6, question = "q6"),
  mutate(q7, question = "q7"),
  mutate(q8, question = "q8"),
  mutate(q9, question = "q9")
)

cust_stop <- data_frame( #Creating a new stop words dictionary
  word = c('jobs','uh','um','isn','job','applying', 'like', 'cvs', 
           'yeah','rk','tk','industry','study','studied','university',
           'undergrad','major','studies','international','graduation',
           'college','roles','feel','offer','offered','ot'),
  lexicon= rep("custom",each=26)
  
)        


# load data
fre_1 <- read.csv('fre_1.csv')
fre_2 <- read.csv('fre_2.csv')
fre_3 <- read.csv('fre_3.csv')
fre_4 <- read.csv('fre_4.csv')
fre_5 <- read.csv('fre_5.csv')
fre_6 <- read.csv('fre_6.csv')
fre_7 <- read.csv('fre_7.csv')
fre_8 <- read.csv('fre_8.csv')
fre_9 <- read.csv('fre_9.csv')

# generate mydf
my_df2 <- bind_rows(
  mutate(fre_1, question = 1),
  mutate(fre_2, question = 2),
  mutate(fre_3, question = 3),
  mutate(fre_4, question = 4),
  mutate(fre_5, question = 5),
  mutate(fre_6, question = 6),
  mutate(fre_7, question = 7),
  mutate(fre_8, question = 8),
  mutate(fre_9, question = 9)
)

################################# FUNCTION ######################################

shinyServer(function(input, output) {
  
  ##### PAGE 1 #####
  output$plot1 <- renderPlot({
    
    bing_q1 <-q1 %>%
      unnest_tokens(word, text) %>%
      inner_join(get_sentiments("bing")) %>%
      count(word, sentiment, sort=T) %>%
      ungroup()
    
    bing_q1 %>%
      inner_join(get_sentiments("bing")) %>%
      count(word, sentiment, sort=TRUE) %>%
      acast(word ~sentiment, value.var="n", fill=0) %>%
      comparison.cloud(scale=c(5,5),
                       random.order=FALSE,rot.per=0,
                       use.r.layout=FALSE, title.size=3,
                       colors = c("orangered","mediumseagreen"),
                       title.colors=NULL, match.colors=TRUE,
                       title.bg.colors="grey90")
  })
  
  
  ####### PAGE 2 ####
  
  output$plot2_2 <- renderPlot({
    
    q_bigrams <- q2 %>%
      unnest_tokens(bigram, text, token = "ngrams", n=2)
    
    bigrams_separated <- q_bigrams %>%
      separate(bigram, c("word1", "word2"), sep = " ")
    
    bigrams_filtered <- bigrams_separated %>%
      filter(!word1 %in% stop_words$word) %>%
      filter(!word2 %in% stop_words$word) %>%
      filter(!word1 %in% cust_stop$word) %>%
      filter(!word2 %in% cust_stop$word)
    
    
    bigram_counts <- bigrams_filtered %>%
      count(word1, word2, sort = TRUE)
    
    bigram_graph <- bigram_counts %>%
      filter(n>0) %>%
      graph_from_data_frame()
    
    ggraph(bigram_graph, layout = "fr") +
      geom_edge_link(colour = "tan1") +
      geom_node_point(size = 5, color = "slategray") +
      scale_edge_width(range = c(0.2, 2)) + 
      geom_node_text(aes(label = name), repel = TRUE, point.padding = unit(0.2, "lines"))+
      theme_graph()  
    
  })
  
  ###### PAGE 3 #######
  
  output$plot3_2 <- renderPlot({
    
    q_bigrams <- q3 %>%
      unnest_tokens(bigram, text, token = "ngrams", n=2)
    
    bigrams_separated <- q_bigrams %>%
      separate(bigram, c("word1", "word2"), sep = " ")
    
    bigrams_filtered <- bigrams_separated %>%
      filter(!word1 %in% stop_words$word) %>%
      filter(!word2 %in% stop_words$word) %>%
      filter(!word1 %in% cust_stop$word) %>%
      filter(!word2 %in% cust_stop$word)
    
    bigram_counts <- bigrams_filtered %>%
      count(word1, word2, sort = TRUE)
    
    bigram_graph <- bigram_counts %>%
      filter(n>0) %>%
      graph_from_data_frame()
    
    ggraph(bigram_graph, layout = "fr") +
      geom_edge_link(colour = "tan1") +
      geom_node_point(size = 5, color = "slategray") +
      scale_edge_width(range = c(0.2, 2)) + 
      geom_node_text(aes(label = name), repel = TRUE, point.padding = unit(0.2, "lines"))+
      theme_graph()  
    
  })
  
  ###### PAGE 4 ######
  
  output$plot4_2 <- renderPlot({
    
    q_bigrams <- q4 %>%
      unnest_tokens(bigram, text, token = "ngrams", n=2)
    
    bigrams_separated <- q_bigrams %>%
      separate(bigram, c("word1", "word2"), sep = " ")
    
    bigrams_filtered <- bigrams_separated %>%
      filter(!word1 %in% stop_words$word) %>%
      filter(!word2 %in% stop_words$word) %>%
      filter(!word1 %in% cust_stop$word) %>%
      filter(!word2 %in% cust_stop$word)
    
    bigram_counts <- bigrams_filtered %>%
      count(word1, word2, sort = TRUE)
    
    bigram_graph <- bigram_counts %>%
      filter(n>0) %>%
      graph_from_data_frame()
    
    ggraph(bigram_graph, layout = "fr") +
      geom_edge_link(colour = "tan1") +
      geom_node_point(size = 5, color = "slategray") +
      scale_edge_width(range = c(0.2, 2)) + 
      geom_node_text(aes(label = name), repel = TRUE, point.padding = unit(0.2, "lines"))+
      theme_graph()  
    
  })
  
  
  ####### PAGE 5 #######
  output$plot5 <- renderPlot({
    
    bing_q5 <-q5 %>%
      unnest_tokens(word, text) %>%
      inner_join(get_sentiments("bing")) %>%
      count(word, sentiment, sort=T) %>%
      ungroup()
    
    bing_q5 %>%
      inner_join(get_sentiments("bing")) %>%
      count(word, sentiment, sort=TRUE) %>%
      acast(word ~sentiment, value.var="n", fill=0) %>%
      comparison.cloud(scale=c(5,5),
                       random.order=FALSE,rot.per=0,
                       use.r.layout=FALSE, title.size=3,
                       colors = c("orangered","mediumseagreen"),
                       title.colors=NULL, match.colors=TRUE,
                       title.bg.colors="grey90")
  })
  
  output$plot5_2 <- renderPlot({
    
    q_bigrams <- q5 %>%
      unnest_tokens(bigram, text, token = "ngrams", n=2)
    
    bigrams_separated <- q_bigrams %>%
      separate(bigram, c("word1", "word2"), sep = " ")
    
    bigrams_filtered <- bigrams_separated %>%
      filter(!word1 %in% stop_words$word) %>%
      filter(!word2 %in% stop_words$word) %>%
      filter(!word1 %in% cust_stop$word) %>%
      filter(!word2 %in% cust_stop$word)
    
    bigram_counts <- bigrams_filtered %>%
      count(word1, word2, sort = TRUE)
    
    bigram_graph <- bigram_counts %>%
      filter(n>0) %>%
      graph_from_data_frame()
    
    ggraph(bigram_graph, layout = "fr") +
      geom_edge_link(colour = "tan1") +
      geom_node_point(size = 5, color = "slategray") +
      scale_edge_width(range = c(0.2, 2)) + 
      geom_node_text(aes(label = name), repel = TRUE, point.padding = unit(0.2, "lines"))+
      theme_graph()  
    
  })
  
  ####### PAGE 6 ########
  output$plot6 <- renderPlot({
    
    bing_q6 <-q6 %>%
      unnest_tokens(word, text) %>%
      inner_join(get_sentiments("bing")) %>%
      count(word, sentiment, sort=T) %>%
      ungroup()
    
    bing_q6 %>%
      inner_join(get_sentiments("bing")) %>%
      count(word, sentiment, sort=TRUE) %>%
      acast(word ~sentiment, value.var="n", fill=0) %>%
      comparison.cloud(scale=c(5,5),
                       random.order=FALSE,rot.per=0,
                       use.r.layout=FALSE, title.size=3,
                       colors = c("orangered","mediumseagreen"),
                       title.colors=NULL, match.colors=TRUE,
                       title.bg.colors="grey90")
  })
  
  output$plot6_2 <- renderPlot({
    
    q_bigrams <- q6 %>%
      unnest_tokens(bigram, text, token = "ngrams", n=2)
    
    bigrams_separated <- q_bigrams %>%
      separate(bigram, c("word1", "word2"), sep = " ")
    
    bigrams_filtered <- bigrams_separated %>%
      filter(!word1 %in% stop_words$word) %>%
      filter(!word2 %in% stop_words$word) %>%
      filter(!word1 %in% cust_stop$word) %>%
      filter(!word2 %in% cust_stop$word)
    
    bigram_counts <- bigrams_filtered %>%
      count(word1, word2, sort = TRUE)
    
    bigram_graph <- bigram_counts %>%
      filter(n>0) %>%
      graph_from_data_frame()
    
    ggraph(bigram_graph, layout = "fr") +
      geom_edge_link(colour = "tan1") +
      geom_node_point(size = 5, color = "slategray") +
      scale_edge_width(range = c(0.2, 2)) + 
      geom_node_text(aes(label = name), repel = TRUE, point.padding = unit(0.2, "lines"))+
      theme_graph()  
    
  })
  
  ####### PAGE 7 ########
  
  output$plot7_2 <- renderPlot({
    
    q_bigrams <- q7 %>%
      unnest_tokens(bigram, text, token = "ngrams", n=2)
    
    bigrams_separated <- q_bigrams %>%
      separate(bigram, c("word1", "word2"), sep = " ")
    
    bigrams_filtered <- bigrams_separated %>%
      filter(!word1 %in% stop_words$word) %>%
      filter(!word2 %in% stop_words$word) %>%
      filter(!word1 %in% cust_stop$word) %>%
      filter(!word2 %in% cust_stop$word)
    
    bigram_counts <- bigrams_filtered %>%
      count(word1, word2, sort = TRUE)
    
    bigram_graph <- bigram_counts %>%
      filter(n>0.8) %>%
      graph_from_data_frame()
    
    ggraph(bigram_graph, layout = "fr") +
      geom_edge_link(colour = "tan1") +
      geom_node_point(size = 5, color = "slategray") +
      scale_edge_width(range = c(0.2, 2)) + 
      geom_node_text(aes(label = name), repel = TRUE, point.padding = unit(0.2, "lines"))+
      theme_graph()  
    
  })
  
  ######## PAGE 8 ########
  
  output$plot8_2 <- renderPlot({
    
    q_bigrams <- q8 %>%
      unnest_tokens(bigram, text, token = "ngrams", n=2)
    
    bigrams_separated <- q_bigrams %>%
      separate(bigram, c("word1", "word2"), sep = " ")
    
    bigrams_filtered <- bigrams_separated %>%
      filter(!word1 %in% stop_words$word) %>%
      filter(!word2 %in% stop_words$word) %>%
      filter(!word1 %in% cust_stop$word) %>%
      filter(!word2 %in% cust_stop$word)
    
    bigram_counts <- bigrams_filtered %>%
      count(word1, word2, sort = TRUE)
    
    bigram_graph <- bigram_counts %>%
      filter(n>1) %>%
      graph_from_data_frame()
    
    ggraph(bigram_graph, layout = "fr") +
      geom_edge_link(colour = "tan1") +
      geom_node_point(size = 5, color = "slategray") +
      scale_edge_width(range = c(0.2, 2)) + 
      geom_node_text(aes(label = name), repel = TRUE, point.padding = unit(0.2, "lines"))+
      theme_graph()  
    
  })
  
  
  ######## PAGE 9 ########
  output$plot9 <- renderPlot({
    
    slices <- c(13, 7)
    lbls <- c("No", "Yes")
    pct <- round(slices/sum(slices)*100)
    lbls <- paste(lbls, pct) # add percents to labels
    lbls <- paste(lbls,"%",sep="") # ad % to labels
    pie_q9 <- pie(slices,labels = lbls, col=rainbow(length(lbls)),
                  main="Pie Chart of Countries")
    
  })
  
  
  ######## LDA ########
  output$plot_lda <- renderPlot({
    
  frequencies <- combined_questons %>% #question 1 datafram
    unnest_tokens(word, text) %>%
    anti_join(stop_words) %>% 
    anti_join(cust_stop) %>%
    count(question, word) %>%
    cast_dtm(question, word, n)
  
  
  ap_lda <- LDA(frequencies, k=input$ldaslider, control=list(seed=123)) # started with 2 topics # 4 for the second try
  
  ap_topics <- tidy(ap_lda, matrix="beta")  
  
  top_terms <- ap_topics %>%
    group_by(topic) %>%
    top_n(10, beta) %>%
    ungroup() %>%
    arrange(topic, -beta)
  
  
  #Plot
  top_terms %>%
    mutate(term=reorder(term, beta)) %>%
    ggplot(aes(term, beta, fill = factor(topic))) +
    geom_col(show.legend=FALSE) +
    facet_wrap(~topic, scales = "free") +
    coord_flip()
  
  })

  ######## WORDCLOUD ########
  output$word_graph<- renderPlot({
    my_df2 %>% with(wordcloud(word, n, max.words = input$WordcloudSlider))
  })
  
  
  ######## TFIDF ########
  output$tfidf_graph <- renderPlot({
    survey_words <- my_df2 %>%
      bind_tf_idf(word, question, n) %>%
      mutate(question = as.integer(question)) %>%
      arrange(desc(tf_idf))
    
    
    survey_words %>%
      filter(question == input$TfIdf) %>%
      arrange(desc(tf_idf)) %>%
      top_n(7) %>%
      mutate(word=factor(word, levels=rev(unique(word)))) %>%
      ggplot(aes(word, tf_idf)) +
      geom_col(show.legend=FALSE)+
      labs(x=NULL, y="tf-idf")
    
  })
  
  
})
