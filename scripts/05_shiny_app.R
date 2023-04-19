# Merge ChatGPT summaries with voting records of parliamentarians

# Create Shiny App

# Chat GPT Answer to query "Build Web App with Shiny"
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
      tableOutput("vote_history")
    )
  )
)


server <- function(input, output) {
  output$vote_history <- renderTable({
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
    
    # Remove the BusinessShortNumber column for display purposes
    result <- select(result, -BusinessShortNumber)
    
    return(result)
  })
}

shinyApp(ui = ui, server = server)
