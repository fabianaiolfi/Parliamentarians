# Shiny app displaying ChatGPT query output

ui <- fluidPage(
  titlePanel("ChatGPT Output"),
  sidebarLayout(
    sidebarPanel(
      selectInput("business_short_number", "Select BusinessShortNumber:",
                  choices = sample_business$BusinessShortNumber)
    ),
    mainPanel(
      h3("Ausgangslage"),
      uiOutput("initial_situation_text"),
      br(),
      h3("Zusammenfassungen"),
      uiOutput("chatgpt_content")
    )
  )
)

server <- function(input, output) {
  output$initial_situation_text <- renderUI({
    req(input$business_short_number)
    initial_situation_html <- as.character(sample_business[sample_business$BusinessShortNumber == input$business_short_number, "InitialSituation"])
    HTML(initial_situation_html)
  })
  
  output$chatgpt_content <- renderUI({
    req(input$business_short_number)
    chatgpt_content_filtered <- chatgpt_output_df %>%
      filter(BusinessShortNumber == input$business_short_number) %>%
      arrange(query_type)
    
    content_blocks <- lapply(unique(chatgpt_content_filtered$query_type), function(query_type) {
      content_header <- tags$strong(textOutput(paste0("header_", query_type)))
      content_text <- uiOutput(paste0("content_", query_type))
      
      output[[paste0("header_", query_type)]] <- renderText(get(query_type))
      output[[paste0("content_", query_type)]] <- renderUI({
        content_string <- paste(chatgpt_content_filtered[chatgpt_content_filtered$query_type == query_type, "content"], collapse = " ")
        text_with_breaks <- unlist(strsplit(content_string, split = "\\n"))
        html_text_with_breaks <- paste0(text_with_breaks, collapse = "<br>")
        HTML(html_text_with_breaks)
      })
      
      list(content_header, br(), content_text, br())
    })
    
    do.call(tagList, content_blocks)
  })
}

shinyApp(ui = ui, server = server)