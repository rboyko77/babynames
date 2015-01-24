library(shiny)

shinyUI(
    mainPanel(
		h3('Alberta Baby Names 1990 - 2013'),
		radioButtons("gender", label = h3("Gender"),
       		choices = list("girls","boys"),selected = "boys"),
		textInput("queryStr", label = h3("Enter Search Name"), value = ""),
		actionButton("goButton", "Submit"),
		p(' '),
		plotOutput("freqPlot")
	)
)
