library(shiny)

df <- df_long

ui <- fluidPage(
  titlePanel("Document Intrusion Evaluation"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("topicInput", "Select a topic:", choices = unique(df$topic_value)),
      actionButton("generateButton", "Generate Intrusion Set"),
      helpText("Below are documents from the selected topic. One of them doesn't belong. Spot the intruder!")
    ),
    
    mainPanel(
      uiOutput("docDisplay"),
      selectInput("intruderInput", "Select the intruding document:", choices = NULL),
      actionButton("submitButton", "Submit"),
      textOutput("resultOutput")
    )
  )
)

library(dplyr)

server <- function(input, output, session) {
  
  # Data sample, replace this with your DataFrame
  # df <- data.frame(
  #   document = c('doc1 text', 'doc2 text', 'doc3 text', 'doc4 text', 'doc5 text', 'doc6 text'),
  #   topic = c('A', 'A', 'B', 'B', 'C', 'C')
  # )
  
  
  intrusion_set <- reactiveVal()
  
  observeEvent(input$generateButton, {
    current_topic <- input$topicInput
    representatives <- df %>%
      filter(topic_value == current_topic) %>%
      sample_n(4) %>%
      pull(chatgpt_summaries)
    
    intruders <- df %>%
      filter(topic_value != current_topic) %>%
      sample_n(1) %>%
      pull(chatgpt_summaries)
    
    # Combine and shuffle
    set <- sample(c(representatives, intruders))
    intrusion_set(set)
    
    # Update the chatgpt_summaries display and intruder selection choices
    output$docDisplay <- renderUI({
      wellPanel(
        lapply(intrusion_set(), tags$p)
      )
    })
    updateSelectInput(session, "intruderInput", choices = intrusion_set())
  })
  
  observeEvent(input$submitButton, {
    selected_doc <- input$intruderInput
    correct_intruder <- setdiff(intrusion_set(), df$chatgpt_summaries[df$topic_value == input$topicInput])
    
    if (selected_doc == correct_intruder) {
      output$resultOutput <- renderText("Correct! That document was the intruder.")
    } else {
      output$resultOutput <- renderText("Incorrect. Please try again.")
    }
  })
}

shinyApp(ui, server)
