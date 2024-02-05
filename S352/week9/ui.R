####################################
## STAT S352
## Data Modeling and Inference
## Andrew Womack
####################################
## Shiny App 8.2
## User Interface File
## Independence Assumptions in Tabular Data
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
    titlePanel("Independence Assumptions in Tabular Data"), #title
    
    # Top, main portion
    # For controls and plotting
    fluidRow(sidebarLayout(position="right",
        sidebarPanel(
            
        # This is for controlling the entirety of the app 
            selectInput("model_xyz","Generating Assumption",
                        choices = list("Full Dependence"="full_dep",
                                       "Partial Independence"="part_indep",
                                       "Marginal Independence"="marg_indep",
                                       "Conditional Independence"="cond_indep",
                                       "Full Independence"="full_indep"),
                        selected="full_dep"),
            fluidRow(column(4,radioButtons("n_x","Number X Categories",
                         choices = list("2"=2,"3"=3),
                         selected=2,inline = FALSE)),
                     column(4,radioButtons("n_y","Number Y Categories",
                         choices = list("2"=2,"3"=3),
                         selected=2,inline = FALSE)),
                    column(4,radioButtons("n_z","Number Z Categories",
                                  choices = list("2"=2,"3"=3),
                                  selected=2,inline = FALSE)),
            ),
            
        
           
           
                             
            sliderInput("n_samp","Number of Observations",min=100,max=10000,value=1000,round=TRUE,step=100),
            actionButton("gen_new_probs","New Probabilities",
                         style="padding: 4px; font: '10%'; color: white; background-color: darkblue; border-color: black"
                         ),
            actionButton("gen_new_samps","New Samples",
                         style="padding: 4px; font: '10%'; color: black; background-color: hotpink; border-color: black"
                        )
            
            ),

        mainPanel(
            
        # This is for displaying output related to data and maybe some extra controls
            # Set background color
            tags$head(tags$style(HTML(".col-sm-8 {background-color: lightcyan};"))),
                fluidRow(column(1,""),
                    column(11,
                           fluidRow(
                               column(4,h3("True Prob Z=1"),tableOutput("table1")),
                               column(4,h3("Counts Z=1"),tableOutput("table7")),
                               column(4,h3("Est Prob Z=1"),tableOutput("table4"))
                               )
                           )
                ),
                fluidRow(column(1,""),
                    column(11,
                           fluidRow(
                               column(4,h3("True Prob Z=2"),tableOutput("table2")),
                                column(4,h3("Counts Z=2"),tableOutput("table8")),
                               column(4,h3("Est Prob Z=2"),tableOutput("table5"))
                               )
                           )
                ),
                conditionalPanel("input.n_z==3",
                                 fluidRow(column(1,""),column(11,fluidRow(
                                     column(4,h3("True Prob Z=3"),tableOutput("table3")),
                                     column(4,h3("Counts Z=3"),tableOutput("table9")),
                                     column(4,h3("Est Prob Z=3"),tableOutput("table6"))
                                     )
                                     )
                                     )
                )
            
        )
    ),
    # Lower, second portion 
    # For extra information, might not be necessary
    fluidRow(
        column(4,align="center",h3("Model Graph"),grVizOutput("model_graph")),
        column(4,h3("Model Assumptions"),uiOutput("supp_2")),
        column(4,h3("Parameters"),uiOutput("supp_3")),
    ),
    
    # HTML Tags for playing with formatting
    
    # Formatting sliders in some standard way
    tags$head(tags$style(type="text/css",HTML(".js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {display:none}",".js-irs-0 .irs-single, .js-irs-0 .irs-slider {background:black}")))
)))























