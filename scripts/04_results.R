# Merge ChatGPT summaries with voting records of parliamentarians

# Create Shiny App

# Chat GPT Answer to query "Build Web App with Shiny"
ui <- fluidPage(
  titlePanel("Parliamentarian Voting History"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "selected_person",
        "Choose a parliamentarian:",
        choices = unique(member_council_legislative_period_51$PersonNumber),
        selected = NULL
      )
    ),
    
    mainPanel(
      uiOutput("vote_history")
    )
  )
)

server <- function(input, output) {
  output$vote_history <- renderUI({
    if (!is.null(input$selected_person)) {
      person_vote_history <- voting_legislative_period_51 %>%
        filter(PersonNumber == input$selected_person) %>%
        left_join(member_council_legislative_period_51, by = "PersonNumber") %>%
        inner_join(sample_business, by = "BusinessShortNumber") %>%
        group_by(DecisionText) %>%
        arrange(BusinessShortNumber)
      
      output_list <- list()
      
      for (group in unique(person_vote_history$DecisionText)) {
        output_list[[group]] <- DTOutput(group)
        output[[group]] <- renderDT({
          votes <- person_vote_history %>%
            filter(DecisionText == group) %>%
            select(BusinessShortNumber, Point_1, Point_2, Point_3, DecisionText)
          
          datatable(votes)
        })
      }
      
      return(output_list)
    } else {
      return(NULL)
    }
  })
}

shinyApp(ui = ui, server = server)