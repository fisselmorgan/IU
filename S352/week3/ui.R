####################################
## STAT S352
## Data Modeling and Inference
## Andrew Womack
####################################
## Shiny App
## User Interface File
## Two Ways to Get Estimators
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
    titlePanel("Two Ways to Get Estimators"), #title
    
    # Top, main portion
    # For controls and plotting
    fluidRow(sidebarLayout(position="right",
        sidebarPanel(
        # This is for controlling the entirety of the app
            fluidRow(
                column(6,
                       selectInput("dataset","Dataset",
                        choices = list("Acme"="acme",
                                       "Poisons"="poisons",
                                       "Melanoma"="melanoma",
                                       "Trees"="trees",
                                       "Gravity"="gravity"),
                        selected="Poisons")
                       ),
                column(6,
                       selectInput("statistic","Measure of Center",
                        choices = list("Mean"="mean",
                                       "Median"="median",
                                       "Huber"="huber",
                                       "Hyperbolic"="hyperbolic",
                                       "All" = "all"),
                        selected="mean")
                       )
                ),
            radioButtons("plot_type","Plot Type",choices=list(
                "Data"="data","Estimating Function"="estimating",
                "Inference Estimating Equation"="inference_ee",
                "Loss Function"="loss"
                ,"Inference Risk Minimization"="inference_risk"),selected = "data",inline=FALSE)
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
    fluidRow(column(4,h3("The Data"),uiOutput("info_1")),
             column(4,h3("Estimating Function"),uiOutput("info_2")),
             column(4,h3("Loss Function"),uiOutput("info_3"))
    ),
    
    # Lowest, third portion
    # For extra information, might not be necessary
    fluidRow(
        column(4,h3("Measures of Center"),uiOutput("supp_3")),
        column(4,h3("Estimating Equation"),uiOutput("supp_1")),
        column(4,h3("Risk Minimization"),uiOutput("supp_2"))
    ),
    
    # HTML Tags for playing with formatting
    
    # Formatting sliders in some standard way
    tags$head(tags$style(type="text/css",HTML(".js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {display:none}",".js-irs-0 .irs-single, .js-irs-0 .irs-slider {background:black}")))
))























