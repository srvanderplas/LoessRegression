
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Loess Regression Demonstration"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        inputId = "degree",
        label = "Local Regression Type",
        choices = c("Intercept-Only" = 0,
                    "Linear" = 1,
                    "Quadratic" = 2),
        selected = 2,
        inline = T
      ),
      sliderInput(
        inputId = "span",
        label = "Smoothing Window Size",
        min = 0.1,
        max = 1,
        step = 0.05,
        value = 0.75
      ),
      sliderInput(
        inputId = "center",
        label = "Smoothing Window Location",
        min = 0,
        max = 10,
        step = 0.2,
        value = 0,
        animate = animationOptions(
          interval = 1000,
          loop = T
        )
      )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("loessPlot")
    )
  )
))
