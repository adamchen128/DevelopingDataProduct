library(shiny)

shinyUI(fluidPage(
    navbarPage("Next Word Prediction",
        tabPanel("Main",
            sidebarLayout(
                sidebarPanel(
                    h3('Input Box:'), 
                    tags$textarea(id="InputBox", rows=2, cols=35),
                    sliderInput("SliderListNo", "Number of List Words", 1, 10, 5),
                    submitButton("Submit"),
                    HTML("<br><br>"),
                    h3("Instructions"),
                    HTML("<p>This Shiny App predicts the next word based on the words you type in the Input Box."),
                    HTML("<li><b>Input Box</b>: Words entered for predicting the next word."),
                    HTML("<br><br><li><b>No. of Predicted Words</b>: The maximun number of words will be displayed."),
                    HTML("<br><br><li><b>Predicted Words</b>: The predicted next word(s), shown after you click the [Submit] button."),
                    HTML("<br><br><li><b>Currently Typed Word</b>: Will display a posible word if you type a word partially."),
                    HTML("<br><br>It takes about 2 seconds for the predicted word list to be displayed.")
                ),
                mainPanel(
                    h3("Predicted Next Word"),
                    verbatimTextOutput('NextWord_List'),
                    HTML("<br>"),
                    h4("Currently Typed Word"),
                    verbatimTextOutput('Last_Word')
                )
            )
        ),
        tabPanel("Documentation",
            mainPanel(column(12, includeHTML("Documentation.html"))
            )
        )
    )
))
