
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(magrittr)
library(dplyr)
library(lattice)
library(ggplot2)
library(tidyr)
library(broom)
library(gganimate)

dataset <- data_frame(
  x = seq(0, 10, .1) + rnorm(101, 0, .03),
  y = .025 * (x - 5) ^ 3 + .125 * (x - 7) ^ 2 - .0825 * (x - 3) + rnorm(101, 0, 1)
)

shinyServer(function(input, output) {

  mod <- reactive({
    loess(
      y ~ x, # formula
      degree = input$degree, span = input$span,
      data = dataset
    )

  })

  output$loessPlot <- renderPlot({


    fit <- augment(mod())

    loess.data <- dataset %>%
      mutate(dist = abs(x - input$center)) %>%
      filter(rank(dist) / n() <= input$span) %>%
      mutate(weight = (1 - (dist / max(dist)) ^ 3) ^ 3)

    reg.formula <- ifelse(input$degree == 1, "y~x", "y~poly(x, 2)") %>%
      formula()

    ggplot(loess.data, aes(x = x, y = y)) +
      geom_point(aes(alpha = weight)) +
      geom_smooth(aes(weight = weight, color = "Local\nregression"),
                  method = "lm", formula = reg.formula, se = FALSE) +
      geom_vline(aes(xintercept = input$center), lty = 2) +
      geom_line(aes(y = .fitted, color = "LOESS"), data = fit) +
      scale_color_manual("", values = c("LOESS" = "red", "Local\nregression" = "blue")) +
      scale_alpha_continuous("Observation Weight") +
      theme(legend.position = "bottom", legend.box = "horizontal") +
      ggtitle("LOESS Regression")

  })

})
