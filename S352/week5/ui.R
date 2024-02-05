####################################
## STAT S352
## Data Modeling and Inference
## Andrew Womack
####################################
## Shiny App 5
## User Interface File
## Fisher Information
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
    titlePanel("Fisher Information"), #title
    
    # Top, main portion
    # For controls and plotting
    fluidRow(sidebarLayout(position="right",
        sidebarPanel(
        # This is for controlling the entirety of the app 
            selectInput("model","Model",choices = list("Gaussian (sd=1)"="gaussian",
                                                       "Bernoulli"="bernoulli",
                                                       "Poisson"="poisson",
                                                       "Exponential"="exponential"),
                        selected="gaussian"),
            sliderInput("n_samp","Number of Observations",min=10,max=10000,value=10,step=1,round=TRUE),
            conditionalPanel("input.model=='gaussian'",
                sliderInput("mu",withMathJax("$\\mu$"),min=-10,max=10,value=0,round=TRUE)),
            conditionalPanel("input.model=='bernoulli'",
                             sliderInput("p",withMathJax("$p$"),min=0.1,max=0.9,value=0.5,round=-1)),
            conditionalPanel("input.model=='poisson'",
                             sliderInput("lambda",withMathJax("$\\lambda$"),min=1,max=21,value=11,round=TRUE)),
            conditionalPanel("input.model=='exponential'",
                             sliderInput("beta",withMathJax("$\\beta$"),min=1,max=21,value=11,round=TRUE)),
            radioButtons("plot_type","Plot Type",c("Log Likelihood"="loglik","MLE Sampling Distribution"="sampling"),selected = "loglik"),
            actionButton("gen_new","Generate New Sample", style="padding: 4px; font: '10%'; color: black; background-color: hotpink; border-color: black")
        ),
        mainPanel(
        # This is for displaying output related to data and maybe some extra controls
            # Set background color
            tags$head(tags$style(HTML(".col-sm-8 {background-color: lightcyan};"))),
            plotOutput("plot")
        )
    )),
    
    # Lower, second portion 
    # For printing information
    fluidRow(
        column(4,h3("The Model"),uiOutput("info_1")),
        column(4,h3("The Log-Likelihood"),uiOutput("info_2")),
        column(4,h3("The Fisher Information"),uiOutput("info_3"))
    ),
    # HTML Tags for playing with formatting
    
    # Formatting sliders in some standard way
    tags$head(tags$style(type="text/css",HTML(".js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background:black}",".js-irs-0 .irs-single, .js-irs-0 .irs-slider {background:black}"))),
    tags$head(tags$style(type="text/css",HTML(".js-irs-1 .irs-bar-edge, .js-irs-1 .irs-bar {display:none}",".js-irs-1 .irs-single, .js-irs-1 .irs-slider {background:blue}"))),
    tags$head(tags$style(type="text/css",HTML(".js-irs-2 .irs-bar-edge, .js-irs-2 .irs-bar {display:none}",".js-irs-2 .irs-single, .js-irs-2 .irs-slider {background:blue}"))),
    tags$head(tags$style(type="text/css",HTML(".js-irs-3 .irs-bar-edge, .js-irs-3 .irs-bar {display:none}",".js-irs-3 .irs-single, .js-irs-3 .irs-slider {background:blue}"))),
    tags$head(tags$style(type="text/css",HTML(".js-irs-4 .irs-bar-edge, .js-irs-4 .irs-bar {display:none}",".js-irs-4 .irs-single, .js-irs-4 .irs-slider {background:blue}")))
))























