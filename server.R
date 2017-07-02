library(shiny)
library(RWeka)
library(stringr)
library(tm)

shinyServer(function(input, output) {
    # Load functions & dictionary
    source("Predict.R")
    load("Combined.RData")
  
    # Reactively perform word prediction
    observe({
        InputText <- as.character(input$InputBox)
        List_Size <- input$SliderListNo
    
        LastWord <- NULL
        if (str_sub(InputText, start=-1) != " " && InputText != "") {
              LastWord <- CurrentWordPrediction(InputText, nf, List_Size)
              output$Last_Word=renderPrint(cat(LastWord, sep = "\n"))
        } else if(nchar(InputText) > 0) {
              output$Last_Word=renderPrint(cat(""))
        }
        
        if (str_sub(InputText, start=-1) == " ") {
            output$NextWord_List=renderPrint(cat(NextWordPrediction(InputText, nf, List_Size), sep = "\n"))
        } else if (!is.null(LastWord) && lastWords(InputText, 1) %in% LastWord) {
             output$NextWord_List=renderPrint(cat(NextWordPrediction(InputText, nf, List_Size), sep = "\n"))
        } else {
            output$NextWord_List=renderPrint(cat(""))
        }
    })
})