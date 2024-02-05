####################################
## STAT S352
## Data Modeling and Inference
## Andrew Womack
####################################
## Shiny App 8.2
## Server File
## Independence Assumptions in Tabular Data
####################################

library(shiny)
library(limSolve)
library(DiagrammeR)


## Functions for separating content and computation from formatting

##################
# Loading data
##################

supp_2_fun  = function(model){
  if(model=="full_dep"){
    ind = "\\text{None}"
    fac = "f(x,y,z)"
  }else if(model=="part_indep"){
    ind = "(X,Y)\\perp\\!\\!\\!\\perp Z"
    fac = "f(z)\\,f(x,y)"
  }else if(model=="cond_indep"){
    ind = "(X\\perp\\!\\!\\!\\perp Y)|Z"
    fac = "f(z)\\,f(x|z)\\,f(y|z)"
  }else if(model=="marg_indep"){
    ind = "X\\perp\\!\\!\\!\\perp Y"
    fac = "f(x)\\,f(y)\\,f(z|x,y)"
  }else{
    ind = "X\\perp\\!\\!\\!\\perp Y\\quad X\\perp\\!\\!\\!\\perp Z\\quad Y\\perp\\!\\!\\!\\perp Z"
    fac = "f(z)\\,f(x)\\,f(y)"
  }
  
  out = paste("Independence Assumption: $$",ind,"$$ Mass Factorization: $$f(x,y,z)=",fac,"$$
              Probability Parameters:
              $$
              p_{xyz}=f(x,y,z)
              $$
              Marginal Probabilities:
              $$\\begin{array}{rclcrcl}
              p_{x\\cdot\\cdot}&=&\\sum_{y,z}p_{xyz}&&
              p_{xy\\cdot}&=&\\sum_{z}p_{xyz}\\\\
              p_{\\cdot y\\cdot}&=&\\sum_{x,z}p_{xyz}&&
              p_{\\cdot yz}&=&\\sum_{x}p_{xyz}\\\\
              p_{\\cdot\\cdot z}&=&\\sum_{x,y}p_{xyz}&&p_{x\\cdot z}&=&\\sum_{y}p_{xyz}\\\\
              \\end{array}
              $$",sep="")
  
}

supp_3_fun  = function(model){
  if(model=="full_dep"){
    param = ""
    param_count = " N_X\\times N_Y\\times N_Z - 1"
  }else if(model=="part_indep"){
    param = "\\\\ 
    p_{xyz} &=& p_{xy\\cdot}\\,p_{\\cdot\\cdot z}"
    param_count = "N_Z - 1+ N_X\\times N_Y-1 "
  }else if(model=="cond_indep"){
    param = "\\\\ 
    p_{xyz} &=& p_{x\\cdot z}\\,p_{\\cdot yz}"
    param_count = " N_Z- 1 + (N_X-1)\\times N_Z+ (N_Y-1)\\times N_Z"
  }else if(model=="marg_indep"){
    param = "\\\\ 
    p_{xy\\cdot} &=& p_{x\\cdot \\cdot}\\,p_{\\cdot y\\cdot}"
    param_count = " (N_X-1)\\times(N_Y-1) + N_X\\times N_Y\\times(N_Z - 1)"
  }else{
    param = "\\\\ 
    p_{xyz} &=& p_{x\\cdot \\cdot}\\,p_{\\cdot y\\cdot}\\,p_{\\cdot \\cdot z}"
    param_count = "N_Z - 1+ N_X-1+N_Y - 1"
  }
  
  out = paste("
              Parameter Restrictions:
              $$
              \\begin{array}{rcl}
              p_{xyz}&\\geq &0\\\\
              \\sum_{x,y,x} p_{xyz} &=& 1
              ",param,"\\end{array}$$
              Number of Categories:
              $$
              \\begin{array}{rcl}
              \\text{Random Variable X} &=&N_X\\\\
              \\text{Random Variable Y} &=&N_Y\\\\
              \\text{Random Variable Z} &=&N_Z\\\\
              \\text{Total for Joint Distribution} &=& N_X\\times N_Y\\times N_Z
              \\end{array}
              $$
              Total Number of Parameters:
              $$
              d =
              ",param_count,"
              $$",sep="")
  
}

est_fun = function(model,tab){
  if(model=="full_dep"){
    out = tab/sum(tab)
  }else if(model=="part_ind"){
    p_xy = apply(tab,c(1,2),sum)/sum(tab)
    p_z = apply(tab,c(3),sum)/sum(tab)
    out = array(0,dim(tab))
    for(i in 1:(dim(tab)[3])){
      out[,,i] = p_xy*p_z[i]
    }
  }else if(model=="cond_indep"){
    p_z = apply(tab,c(3),sum)/sum(tab)
    out = array(0,dim(tab))
    for(i in 1:(dim(tab)[3])){
      tab_loc = tab[,,i]
      p_x = apply(tab_loc,c(1),sum)/sum(tab_loc)
      p_y = apply(tab_loc,c(2),sum)/sum(tab_loc)
      p_xy = outer(p_x,p_y,"*")
      out[,,i] = p_xy*p_z[i]
    }
  }else if(model=="marg_indep"){
      p_x = apply(tab,c(1),sum)/sum(tab)
      p_y = apply(tab,c(2),sum)/sum(tab)
      p_xy = outer(p_x,p_y,"*")
      out = array(0,dim(tab))
      for(i in 1:(dim(tab)[1])){
        for(j in 1:(dim(tab)[2])){
          out[i,j,] = tab[i,j,]/sum(tab[i,j,])*p_xy[i,j]
        }
      }
    }else{
      p_x = apply(tab,c(1),sum)/sum(tab)
      p_y = apply(tab,c(2),sum)/sum(tab)
      p_z = apply(tab,c(3),sum)/sum(tab)
      out = outer(outer(p_x,p_y,"*"),p_z,"*")
    }
  
  out
}

graph_fun = function(model){
  if(model=="full_dep"){
  out = "
      digraph {
  graph [overlap = true, fontsize = 4,  nodesep=0.5, layout=neato]
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=khaki,pos='0.5,-0.866!'] 
    Z
    
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=plum,pos='0,0!']
    X
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=pink,pos='1,0!']
    Y
    
  Z -> {X,Y}
  X -> {Y}
  
}
      "
  }else if(model=="part_indep"){
   out =  "
      digraph {
  graph [overlap = true, fontsize = 4,  nodesep=0.5, layout=neato]
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=khaki,pos='0.5,-0.866!'] 
    Z
    
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=plum,pos='0,0!']
    X
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=pink,pos='1,0!']
    Y
    
  X -> {Y}
  
}
      "
  }else if(model=="cond_indep"){
    out =  "
      digraph {
  graph [overlap = true, fontsize = 4,  nodesep=0.5, layout=neato]
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=khaki,pos='0.5,-0.866!'] 
    Z
    
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=plum,pos='0,0!']
    X
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=pink,pos='1,0!']
    Y
    
  Z -> {X,Y}
  
  
}
      "
  }else if(model=="marg_indep"){
    out =  "
      digraph {
  graph [overlap = true, fontsize = 4,  nodesep=0.5, layout=neato]
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=khaki,pos='0.5,-0.866!'] 
    Z
    
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=plum,pos='0,0!']
    X
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=pink,pos='1,0!']
    Y
    
  X -> {Z}
  Y -> {Z}
  
  
}
      "
  }else if(model=="cond_indep"){
    out =  "
      digraph {
  graph [overlap = true, fontsize = 4,  nodesep=0.5, layout=neato]
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=khaki,pos='0.5,-0.866!'] 
    Z
    
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=plum,pos='0,0!']
    X
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=pink,pos='1,0!']
    Y
    
  Z -> {X,Y}
  
  
}
      "
  }else{
    out =  "
      digraph {
  graph [overlap = true, fontsize = 4,  nodesep=0.5, layout=neato]
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=khaki,pos='0.5,-0.866!'] 
    Z
    
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=plum,pos='0,0!']
    X
  
  node [shape = circle, fontname = Helvetica, height=0.5, width=0.5,style=filled,fillcolor=pink,pos='1,0!']
    Y
    
    
}
      "
}
out
}


