# Merge ChatGPT summaries with voting records of parliamentarians

# Create Shiny App
# "Offene Aussenpolitik":"Liberale Gesellschaft"

# Chat GPT Answer to query "Build Web App with Shiny"
# Update the UI function
ui <- fluidPage(
  titlePanel("Parliamentarian Vote History"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "person_number",
        "Select a Parliamentarian:",
        choices = setNames(
          member_council_legislative_period_51$PersonNumber,
          paste(
            member_council_legislative_period_51$FirstName,
            member_council_legislative_period_51$LastName
          )
        )
      )
    ),
    mainPanel(
      uiOutput("vote_history")
    )
  )
)

# Update the server function
server <- function(input, output) {
  output$vote_history <- renderUI({
    # Filter the voting history by the selected parliamentarian
    filtered_voting_history <- voting_legislative_period_51 %>%
      filter(PersonNumber == input$person_number)
    
    # Join the filtered voting history with business_legislative_period_51 and chatgpt_output_df
    result <- filtered_voting_history %>%
      inner_join(business_legislative_period_51, by = "BusinessShortNumber") %>%
      inner_join(chatgpt_output_df, by = "BusinessShortNumber")
    
    # Select relevant columns and rename them
    result <- result %>%
      select(BusinessShortNumber, Title, query_central_stmnt, Category = "Offene Aussenpolitik":"Liberale Gesellschaft", DecisionText) %>%
      rename(Summary = query_central_stmnt)
    
    # Remove duplicate items of business
    result <- distinct(result, BusinessShortNumber, .keep_all = TRUE)
    
    # Create the card HTML template
    card_template <- '
      <div class="card" style="margin-bottom: 20px; padding: 10px;">
        <h4><strong>Title:</strong> {Title}</h4>
        <p><strong>Summary:</strong> {Summary}</p>
        <p><strong>Categories:</strong> {Category}</p>
        <p><strong>Decision:</strong> {DecisionText}</p>
      </div>'
    #item[,3:10]
    # Generate the HTML code for each card
    cards_html <- lapply(1:nrow(result), function(i) {
      item <- result[i, ]
      category_names <- colnames(chatgpt_output_df)[3:10]
      category_values <- paste0(category_names, ": ", item[,3:10], collapse=", ")
      
      htmltools::HTML(
        glue::glue(
          card_template,
          Title = item$Title,
          Summary = item$Summary,
          Category = category_values,
          DecisionText = item$DecisionText
        )
      )
    })
    
    # Return the HTML code for the cards as a single column
    do.call(htmltools::tagList, cards_html)
  })
}


shinyApp(ui = ui, server = server)
