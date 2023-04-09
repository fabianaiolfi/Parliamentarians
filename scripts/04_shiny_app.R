# Merge ChatGPT summaries with voting records of parliamentarians

# Create Shiny App

# Chat GPT Answer to query "Build Web App with Shiny"
ui <- fluidPage(
  titlePanel("Parliamentarian Vote History"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selected_person", "Select a Parliamentarian:", 
                  choices = setNames(member_council_legislative_period_51$full_name, member_council_legislative_period_51$full_name),
                  selected = NULL)
    ),
    mainPanel(
      uiOutput("vote_history")
    )
  )
)


server <- function(input, output) {
  person_vote_history <- reactive({
    if (!is.null(input$selected_person)) {
      voting_legislative_period_51 %>%
        left_join(member_council_legislative_period_51, by = "PersonNumber") %>%
        filter(full_name == input$selected_person) %>%
        inner_join(sample_business, by = "BusinessShortNumber") %>%
        select(BusinessShortNumber, Point_1, Point_2, Point_3, DecisionText) %>%
        distinct(BusinessShortNumber, .keep_all = TRUE) %>%
        arrange(BusinessShortNumber)
    } else {
      return(NULL)
    }
  })
  
  output$vote_history <- renderUI({
    if (!is.null(input$selected_person)) {
      DTOutput("vote_history_table")
    } else {
      return(NULL)
    }
  })
  
  output$vote_history_table <- renderDT({
    if (!is.null(input$selected_person)) {
      datatable(person_vote_history())
    }
  })
}

shinyApp(ui = ui, server = server)