## Server function - inclusion of session as input is to allow for additional dynamic control of UIs (like slider bounds)
shinyServer(function(input, output, session) {
  warnings(-1)
  probs = eventReactive({ input$n_x; input$n_y; input$n_z; 
                         input$model_xyz; input$gen_new_probs},{
                           
                           {
                             if(input$model_xyz=="full_indep"){
                               prob_x = rgamma(as.integer(input$n_x),1,1)
                               prob_x = prob_x/sum(prob_x)
                               prob_y = rgamma(as.integer(input$n_y),1,1)
                               prob_y = prob_y/sum(prob_y)
                               prob_z = rgamma(as.integer(input$n_z),1,1)
                               prob_z = prob_z/sum(prob_z)
                               prob = outer(outer(prob_x,prob_y,"*"),prob_z,"*")
                             }else if(input$model_xyz=="part_indep"){
                               prob_xy = matrix(rgamma(as.integer(input$n_x)*as.integer(input$n_y),1,1),
                                                as.integer(input$n_x),as.integer(input$n_y))
                               prob_xy = prob_xy/sum(prob_xy)
                               prob_z = rgamma(as.integer(input$n_z),1,1)
                               prob_z = prob_z/sum(prob_z)
                               prob = outer(prob_xy,prob_z,"*")
                             }else if(input$model_xyz=="marg_indep"){
                               prob_z = rgamma(as.integer(input$n_z),1,1)
                               prob_z = prob_z/sum(prob_z)
                               prob_x = rgamma(as.integer(input$n_x),1,1)
                               prob_x = prob_x/sum(prob_x)
                               prob_y = rgamma(as.integer(input$n_y),1,1)
                               prob_y = prob_y/sum(prob_y)
                               prob_xy = outer(prob_x,prob_y,"*")
                               E = matrix(0,as.integer(input$n_x)*as.integer(input$n_y)+as.integer(input$n_z),
                                          as.integer(input$n_x)*as.integer(input$n_y)*as.integer(input$n_z))
                               f = rep(0,as.integer(input$n_x)*as.integer(input$n_y)+as.integer(input$n_z))
                               for(ell in 1:(as.integer(input$n_x)*as.integer(input$n_y))){
                                 for(k in 1:as.integer(input$n_z)){
                                   E[ell,ell+(k-1)*as.integer(input$n_x)*as.integer(input$n_y)] = prob_z[k]
                                 }
                               }
                               for(k in 1:input$n_z){
                                 E[as.integer(input$n_x)*as.integer(input$n_y)+k,
                                   1:(as.integer(input$n_x)*as.integer(input$n_y))+as.integer(input$n_x)*as.integer(input$n_y)*(k-1)] = 1
                               }
                               f = c(as.vector(prob_xy),rep(1,as.integer(input$n_z)))
                               G = diag(1,as.integer(input$n_x)*as.integer(input$n_y)*as.integer(input$n_z))
                               h = rep(0,as.integer(input$n_x)*as.integer(input$n_y)*as.integer(input$n_z))
                               samps = xsample(E=E,F=f,G=G,H=h,iter=rpois(1,10)+10,type = "rda",
                                               outputlength = 2)
                               prob_vec = samps$X[2,]*rep(prob_z,each=as.integer(input$n_x)*as.integer(input$n_y))
                               prob = array(prob_vec,dim=c(as.integer(input$n_x),as.integer(input$n_y),as.integer(input$n_z)))
                             }else if(input$model_xyz=="cond_indep"){
                               prob = array(NA,dim=c(as.integer(input$n_x),as.integer(input$n_y),as.integer(input$n_z)))
                               prob_z = rgamma(as.integer(input$n_z),1,1)
                               prob_z = prob_z/sum(prob_z)
                               for(i in 1:as.integer(input$n_z)){
                                 prob_x = rgamma(as.integer(input$n_x),1,1)
                                 prob_x = prob_x/sum(prob_x)
                                 prob_y = rgamma(as.integer(input$n_y),1,1)
                                 prob_y = prob_y/sum(prob_y)
                                 prob[,,i] = outer(prob_x,prob_y,"*")*prob_z[i]
                               }
                             }else{
                               prob = array(rgamma(as.integer(input$n_x)*as.integer(input$n_y)*as.integer(input$n_z),1,1),
                                            dim=c(as.integer(input$n_x),as.integer(input$n_y),as.integer(input$n_z)))
                               prob = prob/sum(prob)
                             }
                           }
                           if(as.integer(input$n_z)==2){
                             prob = array(c(as.vector(prob),rep(0,as.integer(input$n_x)*as.integer(input$n_y))),dim=c(as.integer(input$n_x),as.integer(input$n_y),3))
                           }
                           dimnames(prob) = list(paste("X=",c(1:input$n_x),sep=""),
                                                  paste("Y=",c(1:input$n_y),sep=""),
                                                  paste("Z=",c(1:3),sep=""))
                           prob
                         },ignoreNULL = FALSE)
  sample_table = eventReactive({probs(); input$gen_new_samps; input$n_samp},{
    {
      v = as.integer(input$n_x)*as.integer(input$n_y)*as.integer(input$n_z)
      sample_vec = factor(sample.int(v, as.integer(input$n_samp), prob = as.vector(probs()[,,c(1:(ifelse(as.integer(input$n_z)==2,2,3)))]), replace = TRUE),
                          levels = 1:v, labels = 1:v)
      sample_table = summary(sample_vec)
      names(sample_table) = NULL
      attr(sample_table,"dim") = c(as.integer(input$n_x),as.integer(input$n_y),as.integer(input$n_z))
    }
    if(as.integer(input$n_z)==2){
      sample_table = array(c(as.vector(sample_table),rep(0,as.integer(input$n_x)*as.integer(input$n_y))),dim=c(as.integer(input$n_x),as.integer(input$n_y),3))
    }
    dimnames(sample_table) = list(paste("X=",c(1:input$n_x),sep=""),
                           paste("Y=",c(1:input$n_y),sep=""),
                           paste("Z=",c(1:3),sep=""))
    sample_table
  },ignoreNULL = FALSE)
  est_table = eventReactive({sample_table()},{
    est_table = est_fun(input$model_xyz,sample_table())
    dimnames(est_table) = list(paste("X=",c(1:input$n_x),sep=""),
                           paste("Y=",c(1:input$n_y),sep=""),
                           paste("Z=",c(1:3),sep=""))
    est_table
  },ignoreNULL = FALSE)
  output$model_graph = renderGrViz({grViz(
  graph_fun(input$model_xyz)
  )
  })
  {
  output$table1 = renderTable({
    probs()[,,1]
  },
  bordered = TRUE,
  rownames=TRUE,
  colnames=TRUE,
  sanitize.text.function = function(x){x},digits=3)
  output$table2 = renderTable({
    probs()[,,2]
  },
  bordered = TRUE,
  rownames=TRUE,
  colnames=TRUE,
  sanitize.text.function = function(x){x},digits=3)
  output$table3 = renderTable({
    probs()[,,3]
  },
  bordered = TRUE,
  rownames=TRUE,
  colnames=TRUE,
  sanitize.text.function = function(x){x},digits=3)
  output$table7 = renderTable({
    sample_table()[,,1]
  },
  bordered = TRUE,
  rownames=TRUE,
  colnames=TRUE,
  sanitize.text.function = function(x){x},digits=0)
  output$table8 = renderTable({
    sample_table()[,,2]
  },
  bordered = TRUE,
  rownames=TRUE,
  colnames=TRUE,
  sanitize.text.function = function(x){x},digits=0)
  output$table9 = renderTable({
    sample_table()[,,3]
  },
  bordered = TRUE,
  rownames=TRUE,
  colnames=TRUE,
  sanitize.text.function = function(x){x},digits=0)
  output$table4 = renderTable({
    est_table()[,,1]
  },
  bordered = TRUE,
  rownames=TRUE,
  colnames=TRUE,
  sanitize.text.function = function(x){x},digits=3)
  output$table5 = renderTable({
    est_table()[,,2]
  },
  bordered = TRUE,
  rownames=TRUE,
  colnames=TRUE,
  sanitize.text.function = function(x){x},digits=3)
  output$table6 = renderTable({
    est_table()[,,3]
  },
  bordered = TRUE,
  rownames=TRUE,
  colnames=TRUE,
  sanitize.text.function = function(x){x},digits=3)
  }
  output$supp_2 = renderUI({withMathJax(
    supp_2_fun(input$model_xyz)
  )})
  output$supp_3 = renderUI({withMathJax(supp_3_fun(input$model_xyz))})
})
