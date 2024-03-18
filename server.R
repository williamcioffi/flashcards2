library(shiny)

# load files
key <- read.table("imagekey.csv", header = TRUE, sep = ',', stringsAsFactors = FALSE)
imagepaths <- file.path("images", key$filename)
nimages <- length(imagepaths)
curimage <- 1
oo <- 1:nimages
revealed <- FALSE

server <- function(input, output, session) {
  
  reveal <- function() {
    revealed <<- TRUE
  }
  
  prv <- function() {
    revealed <<- FALSE
    curimage <<- curimage - 1
    if(curimage == 0) curimage <<- nimages
  }
  
  nxt <- function() {
    revealed <<- FALSE
    curimage <<- curimage + 1
    if(curimage > nimages) curimage <<- 1
  }
  
  shuffle <- function() {
    revealed <<- FALSE
    oo <<- sample(1:nimages, nimages)
    curimage <<- 1
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
      out <- paste0("<p>", curimage, "/", nimages, "</p>")
      out <- paste0(out, "<br><img src=\"", imagepaths[oo[curimage]], "\" height = \"400\">")
      if(revealed) {
        out <- paste0(out, "<br><p>", key$label[oo[curimage]], "</p>")
      }
      
      out
    })}, input$nxt, input$shuffle, input$prv, input$reveal, input$keys) 
}