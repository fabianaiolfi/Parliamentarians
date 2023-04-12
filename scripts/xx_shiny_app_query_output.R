# Shiny app displaying ChatGPT query output

ui <- fluidPage(
  titlePanel("Business Short Number App"),
  sidebarLayout(
    sidebarPanel(
      selectInput("business_short_number", "Select BusinessShortNumber:",
                  choices = sample_business$BusinessShortNumber)
    ),
    mainPanel(
      h3("Initial Situation:"),
      textOutput("initial_situation_text"),
      br(),
      h3("Corresponding Content:"),
      uiOutput("chatgpt_content")
    )
  )
)

server <- function(input, output) {
  output$initial_situation_text <- renderText({
    req(input$business_short_number)
    as.character(sample_business[sample_business$BusinessShortNumber == input$business_short_number, "InitialSituation"])
  })
  
  output$chatgpt_content <- renderUI({
    req(input$business_short_number)
    chatgpt_content_filtered <- chatgpt_output_df %>%
      filter(BusinessShortNumber == input$business_short_number) %>%
      arrange(query_type)
    
    content_blocks <- lapply(unique(chatgpt_content_filtered$query_type), function(query_type) {
      content_header <- textOutput(paste0("header_", query_type))
      content_text <- textOutput(paste0("content_", query_type))
      
      output[[paste0("header_", query_type)]] <- renderText(get(query_type))
      output[[paste0("content_", query_type)]] <- renderText(paste(chatgpt_content_filtered[chatgpt_content_filtered$query_type == query_type, "content"], collapse = "\n"))
      
      list(content_header, br(), content_text, br())
    })
    
    do.call(tagList, content_blocks)
  })
}

shinyApp(ui = ui, server = server)
