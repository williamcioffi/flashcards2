library(shiny)

# load files and make initial calculations
key_orig <- read.table("imagekey.csv", header = TRUE, sep = ',', stringsAsFactors = FALSE)
imagepaths <- file.path("images", key_orig$filename)
nimages <- nrow(key_orig)
curimage <- 1
oo <- 1:nimages
revealed <- FALSE

ids_list <- sort(unlist(strsplit(unique(c(key_orig$info1, key_orig$info2, key_orig$info3, key_orig$info4, key_orig$info5)), "; ")))

server <- function(input, output, session) {
  # set up reactive values
  values <- reactiveValues(
    key_orig = key_orig,
    key = key_orig,
    imagepaths = imagepaths,
    nimages = nimages,
    curimage = curimage,
    oo = 1:nimages,
    ids_list = ids_list,
    revealed = revealed
  )
  
  observeEvent(input$info2, {
    applyfilter()
  })
  
  observeEvent(input$info3, {
    applyfilter()
  })
  
  observeEvent(input$info4, {
    applyfilter()
  })
  
  observeEvent(input$info5, {
    applyfilter()
  })
  
  
  applyfilter <- function() {
    filt <- rep(FALSE, nrow(values$key_orig))
    
    if(input$info2) filt <- filt | values$key_orig$info2 != ""
    if(input$info3) filt <- filt | values$key_orig$info3 != ""
    if(input$info4) filt <- filt | values$key_orig$info4 != ""
    if(input$info5) filt <- filt | values$key_orig$info5 != ""
    
    values$key <- values$key_orig[filt, ]
    values$imagepaths <- file.path("images", values$key$filename)
    values$nimages <- nrow(values$key)
    values$curimage <- 1
    values$oo <- 1:values$nimages
    values$revealed <- FALSE
    values$ids_list <- sort(unlist(strsplit(unique(c(key_orig$info1, key_orig$info2, key_orig$info3, key_orig$info4, key_orig$info5)), "; ")))
    
    updateSelectInput(session, "id_select",
      choices = values$ids_list,
      selected = NULL
    )
  }
  
  output$search <- renderUI(selectInput(
    "id_select",
    "search id/name",
    choices = values$ids_list,
    multiple = TRUE
  ))
  
  observeEvent(input$id_select, {
    if(!is.null(input$id_select)) {
      values$oo <- grep(paste(input$id_select, collapse = "|"), values$key$label)
    } else {
      values$oo <- 1:values$nimages
    }
    
    values$curimage <- 1
    values$revealed <- FALSE
  }, ignoreNULL = FALSE)
  
  reveal <- function() {
    values$revealed <- TRUE
  }
  
  prv <- function() {
    values$revealed <- FALSE
    values$curimage <- values$curimage - 1
    if(values$curimage == 0) values$curimage <- length(values$oo)
  }
  
  nxt <- function() {
    values$revealed <- FALSE
    values$curimage <- values$curimage + 1
    if(values$curimage > length(values$oo)) values$curimage <- 1
  }
  
  shuffle <- function() {
    values$revealed <- FALSE
    values$oo <- sample(1:values$nimages, values$nimages)
    values$curimage <- 1
    updateSelectInput(session, "id_select",
      choices = values$ids_list,
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
  
  observeEvent(input$keys, {
    curkey <- as.character(input$keys)

    if(length(curkey) == 1) {
    switch(curkey,
      "44" = prv(),
      "46" = nxt(),
      "47" = reveal(),
      "59"  = shuffle()
    )}
  })
  
  output$picture <- bindEvent({
    renderText({
      out <- "nothing selected"

      if(values$nimages > 0) {
        out <- paste0("<p>", values$curimage, "/", length(values$oo), "</p>")
        out <- paste0(out, "<br><img src=\"", values$imagepaths[values$oo[values$curimage]], "\" width = 100%>")
        if(values$revealed) {
          out <- paste0(out, "<br><p>", values$key$label[values$oo[values$curimage]], "</p>")
        }
      }
      
      out
    })}, input$nxt, input$shuffle, input$prv, input$reveal, input$keys, input$id_select, input$info2, input$info3, input$info4, input$info5) 
}