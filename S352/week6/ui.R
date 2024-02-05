####################################
## STAT S352
## Data Modeling and Inference
## Andrew Womack
####################################
## Shiny App 6
## User Interface File
## Likelihood Ratio Test
####################################
## Save the ui.R and server.R files into a single directory by themselves
## To run: 
## 1) click on  the Run App button in RStudio after opening one of these files
## OR 
## 2) use the runApp function from the shiny library runApp(appDir) where appDir is the directory the app is stored in
####################################

# Loading necessary libraries
library(shiny) # Always needed
library(shinythemes) # Needed for theme

shinyUI(
fluidPage(
    theme = shinytheme("cosmo"), # Set theme
    withMathJax(), # LaTeX interpreter
    tags$div(HTML("<script type='text/x-mathjax-config' >
            MathJax.Hub.Config({
            tex2jax: {inlineMath: [['$','$']]}
            });
            </script >
            ")), # Adding inline
    titlePanel("The Likelihood Ratio Test"), #title
    
    # Top, main portion
    # For controls and plotting
    fluidRow(sidebarLayout(position="right",
        sidebarPanel(
        # This is for controlling the entirety of the app 
            selectInput("model","Model",choices = list("Gaussian"="gaussian",
                                                       "Bernoulli"="bernoulli",
                                                       "Poisson"="poisson",
                                                       "Gamma"="gamma"),
                        selected="gaussian"),
            sliderInput("n_samp","Number of Observations",min=10,max=1000,value=50,round=TRUE),
            sliderInput("theta",withMathJax("True $\\theta$"),min=-2,max=2,value=0,round=FALSE,step=0.1),
            radioButtons("plot_type","Plot Type",choices=list(
                "Log-Likelihood"="loglik",
                "Test Statistic Sampling Distribution"="sampling_distribution"),selected = "loglik",inline=FALSE),
            fluidRow(
            column(6,actionButton("null_true","Force Null to be True",
                         style="padding: 4px; font: '10%'; color: black; background-color: plum; border-color: black")),
            column(6,actionButton("gen_new","Generate New Sample",
                         style="padding: 4px; font: '10%'; color: black; background-color: hotpink; border-color: black"))
            )
        ),

        mainPanel(
        # This is for displaying output related to data and maybe some extra controls
            # Set background color
            tags$head(tags$style(HTML(".col-sm-8 {background-color: lightcyan};"))),
            plotOutput("plots")
        )
    )),
    
    # Lower, second portion 
    # For printing information
    fluidRow(column(4,h3("Model and Hypotheses"),uiOutput("info_1")),
             column(4,h3("Likelihood Ratio Test Statistic"),uiOutput("info_2")),
             column(4,h3("The AIC"),uiOutput("info_3"))
    ),
    
    # Lowest, third portion
    # For extra information, might not be necessary
    fluidRow(
        column(4,h3("Hypothesis Tests"),uiOutput("supp_1")),
        column(4,h3("Significance and Power"),uiOutput("supp_2")),
        column(4,h3("Likelihood Ratio Test"),uiOutput("supp_3"))
    ),
    
    # HTML Tags for playing with formatting
    
    # Formatting sliders in some standard way
    tags$head(tags$style(type="text/css",HTML(".js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {display:none}",".js-irs-0 .irs-single, .js-irs-0 .irs-slider {background:black}"))),
    tags$head(tags$style(type="text/css",HTML(".js-irs-1 .irs-bar-edge, .js-irs-1 .irs-bar {display:none}",".js-irs-1 .irs-single, .js-irs-1 .irs-slider {background:plum}")))
))























