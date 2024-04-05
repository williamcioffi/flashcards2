# the new way to do keypresses: https://github.com/rstudio/shiny/pull/2018

library(shiny)

ui <- fluidPage(
  titlePanel("flashcards"),
  sidebarLayout(
    sidebarPanel(
      verticalLayout(
        actionButton("reveal", "reveal", style = "height: 30px; width: 70px; margin: 5px"),
        actionButton("nxt", "next", style = "height: 30px; width: 70px; margin: 5px"),
        actionButton("prv", "prev", style = "height: 30px; width: 70px; margin: 5px"),
        actionButton("shuffle", "shuffle", style = "height: 30px; width: 70px; margin: 5px"),
        uiOutput("search"),
        checkboxInput("info2", "crit. 1", value = TRUE),
        checkboxInput("info3", "crit. 2", value = TRUE),
        checkboxInput("info4", "crit. 3", value = TRUE),
        checkboxInput("info5", "crit. 4", value = TRUE)
    ),
    width = 2),
    mainPanel(
      HTML("<p>. = next<br>, = previous<br>/ = reveal<br>; = shuffle</p>"),
      htmlOutput("picture", style = "width: 50%"),
      tags$script('
        $(document).on("keypress", function (e) {
          Shiny.setInputValue("keys", e.which, {priority: "event"});
        });
      ') 
    )
  )
)
