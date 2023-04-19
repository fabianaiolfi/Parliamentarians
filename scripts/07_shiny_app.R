# Merge ChatGPT summaries with voting records of parliamentarians

# Chat GPT Answer to query "Build Web App with Shiny"
ui <- fluidPage(
  titlePanel("Abstimmungsverhalten Nationalrät:innen 2019–2023"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "person_number",
        "Parlamentarier:in auswählen",
        choices = setNames(
          member_council_legislative_period_51$PersonNumber,
          paste(
            member_council_legislative_period_51$FirstName,
            member_council_legislative_period_51$LastName
          )
        ),
        selected = sample(member_council_legislative_period_51$PersonNumber, 1)
      ),
      selectInput(
        "category_filter",
        "Abstimmungen nach Kategorie filtern",
        choices = c("Alle Kategorien", colnames(chatgpt_output_df)[3:10])
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
      select(BusinessShortNumber, Title, query_central_stmnt, "Offene Aussenpolitik":"Liberale Gesellschaft", DecisionText)
    
    # Remove duplicate items of business
    result <- distinct(result, BusinessShortNumber, .keep_all = TRUE)
    
    # Apply category filtering
    if (input$category_filter != "Alle Kategorien") {
      result <- result %>%
        filter_at(vars(input$category_filter), any_vars(!is.na(.))) %>%
        arrange(desc(!!sym(input$category_filter)))
    }
    
    card_template <- '
  <div class="card" style="margin-bottom: 20px; padding: 10px;">
    <h4>{Title}</h4>
    <p>{Summary}</p>
    <p>{Category}</p>
    <p><strong>Stimmentscheid: {DecisionText}</strong></p>
  </div>
    <hr>'
    
    # Generate the cards HTML
    cards_html <- lapply(1:nrow(result), function(i) {
      item <- result[i, ]
      category_names <- colnames(chatgpt_output_df)[3:10]
      category_values_with_na <- paste0(category_names, ": ", item[,4:11])
      category_values <- paste(category_values_with_na[!is.na(item[,4:11])], collapse="<br>")
      
      htmltools::HTML(
        glue::glue(
          card_template,
          Title = item$Title,
          Summary = item$query_central_stmnt,
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

