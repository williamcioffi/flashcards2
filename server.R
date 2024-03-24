library(shiny)

# load files
key <- read.table("imagekey.csv", header = TRUE, sep = ',', stringsAsFactors = FALSE)
imagepaths <- file.path("images", key$filename)
nimages <- nrow(key)
curimage <- 1
oo <- 1:nimages
revealed <- FALSE

server <- function(input, output, session) {
  output$search <- renderUI(selectInput(
    "id_select",
    "search id",
    choices = key$label,
    multiple = TRUE
  ))
  
  observeEvent(input$id_select, {
    if(!is.null(input$id_select)) {
      oo <<- grep(paste(input$id_select, collapse = "|"), key$label)
      curimage <<- 1
      revealed <<- FALSE
    } else {
      oo <<- 1:nimages
      curimage <<- 1
      revealed <<- FALSE
    }
  }, ignoreNULL = FALSE)
  
  reveal <- function() {
    revealed <<- TRUE
  }
  
  prv <- function() {
    revealed <<- FALSE
    curimage <<- curimage - 1
    if(curimage == 0) curimage <<- length(oo)
  }
  
  nxt <- function() {
    revealed <<- FALSE
    curimage <<- curimage + 1
    if(curimage > length(oo)) curimage <<- 1
  }
  
  shuffle <- function() {
    revealed <<- FALSE
    oo <<- sample(1:nimages, nimages)
    curimage <<- 1
    updateSelectInput(session, "id_select",
      choices = ids_list,
      selected = NULL
    )
  }
  
  observeEvent(input$reveal, {
    reveal()
  })
  
  observeEvent(input$prv, {
    prv()
  })
  
  observeEvent(input$nxt, {
    nxt()
  })
  
  observeEvent(input$shuffle, {
    shuffle()
  })
  
  observe({
    curkey <- as.character(input$keys)

    if(length(curkey) == 1) {
    switch(curkey,
      "44" = prv(),
      "46" = nxt(),
      "47" = reveal(),
      "122"  = shuffle()
    )}
  })
  
  output$picture <- bindEvent({
    renderText({
      out <- paste0("<p>", curimage, "/", length(oo), "</p>")
      out <- paste0(out, "<br><img src=\"", imagepaths[oo[curimage]], "\" width = 100%>")
      if(revealed) {
        out <- paste0(out, "<br><p>", key$label[oo[curimage]], "</p>")
      }
      
      out
    })}, input$nxt, input$shuffle, input$prv, input$reveal, input$keys, input$id_select) 
}