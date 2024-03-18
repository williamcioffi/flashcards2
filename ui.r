library(shiny)

ui <- fluidPage(
  titlePanel("flashcards"),
  sidebarLayout(
    sidebarPanel(
      verticalLayout(
        actionButton("reveal", "reveal", style = "height: 30px; width: 70px; margin: 5px"),
        actionButton("nxt", "next", style = "height: 30px; width: 70px; margin: 5px"),
        actionButton("prv", "prev", style = "height: 30px; width: 70px; margin: 5px"),
        actionButton("shuffle", "shuffle", style = "height: 30px; width: 70px; margin: 5px")
    ),
    width = 2),
    mainPanel(
      h6("> nxt < previous / reveal z shuffle"),
      htmlOutput("picture"),
      tags$script('
        $(document).on("keypress", function (e) {
          Shiny.onInputChange("keys", e.which);
        });
      ') 
    )
  )
)
